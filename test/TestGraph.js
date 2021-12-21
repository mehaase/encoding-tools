import assert from 'assert';
import Graph from '../src/Graph.js';

describe('Graph', function () {
    it('should display a graph', function () {
        let node = new Graph();
        node.addEdge("a", "b");
        node.addEdge("a", "d");
        node.addEdge("b", "c");
        assert.equal(node.toString(),
            "a\n" +
            "  b\n" +
            "    c\n" +
            "  d\n");
    });

    it('should throw an error if an edge creates a cycle', function () {
        let node = new Graph();
        node.addEdge("a", "b");
        node.addEdge("b", "c");
        assert.throws(() => node.addEdge("c", "a"), Error);
        assert.equal(node.toString(),
            "a\n" +
            "  b\n" +
            "    c\n");
    });
});
