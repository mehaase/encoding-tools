import BaseGadget from './BaseGadget'

/**
 * Shared behavior for all change-of base gadgets.
 */
class BaseChangeBaseGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y);
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
}
