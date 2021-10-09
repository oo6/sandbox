import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  declare readonly sourceTarget: HTMLInputElement;

  static targets = ["source"];

  copy() {
    this.sourceTarget.select();
    document.execCommand("copy");
  }
}
