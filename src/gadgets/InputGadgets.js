import { Buffer } from "buffer";
import { writable } from "svelte/store";
import { cellSize } from "../Layout";
import { BaseGadget, OutputPort, DisplayState } from "./BaseGadget"
import gadgetRegistry from "./GadgetRegistry";

class BaseInputGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y, [], [new OutputPort()]);
        this.family = "Input";
        this.cssClass = "input";
        this.defaultHeight = 6 * cellSize;
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
        this.editableValue = writable("");
        let unsub = this.editableValue.subscribe((value) => this.transform(value));
        this.unsubscribes.push(unsub);
    }

    /**
     * Send the editable value to the output.
     */
    transform(value) {
        let data = Buffer.from(value, "utf-8");
        this.outputPorts[0].set(data);
    }
}
gadgetRegistry.register((...args) => new InputGadget(...args));
