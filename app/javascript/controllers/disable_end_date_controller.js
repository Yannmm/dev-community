import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="disable-end-date"
export default class extends Controller {
  static targets = ["endDateField", "switch"];

  connect() {
    this.disableEndDate();
  }

  initialize() {
    // this.element.setAttribute(
    //   "data-action",
    //   "click->disable-end-date#disableEndDate"
    // );
  }

  disableEndDate() {
    // const endDateElement = document.getElementById("work_experience_end_date");
    const endDateElement = this.endDateFieldTarget;
    const switch1 = this.switchTarget;
    if (switch1.checked) {
      endDateElement.value = null;
      endDateElement.setAttribute("disabled", true);
    } else {
      endDateElement.removeAttribute("disabled");
    }
  }
}
