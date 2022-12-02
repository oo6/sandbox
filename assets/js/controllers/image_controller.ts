import { Controller } from "@hotwired/stimulus";
import Croppr from "croppr";

export default class extends Controller {
  declare readonly fileTarget: HTMLInputElement;
  declare readonly imageTarget: HTMLImageElement;
  declare readonly formTarget: HTMLFormElement;

  declare readonly xTarget: HTMLInputElement;
  declare readonly yTarget: HTMLInputElement;
  declare readonly widthTarget: HTMLInputElement;
  declare readonly heightTarget: HTMLInputElement;

  static targets = ["file", "image", "form", "x", "y", "width", "height"];

  change(): void {
    const [file] = this.fileTarget.files as FileList;

    this.imageTarget.src = URL.createObjectURL(file);
    const croppr = new Croppr(this.imageTarget);

    this.formTarget.addEventListener("submit", () => {
      const { x, y, width, height } = croppr.getValue();

      this.xTarget.value = `${x}`;
      this.yTarget.value = `${y}`;
      this.widthTarget.value = `${width}`;
      this.heightTarget.value = `${height}`;
    });
  }
}
