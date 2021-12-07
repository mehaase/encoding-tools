// Gadget classes encapsulate behavior about gadgets.
export default class BaseGadget {
    /**
     * Initialize the gadget model to reasonable defaults.
     * TODO params
     */
    constructor(x, y) {
        this.family = null;
        this.title = null;
        this.cssClass = null;
        this.x = x;
        this.y = y;
        this.defaultWidth = 16;
        this.defaultHeight = 4;
    }

    transform(...inputs) {
        return [...inputs];
    }
}
