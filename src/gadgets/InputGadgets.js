import { Buffer } from "buffer";
import { writable } from "svelte/store";
import { cellSize } from "../Layout.js";
import { BaseGadget, OutputPort, DisplayState } from "./BaseGadget.js"
import gadgetRegistry from "./GadgetRegistry.js";

class BaseInputGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y, [], [new OutputPort()]);
        this.family = "Input";
        this.cssClass = "input";
        this.height = 6 * cellSize;
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
        // Input gadgets don't actually show the display value, but it is used
        // when the user clicks the copy button.
        this.display.set(DisplayState.display(value));
    }
}
gadgetRegistry.register((...args) => new InputGadget(...args));
