import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  timer?: number;

  declare readonly nameTarget: HTMLInputElement;

  declare readonly sourceTarget: HTMLInputElement;

  declare readonly slideTargets: Element[];

  static targets = ["name", "source", "slide"];

  get index(): number {
    const index = this.data.get("index");
    return index ? +index : 1;
  }

  set index(value: number) {
    this.data.set("index", value.toString());
    this.#show();
  }

  get length(): number {
    return this.slideTargets.length;
  }

  get name(): string {
    return this.nameTarget.value;
  }

  initialize(): void {
    if (location.pathname == "/stimulus/slideshow") {
      this.#show();
    }
  }

  connect(): void {
    if (location.pathname == "/stimulus/content_loader_vs_live_view") {
      this.#start();
    }
  }

  disconnect(): void {
    if (location.pathname == "/stimulus/content_loader_vs_live_view") {
      this.#stop();
    }
  }

  #show(): void {
    this.slideTargets.forEach((el, i) => {
      el.classList.toggle("hidden", this.index != i);
    });
  }

  #load(): void {
    const url = this.data.get("url");

    url &&
      fetch(url)
        .then((response) => response.text())
        .then((html) => {
          this.element.innerHTML = html;
        });
  }

  #start(): void {
    if (this.data.has("url")) {
      this.timer = window.setInterval(() => this.#load(), 1000);
    }
  }

  #stop(): void {
    window.clearInterval(this.timer);
  }

  greet(): void {
    if (!this.name) return;

    alert(`Hello, ${this.name}!`);
  }

  copy(): void {
    this.sourceTarget.select();
    navigator.clipboard.writeText(this.sourceTarget.value);
  }

  next(): void {
    const index = this.index + 1;
    this.index = index == this.length ? 0 : index;
  }

  previous(): void {
    const index = this.index - 1;
    this.index = index == -1 ? this.length - 1 : index;
  }
}
