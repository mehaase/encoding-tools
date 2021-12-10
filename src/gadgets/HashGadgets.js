import { BaseGadget, Port } from './BaseGadget'
import gadgetRegistry from './GadgetRegistry';

class BaseHashGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
        this.family = "Hash";
        this.cssClass = "hash";
        this.inputPorts.push(new Port());
        this.outputPorts.push(new Port());
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
gadgetRegistry.register((...args) => new Md5Gadget(...args));

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
gadgetRegistry.register((...args) => new Sha1Gadget(...args));

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
gadgetRegistry.register((...args) => new Sha2Gadget(...args));
