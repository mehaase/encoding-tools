import { cellSize } from "../Layout";

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
        this.width = 16 * cellSize;
        this.height = 4 * cellSize;
        this.inputPorts = new Array();
        this.outputPorts = new Array();
        this.isEditable = false;
    }

    /**
     * Move the gadget to the specified coordinate.
     * @param {number} x
     * @param {number} y
     */
    moveTo(x, y) {
        this.x = x;
        this.y = y;
    }

    /**
     * A hack for drag-and-drop, where setDragImage works differently if gadget has
     * input ports. Ports are 15 px tall.
     */
    getDragYOffset() {
        return this.inputPorts.length > 0 ? 15 : 0;
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
