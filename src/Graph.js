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
     * @param {Graph} root The node to begin the search at.
     * @returns Graph or null
     */
    static findNode(root, id) {
        let search = [...root.children];

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
     * Add an edge to the graph or throw an exception if the new edge violates any
     * graph constraints.
     * @param {string} sourceId
     * @param {string} targetId
     */
    addEdge(sourceId, targetId) {
        let source = Graph.findNode(this, sourceId);

        // If source doesn't already exist, then add it as a child of the current node.
        if (source == null) {
            source = new Graph(sourceId);
            this.children.push(source)
        }

        // If target doesn't exist, then it's a new leaf node.
        let target = Graph.findNode(this, targetId);
        if (target == null) {
            target = new Graph(targetId);
        }

        // A basic way to check for cycles: if the new edge is A -> B, then make sure
        // that A is not already reachable from B, i.e. not B -> * -> A.
        if (source === target || Graph.findNode(target, source.id)) {
            console.log(`Cycle detected while adding edge ${sourceId} -> ${targetId} to graph:`);
            console.log(this.toString());
            throw new Error(`You cannot connect gadgets into cycles.`);
        }

        source.children.push(target);
    }

    /**
     * Render the tree. Mainly for debugging purposes.
     * @param {string} indent
     */
    toString(indent = "") {
        let result = "";

        for (let child of this.children) {
            result += indent + child.id + "\n";
            result += child.toString(indent + "  ");
        }

        return result;
    }
}
