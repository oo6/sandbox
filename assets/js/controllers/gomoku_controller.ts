import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  declare readonly sourceTarget: HTMLInputElement;

  static targets = ["source"];

  copy(): void {
    this.sourceTarget.select();
    navigator.clipboard.writeText(this.sourceTarget.value);
  }
}
