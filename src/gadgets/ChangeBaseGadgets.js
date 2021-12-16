import { Buffer } from "buffer";
import { BaseGadget, InputPort, OutputPort, DisplayState } from "./BaseGadget.js";
import gadgetRegistry from "./GadgetRegistry.js";

/**
 * Shared behavior for all change-of base gadgets.
 */
class BaseChangeBaseGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y, [new InputPort()], [new OutputPort()]);
        this.family = "Change Base";
        this.cssClass = "change-base";
    }

    transform() {
        console.log("txform: change base");
    }
}

/**
 * Encode binary data to hex characters (base 16).
 */
export class HexEncodeGadget extends BaseChangeBaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "Hex Encode";
    }

    transform() {
        let in1 = this.inputPorts[0].value;

        if (in1.length > 0) {
            let display = in1.toString("hex");
            let data = Buffer.from(display, "utf8");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}
gadgetRegistry.register((...args) => new HexEncodeGadget(...args));

/**
 * Decode hex characters (base 16) to binary data.
 */
export class HexDecodeGadget extends BaseChangeBaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "Hex Decode";
    }

    transform() {
        let in1 = this.inputPorts[0].value;

        if (in1.length > 0) {
            let hexString = in1.toString("ascii");
            let data = Buffer.from(hexString, "hex");
            let display = data.toString("utf8");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}
gadgetRegistry.register((...args) => new HexDecodeGadget(...args));

/**
 * Encode binary data to base64 characters.
 */
export class Base64EncodeGadget extends BaseChangeBaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "Base64 Encode";
    }
}
gadgetRegistry.register((...args) => new Base64EncodeGadget(...args));

/**
 * Decode base64 characters to binary data.
 */
export class Base64DecodeGadget extends BaseChangeBaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "Base64 Decode";
    }
}
gadgetRegistry.register((...args) => new Base64DecodeGadget(...args));
