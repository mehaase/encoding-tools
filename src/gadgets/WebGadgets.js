import { BaseGadget, InputPort, OutputPort } from "./BaseGadget"
import gadgetRegistry from "./GadgetRegistry";

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

    transform() {
        console.log("txform: web");
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
}
gadgetRegistry.register((...args) => new HtmlDecodeGadget(...args));
