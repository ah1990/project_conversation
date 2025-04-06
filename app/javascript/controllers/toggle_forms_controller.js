import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "button"]

  toggle() {
    this.containerTarget.classList.toggle("hidden")
    this.buttonTarget.textContent = this.containerTarget.classList.contains("hidden") ? "Add Entry" : "Hide Forms"
  }
}
