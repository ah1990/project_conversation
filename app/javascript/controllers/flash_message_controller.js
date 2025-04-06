import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { 
    timeout: { type: Number, default: 3000 } // 3 seconds by default
  }

  connect() {
    // When controller connects, set a timeout to hide the message
    this.hideTimeout = setTimeout(() => {
      this.hide()
    }, this.timeoutValue)
  }

  disconnect() {
    // Clear timeout if controller disconnects
    if (this.hideTimeout) {
      clearTimeout(this.hideTimeout)
    }
  }

  hide() {
    // Add fade-out animation
    this.element.classList.add('opacity-0')
    
    // Remove element after animation completes
    setTimeout(() => {
      this.element.remove()
    }, 500) // 500ms for animation to complete
  }
}
