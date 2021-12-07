import BaseGadget from './BaseGadget'

class BaseHashGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.family = "Hash";
        this.cssClass = "hash";
    }
}

export class Md5Gadget extends BaseHashGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "MD5";
    }
}

export class Sha1Gadget extends BaseHashGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "SHA-1";
    }
}

export class Sha2Gadget extends BaseHashGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.title = "SHA-2";
    }
}
