/**
 * This class helps keep track of the topology of gadgets and prevent undesirable
 * situations, e.g. cycles in the graph.
 */
export default class Graph {
    /**
     * Constructor.
     * @param {string?} id
     */
    constructor(id = null) {
        this.id = id;
        this.children = [];
    }

    /**
     * Search recursively through the graph to find a node.
     * @returns Graph or null
     */
    findNode(id) {
        let search = [...this.children];

        while (search.length > 0) {
            let node = search.pop();
            if (node.id === id) {
                return node;
            }
            for (let child of node.children) {
                search.push(child);
            }
        }

        return null;
    }

    /**
     * Search for a node's parent.
     * @param {*} sourceId
     * @param {*} targetId
     */
    findParent(queryNode) {
        let search = [...this.children];

        while (search.length > 0) {
            let node = search.pop();
            if (node.children.indexOf(queryNode) !== -1) {
                return node;
            }
        }

        return null;
    }

    /**
     * Add an edge to the graph or throw an exception if the new edge violates any
     * graph constraints.
     * @param {string} sourceId
     * @param {string} targetId
     */
    addEdge(sourceId, targetId) {
        let source = this.findNode(sourceId);

        // If source doesn't already exist, then add it as a child of the root node.
        if (source === null) {
            source = new Graph(sourceId);
            this.children.push(source)
        }

        // If target doesn't exist, then it's a new leaf node. If it does exist and its
        // one of the roots, then it needs to be removed from the roots.
        let target = this.findNode(targetId);
        if (target === null) {
            target = new Graph(targetId);
        }

        // A basic way to check for cycles: if the new edge is A -> B, then make sure
        // that A is not already reachable from B, i.e. not B -> * -> A.
        if (source === target || target.findNode(source.id)) {
            console.log(`Cycle detected while adding edge ${sourceId} -> ${targetId} to graph:`);
            console.log(this.toString());
            throw new Error(`You cannot connect gadgets into cycles.`);
        }

        // If the sanity checks pass, then update the graph's edges.
        let targetIndex = this.children.indexOf(target);
        if (targetIndex !== -1) {
            this.children.splice(targetIndex, 1);
        }

        source.children.push(target);
    }

    /**
     * Remove an edge from the graph.
     * @param {string} sourceId
     * @param {string} targetId
     */
    removeEdge(sourceId, targetId) {
        let source = this.findNode(sourceId);
        let target = this.findNode(targetId);

        // Remove the target from the source's children.
        let targetIndex = source.children.indexOf(target);
        source.children.splice(targetIndex, 1);

        // Move the target to the root.
        this.children.push(target);
    }

    /**
     * Render the tree. Mainly for debugging purposes.
     * @param {string} indent
     */
    toString(indent = "") {
        let result = "";

        let sortedChildren = [...this.children];
        sortedChildren.sort((n1, n2) => n1.id.localeCompare(n2.id));

        for (let child of sortedChildren) {
            result += indent + child.id + "\n";
            result += child.toString(indent + "  ");
        }

        return result;
    }
}
