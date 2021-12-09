/**
 * Stores useful metadata about each gadget.
 */
class GadgetRegistration {
    /**
     * Constructor.
     * @param {string} classId
     * @param {string} family
     * @param {string} title
     * @param {string} cssClass
     */
    constructor(classId, family, title, cssClass) {
        this.classId = classId;
        this.family = family;
        this.title = title;
        this.cssClass = cssClass;
    }
}

/**
 * A hybrid factory/registry for gadget objects.
 *
 * The main design goal is to construct gadgets based on a unique classId, which is
 * necessary since only strings can be passed through drag-and-drop.
 */
class GadgetRegistry {
    /**
     * Constructor.
     */
    constructor() {
        this.gadgetRegistrations = [];
        this.gadgetBuildersByClassId = {};
    }

    /**
     * Build a new gadget with the specified classId.
     * @param {string} classId
     * @param {...any} args Arguments passed to the builder.
     */
    build(classId, ...args) {
        let builder = this.gadgetBuildersByClassId[classId];
        if (!builder) {
            throw new Error(`No builder found for "${classId}".`);
        }
        return builder(...args);
    }

    /**
     * @returns Array of GadgetRegistration
     */
    list() {
        return this.gadgetRegistrations;
    }

    /**
     * Register a new gadget. Since JavaScript does not treat classes as objects, we
     * must pass in a builder function that creates a specific class of gadget.
     * @param {function} gadgetBuilder A function that can build instances of a gadget
     * class.
     */
    register(gadgetBuilder) {
        let gadget = gadgetBuilder();
        let classId = gadget.getClassId();
        if (classId in this.gadgetBuildersByClassId) {
            throw new Error(`Attempted to register gadget "${classId}" twice.`);
        }
        let reg = new GadgetRegistration(
            classId,
            gadget.family,
            gadget.title,
            gadget.cssClass
        );
        this.gadgetRegistrations.push(reg);
        this.gadgetBuildersByClassId[classId] = gadgetBuilder;
    }
}

let gadgetRegistry = new GadgetRegistry();
export default gadgetRegistry;
