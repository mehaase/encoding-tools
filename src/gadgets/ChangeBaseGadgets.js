import { Buffer } from "buffer";
import { BaseGadget, DisplayState, InputPort, OutputPort } from "./BaseGadget.js";

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

    /**
     * Override BaseGadget#transform() to hex encode inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            let display = in0.toString("hex");
            let data = Buffer.from(display, "utf8");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}

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

    /**
     * Override BaseGadget#transform() to hex decode inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            try {
                let hexString = in0.toString("ascii");
                let data = Buffer.from(hexString, "hex");
                let display = data.toString("utf8");
                this.display.set(DisplayState.display(display));
                this.outputPorts[0].set(data);
            } catch (e) {
                this.display.set(DisplayState.error(e));
            }
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}

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

    /**
     * Override BaseGadget#transform() to base64 encode inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            let display = in0.toString("base64");
            let data = Buffer.from(display, "utf8");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}

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

    /**
     * Override BaseGadget#transform() to base64 decode inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        // The Buffer implementation pads out inputs as neccessary, so we don't need
        // validate base64 padding ourselves.
        if (in0.length > 0) {
            try {
                let base64String = in0.toString("ascii");
                let data = Buffer.from(base64String, "base64");
                let display = data.toString("utf8");
                this.display.set(DisplayState.display(display));
                this.outputPorts[0].set(data);
            } catch (e) {
                console.log("caught", e);
            }
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(Buffer.from);
        }
    }
}
