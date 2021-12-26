import assert from 'assert';
import Graph from '../src/Graph.js';

describe('Graph', function () {
    it('should create a graph', function () {
        let g = new Graph();
        g.addEdge("a", "b");
        g.addEdge("b", "c");
        g.addEdge("a", "d");
        assert.equal(g.toString(),
            "a\n" +
            "  b\n" +
            "    c\n" +
            "  d\n");
    });

    it('should handle edges added out of order', function () {
        let g = new Graph();
        g.addEdge("b", "c");
        g.addEdge("a", "b");
        assert.equal(g.toString(),
            "a\n" +
            "  b\n" +
            "    c\n");
    });

    it('should throw an error if an edge creates a cycle', function () {
        let g = new Graph();
        g.addEdge("a", "b");
        g.addEdge("b", "c");
        assert.throws(() => g.addEdge("c", "a"), Error);
        assert.equal(g.toString(),
            "a\n" +
            "  b\n" +
            "    c\n");
    });

    it('it should remove an edge to a leaf node', function () {
        let g = new Graph();
        g.addEdge("a", "b");
        g.addEdge("b", "c");
        g.addEdge("c", "d");
        assert.equal(g.toString(),
            "a\n" +
            "  b\n" +
            "    c\n" +
            "      d\n");
        g.removeEdge("c", "d");
        // Note that d is still in the graph, but it's not a child of c so it becomes
        // one of the roots.
        assert.equal(g.toString(),
            "a\n" +
            "  b\n" +
            "    c\n" +
            "d\n");
    });

    it('should remove an edge to a branch node', function () {
        let g = new Graph();
        g.addEdge("a", "b");
        g.addEdge("b", "c");
        g.addEdge("c", "d");
        assert.equal(g.toString(),
            "a\n" +
            "  b\n" +
            "    c\n" +
            "      d\n");
        g.removeEdge("b", "c");
        // Note that d is still in the graph, but it's not a child of c so it becomes
        // one of the roots.
        assert.equal(g.toString(),
            "a\n" +
            "  b\n" +
            "c\n" +
            "  d\n");
    });

    it('should remove an edge from a root', function () {
        let g = new Graph();
        g.addEdge("a", "b");
        g.addEdge("b", "c");
        g.addEdge("c", "d");
        assert.equal(g.toString(),
            "a\n" +
            "  b\n" +
            "    c\n" +
            "      d\n");
        g.removeEdge("a", "b");
        // Note that a is still in the graph, but it has no children.
        assert.equal(g.toString(),
            "a\n" +
            "b\n" +
            "  c\n" +
            "    d\n");
    });
});
