import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="connections"
export default class extends Controller {
  static targets = ["connection"];

  connect() {}

  initialize() {
    this.element.setAttribute(
      "data-action",
      "click->connections#prepareConnectionParams"
    );
  }

  prepareConnectionParams() {
    event.preventDefault();
    this.url = this.element.getAttribute("href");

    const element = this.connectionTarget;
    const requester_id = element.dataset.requester_id;
    const connected_id = element.dataset.connected_id;

    const connectionBody = new FormData();

    connectionBody.append("connection[user_id]", requester_id);
    connectionBody.append("connection[connected_user_id]", connected_id);
    connectionBody.append("connection[status]", "pending");

    fetch(this.url, {
      method: "POST",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: connectionBody,
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }
}
