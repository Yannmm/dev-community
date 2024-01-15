import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="edit-user-description"
export default class extends Controller {
  connect() {
    console.log("xxxxxxx is connected!!!");
  }

  initialize() {
    this.element.setAttribute(
      "data-action",
      "click->edit-user-description#showModal"
    );
  }

  showModal(event) {
    console.log("this111111111111");
    event.preventDefault();
    this.url = this.element.getAttribute("href");
    fetch(this.url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then((response) => response.text())
      .then((html) => {
        console.log(html);
        return Turbo.renderStreamMessage(html);
      });
  }
}
