import { Buffer } from "buffer";
import { writable } from "svelte/store";
import slug from "../slug.js";
import { cellSize } from "../Layout.js";

let gadgetCounter = 0;

// Gadget classes encapsulate behavior about gadgets.
export class BaseGadget {
    /**
     * Initialize the gadget model to reasonable defaults.
     * @param {number} x
     * @param {number} y
     */
    constructor(x, y, inputPorts, outputPorts) {
        this.id = gadgetCounter++;
        this.family = null;
        this.title = null;
        this.cssClass = null;
        this.x = x;
        this.y = y;
        this.width = 16 * cellSize;
        this.height = 4 * cellSize;
        this.inputPorts = inputPorts;
        this.outputPorts = outputPorts;
        this.editableValue = null;
        this.display = writable(new DisplayState());
        this.unsubscribes = [];

        // Subscribe to inputs after the outputs are initialized, because input ports
        // can start calling transform() immediately, and we need outputs to be ready.
        for (let inputPort of this.inputPorts) {
            let unsub = inputPort.store.subscribe((value) => this.transform());
            this.unsubscribes.push(unsub);
        }
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
     * Generate a unique ID that is a combination of the class ID and a unique sequence.
     * @returns Strin
     */
    getId() {
        return this.getClassId() + "#" + this.id;
    }

    /**
     * Return a unique ID for the gadget class.
     */
    getClassId() {
        return slug(`${this.family}.${this.title}`);
    }

    /**
     * The transform function is the core logic for each gadget. It is called whenever
     * any input port receives new data. Subclasses must override this method to:
     *
     * - Read and process inputs.
     * - Update the displayed value.
     * - Publish new data to the outputs.
     *
     * Each input port accepts a Buffer, and each transform must write a Buffer to its
     * output port. A Buffer of length zero indicates a null result, e.g. because the
     * transform has an unconnected input, has an internal, etc.
     * @returns The inputs as a new array.
     */
    transform() {
        throw new Error("Subclasses must implement transform().")
    }

    /**
     * Clean up resources used by this object.
     */
    destroy() {
        for (let inputPort of this.inputPorts) {
            inputPort.disconnect();
        }
        for (let unsubscribe of this.unsubscribes) {
            unsubscribe();
        }
    }
}

/**
 * Represents the gadget's displayed contents.
 */
export class DisplayState {
    /**
     * Constructor. Recommended not to call this directly; use the static methods.
     * @param {string} text
     * @param {string} error
     */
    constructor(text, error) {
        this.text = text;
        this.error = error;
    }

    /**
     * @returns A null display state (no text or error)
     */
    static null() {
        return new DisplayState(null, null);
    }

    /**
     * @param {string} text The text to display
     * @returns A display state containing text
     */
    static display(text) {
        return new DisplayState(text, null);
    }

    /**
     *
     * @param {string} error The error message to display
     * @returns An error state
     */
    static error(error) {
        return new DisplayState(null, error);
    }

    /**
     * @returns true if this is an error state
     */
    hasError() {
        return this.error !== null;
    }

    /**
     * @returns true if this is a null state
     */
    isNull() {
        return this.text === null;
    }
}

/**
 * When an input port is connected to an output port, it subscribes to the
 * output port's data. When it receives new data, it latches the new value
 * and notifies its gadget.
 */
export class InputPort {
    /**
     * Constructor.
     */
    constructor() {
        this.value = Buffer.from([]);
        this.unsubscribe = null;
        this.store = writable(this.value);
        this.connected = false;
    }

    /**
     * Subscribe to data from an output port
     * @param {Output} outputPort
     */
    connectTo(outputPort) {
        this.connected = true;
        this.unsubscribe = outputPort.store.subscribe(
            (value) => {
                this.value = value;
                this.store.set(value);
            }
        );
    }

    /**
     * Disconnect from current output port, if any.
     */
    disconnect() {
        this.connected = false;
        if (this.unsubscribe !== null) {
            this.unsubscribe();
            this.unsubscribe = null;
        }
        this.value = Buffer.from([]);
        this.store.set(this.value);
    }
}

/**
 * An output port publishes output data to any ports connected to it.
 */
export class OutputPort {
    /**
     * Constructor
     */
    constructor() {
        this.store = writable(Buffer.from([]));
    }

    /**
     * Publish data on this port.
     * @param {Buffer} data
     */
    set(data) {
        if (data === null) {
            data = Buffer.from([]);
        }
        this.store.set(data);
    }
}
