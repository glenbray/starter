import { Controller } from "stimulus";
import StimulusReflex from "stimulus_reflex";

export default class extends Controller {
  connect() {
    StimulusReflex.register(this);
  }

  beforeReflex() {
    this.benchmark = performance.now();
  }

  afterReflex(element, reflex) {
    console.log(reflex, `${(performance.now() - this.benchmark).toFixed(0)}ms`);
  }
}
