import {Controller} from "stimulus"
import {LiveSocket} from "phoenix_live_view"

export default class extends Controller {
  static targets = ["source"]

  copy() {
    this.sourceTarget.select()
    document.execCommand("copy")
  }
}
