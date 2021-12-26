import { Buffer } from "buffer";
import CryptoES from "crypto-es";
import { WordArray } from "crypto-es/lib/core.js"
import { BaseGadget, DisplayState, InputPort, OutputPort } from "./BaseGadget.js";


export function convertBufferToWordArray(buffer) {
    let words = [];
    let nextWord = 0;

    for (let i = 0; i < buffer.length; i++) {
        switch (i % 4) {
            case 0:
                nextWord |= buffer[i] << 24;
                break;
            case 1:
                nextWord |= buffer[i] << 16;
                break;
            case 2:
                nextWord |= buffer[i] << 8;
                break;
            case 3:
                nextWord |= buffer[i];
                words.push(nextWord)
                nextWord = 0;
                break;
        }
    }

    return WordArray.create(words, buffer.length);
}

export function convertWordArrayToBuffer(wordArray) {
    let bytes = [];

    if (wordArray.sigBytes % 4 != 0) {
        throw new Error("Word array sigBytes must be multiple of 4");
    }

    for (let word of wordArray.words) {
        bytes.push(word >> 24);
        bytes.push((word >> 16) & 0xff);
        bytes.push((word >> 8) & 0xff);
        bytes.push(word & 0xff);
    }

    return Buffer.from(bytes);
}

class BaseHashGadget extends BaseGadget {
    /**
     * @param {int} x
     * @param {int} y
     */
    constructor(x, y) {
        super(x, y, [new InputPort()], [new OutputPort()]);
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

    /**
     * Override BaseGadget#transform() to MD5 hash inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            let wordArray = convertBufferToWordArray(in0);
            let digest = CryptoES.MD5(wordArray)
            let data = convertWordArrayToBuffer(digest);
            let display = data.toString("hex");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
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

    /**
     * Override BaseGadget#transform() to SHA-1 hash inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            let wordArray = convertBufferToWordArray(in0);
            let digest = CryptoES.SHA1(wordArray)
            let data = convertWordArrayToBuffer(digest);
            let display = data.toString("hex");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
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

    /**
     * Override BaseGadget#transform() to SHA-2 hash inputs.
     */
    transform() {
        const in0 = this.inputPorts[0].value;

        if (in0.length > 0) {
            let wordArray = convertBufferToWordArray(in0);
            let digest = CryptoES.SHA256(wordArray)
            let data = convertWordArrayToBuffer(digest);
            let display = data.toString("hex");
            this.display.set(DisplayState.display(display));
            this.outputPorts[0].set(data);
        } else {
            this.display.set(DisplayState.null());
            this.outputPorts[0].set(null);
        }
    }
}
