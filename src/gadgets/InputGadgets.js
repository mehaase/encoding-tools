import BaseGadget from './BaseGadget'
import gadgetRegistry from './GadgetRegistry';

class BaseInputGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.family = "Input";
        this.cssClass = "input";
        this.defaultHeight = 6 * 20;
    }
}

export class InputGadget extends BaseInputGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "Text Input";
    }
}
gadgetRegistry.register((...args) => new InputGadget(...args));
