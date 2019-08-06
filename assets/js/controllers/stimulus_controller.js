import {Controller} from "stimulus"

export default class extends Controller {
  static targets = ["name", "source", "slide"]

  get index() {
    return +this.data.get("index")
  }

  set index(value) {
    this.data.set("index", value)
    this._show()
  }

  get length() {
    return this.slideTargets.length
  }

  get name() {
    return this.nameTarget.value
  }

  initialize() {
    if (location.pathname == "/stimulus/slideshow") {
      this._show()
    }
  }

  connect() {
    if (location.pathname == "/stimulus/content_loader_vs_live_view") {
      this._start()
    }
  }

  disconnect() {
    if (location.pathname == "/stimulus/content_loader_vs_live_view") {
      this._stop()
    }
  }

  _show() {
    this.slideTargets.forEach((el, i) => {
      el.classList.toggle("slide--show", this.index == i)
    })
  }

  _load() {
    fetch(this.data.get("url"))
      .then(response => response.text())
      .then(html => {
        this.element.innerHTML = html
      })
  }

  _start() {
    if (this.data.has("url")) {
      this.timer = setInterval(() => this._load(), 1000)
    }
  }

  _stop() {
    this.timer && clearInterval(this.timer)
  }

  greet() {
    if (!this.name) return

    alert(`Hello, ${this.name}!`)
  }

  copy() {
    this.sourceTarget.select()
    document.execCommand("copy")
  }

  next() {
    const index = this.index + 1
    this.index = index == this.length ? 0 : index
  }

  previous() {
    const index = this.index - 1
    this.index = index == -1 ? this.length - 1 : index
  }

  adjust() {
    const body = this.element.contentDocument.querySelector("body")

    body.style.margin = 0
    body.querySelector("header").style.display = "none"
    body.querySelector("main").style.padding = 0

    this.element.classList.remove("stimulus-live-view--hide")
  }
}
