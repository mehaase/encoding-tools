import BaseGadget from './BaseGadget'

class BaseWebGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
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
}

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

export class HtmlEncodeGadget extends BaseWebGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "URL Encode";
    }
}

export class HtmlDecodeGadget extends BaseWebGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "URL Decode";
    }
}
