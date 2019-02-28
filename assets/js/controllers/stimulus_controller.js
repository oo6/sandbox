import {Controller} from "stimulus"

export default class extends Controller {
  static targets = ["name", "source", "slide"]

  get index() {
    return +this.data.get("index")
  }

  set index(value) {
    this.data.set("index", value)
    this._showCurrentSlide()
  }

  get length() {
    return this.slideTargets.length
  }

  initialize() {
    if (location.pathname == "/stimulus/slideshow") {
      this._show()
    }
  }

  connect() {
    if (location.pathname == "/stimulus/content_loader") {
      this._start()
    }
  }

  disconnect() {
    if (location.pathname == "/stimulus/content_loader") {
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
    this._load()

    if (this.data.has("interval")) {
      this.timer = setInterval(() => this._load(), this.data.get("interval"))
    }
  }

  _stop() {
    this.timer && clearInterval(this.timer)
  }

  greet() {
    const name = this.nameTarget.value
    if (!this.name) return

    alert(`Hello, ${this.name}!`)
  }

  copy() {
    this.sourceTarget.select()
    document.execCommand("copy")
  }

  next() {
    const index = this.index + 1;
    this.index = index == this.length ? 0 : index
  }

  previous() {
    const index = this.index - 1;
    this.index = index == -1 ? this.length - 1 : index
  }
}
