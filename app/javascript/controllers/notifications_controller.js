import { Controller } from "stimulus";
import Noty from "noty";

export default class extends Controller {
  connect() {
    const flashes = JSON.parse(this.data.get("flash"));

    if (flashes === null || flashes.length === 0) return;

    flashes.forEach(flash => {
      const type = flash[0];
      const message = flash[1];
      this.notify(type, message);
    });

    window.notify = this.notify;
  }

  notify(type, message) {
    new Noty({
      type: type,
      text: message,
      progressBar: true,
      layout: "bottomRight",
      timeout: 5000
    }).show();
  }
}
