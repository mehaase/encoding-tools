let gadgetCounter = 0;

// Gadget classes encapsulate behavior about gadgets.
export class BaseGadget {
    /**
     * Initialize the gadget model to reasonable defaults.
     * @param {number} x
     * @param {number} y
     */
    constructor(x, y) {
        this.id = gadgetCounter++;
        this.family = null;
        this.title = null;
        this.cssClass = null;
        this.x = x;
        this.y = y;
        this.defaultWidth = 16 * 20;
        this.defaultHeight = 4 * 20;
        this.inputPorts = new Array();
        this.outputPorts = new Array();
        this.isEditable = false;
    }

    /**
     * Return a unique ID for the gadget class.
     */
    getClassId() {
        let temp = `${this.family}.${this.title}`;
        return temp.toLocaleLowerCase().replace(/ /g, "_");
    }

    /**
     * The default transform is an identity function. Subclasses must
     * override this.
     * @param  {...any} inputs
     * @returns The inputs as a new array.
     */
    transform(...inputs) {
        return [...inputs];
    }
}

/**
 * This is a dummy class for now, but reserved for future expansion
 * of features on ports.
 */
export class Port {
    constructor() {
    }
}
