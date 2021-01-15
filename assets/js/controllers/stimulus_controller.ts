import { Controller } from "stimulus";

export default class extends Controller {
  timer: number;

  nameTarget: HTMLInputElement;

  sourceTarget: HTMLInputElement;

  slideTargets: Element[];

  static targets = ["name", "source", "slide"];

  get index(): number {
    const index = this.data.get("index");
    return index ? +index : 1;
  }

  set index(value: number) {
    this.data.set("index", value.toString());
    this._show();
  }

  get length(): number {
    return this.slideTargets.length;
  }

  get name(): string {
    return this.nameTarget.value;
  }

  initialize() {
    if (location.pathname == "/stimulus/slideshow") {
      this._show();
    }
  }

  connect() {
    if (location.pathname == "/stimulus/content_loader_vs_live_view") {
      this._start();
    }
  }

  disconnect() {
    if (location.pathname == "/stimulus/content_loader_vs_live_view") {
      this._stop();
    }
  }

  _show() {
    this.slideTargets.forEach((el, i) => {
      el.classList.toggle("hidden", this.index != i);
    });
  }

  _load() {
    const url = this.data.get("url");

    url &&
      fetch(url)
        .then((response) => response.text())
        .then((html) => {
          this.element.innerHTML = html;
        });
  }

  _start() {
    if (this.data.has("url")) {
      this.timer = window.setInterval(() => this._load(), 1000);
    }
  }

  _stop() {
    this.timer && window.clearInterval(this.timer);
  }

  greet() {
    if (!this.name) return;

    alert(`Hello, ${this.name}!`);
  }

  copy() {
    this.sourceTarget.select();
    document.execCommand("copy");
  }

  next() {
    const index = this.index + 1;
    this.index = index == this.length ? 0 : index;
  }

  previous() {
    const index = this.index - 1;
    this.index = index == -1 ? this.length - 1 : index;
  }
}
