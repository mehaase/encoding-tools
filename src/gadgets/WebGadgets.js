import { Buffer } from "buffer";
import entities from "entities";
import { BaseGadget, DisplayState, InputPort, OutputPort } from "./BaseGadget.js"
import gadgetRegistry from "./GadgetRegistry.js";

class BaseWebGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y, [new InputPort()], [new OutputPort()]);
        this.family = "Web";
        this.cssClass = "web";
    }
}

export class UrlEncodeGadget extends BaseWebGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "URL Encode";
    }

    /**
     * Override BaseGadget#transform() to URL encode inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            let dataString = in0.toString("utf8");
            let display = encodeURIComponent(dataString);
            let data = Buffer.from(display, "utf8");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}
gadgetRegistry.register((...args) => new UrlEncodeGadget(...args));

export class UrlDecodeGadget extends BaseWebGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "URL Decode";
    }

    /**
     * Override BaseGadget#transform() to URL decode inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            try {
                let dataString = in0.toString("utf8");
                let display = decodeURIComponent(dataString);
                let data = Buffer.from(display, "utf8");
                this.display.set(DisplayState.display(display));
                this.outputPorts[0].set(data);
            } catch (e) {
                this.display.set(DisplayState.error(e.message));
                this.outputPorts[0].set(null);
            }
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}
gadgetRegistry.register((...args) => new UrlDecodeGadget(...args));

export class HtmlEncodeGadget extends BaseWebGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "HTML Encode";
    }

    /**
     * Override BaseGadget#transform() to HTML encode inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            let dataString = in0.toString("utf8");
            let display = entities.encodeHTML(dataString);
            let data = Buffer.from(display, "utf8");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}
gadgetRegistry.register((...args) => new HtmlEncodeGadget(...args));

export class HtmlDecodeGadget extends BaseWebGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "HTML Decode";
    }

    /**
     * Override BaseGadget#transform() to HTML decode inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            let dataString = in0.toString("utf8");
            let display = entities.decodeHTML(dataString);
            let data = Buffer.from(display, "utf8");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}
gadgetRegistry.register((...args) => new HtmlDecodeGadget(...args));
