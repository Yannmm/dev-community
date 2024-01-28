import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="update-connection-status"
export default class extends Controller {
  connect() {}

  initialize() {
    this.element.setAttribute(
      "data-action",
      "click->update-connection-status#updateConnectionStatus"
    );
  }

  updateConnectionStatus() {
    event.preventDefault();
    this.url = this.element.getAttribute("href");

    const form = new FormData();

    if (this.element.textContent == "Accept") {
      form.append("connection[status]", "accepted");
    } else if (this.element.textContent == "Reject") {
      form.append("connection[status]", "rejected");
    }

    fetch(this.url, {
      method: "PATCH",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: form,
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }
}
