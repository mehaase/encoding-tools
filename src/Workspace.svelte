<script>
    import Edge from "./Edge.svelte";
    import Gadget from "./Gadget.svelte";
    import Graph from "./Graph.js";
    import { navbarHeight } from "./Layout.js";
    import gadgetRegistry from "./gadgets/GadgetRegistry.js";
    import { InputPort, OutputPort } from "./gadgets/BaseGadget.js";

    // All gadget modules are imported just to trigger the side effect of adding them
    // to the registry.
    import {} from "./gadgets/ChangeBaseGadgets.js";
    import {} from "./gadgets/HashGadgets.js";
    import { InputGadget } from "./gadgets/InputGadgets.js";
    import {} from "./gadgets/WebGadgets.js";

    let nextEdgeId = 0;
    let graph = new Graph();

    /**
     * Edges as concept only exist within the Workspace as way to store the state of
     * the edges that are drawn on the screen, but each gadget's ports publish data
     * directly to each other and do not go through this class.
     */
    class EdgeModel {
        /**
         * Constructor
         * @param x X coordinate for edge's starting location
         * @param y Y coordinate for edge's starting location
         */
        constructor(x, y, sourceGadgetId, sourcePort) {
            this.id = nextEdgeId++;
            this.coords = { x1: x, y1: y, x2: x, y2: y };
            this.sourceGadgetId = sourceGadgetId;
            this.sourcePort = sourcePort;
            this.destGadgetId = null;
            this.destPort = null;
        }

        /**
         * Set the edge's destination, i.e. the gadget/port that it is connected to.
         * @param gadgetId
         * @param port
         */
        setDest(gadgetId, port) {
            // Make sure that the source port is always an output port, and destination
            // is always an input.
            if (this.sourcePort instanceof InputPort) {
                this.destGadgetId = this.sourceGadgetId;
                this.destPort = this.sourcePort;
                this.sourceGadgetId = gadgetId;
                this.sourcePort = port;
            } else {
                this.destGadgetId = gadgetId;
                this.destPort = port;
            }

            if (
                (this.sourcePort instanceof InputPort &&
                    this.destPort instanceof InputPort) ||
                (this.sourcePort instanceof OutputPort &&
                    this.destPort instanceof OutputPort)
            ) {
                throw new Error(
                    "Input ports can only be connected to output ports, and vice-versa."
                );
            }
            graph.addEdge(this.sourceGadgetId, this.destGadgetId);
            this.destPort.connectTo(this.sourcePort);
        }

        /**
         * Move the endpoint to the specified coordinates. This method is used while the
         * user is dragging out a new edge to make the edge follow the cursor.
         * @param x
         * @param y
         */
        moveEndTo(x, y) {
            this.coords.x2 = x;
            this.coords.y2 = y;
        }

        /**
         * Disconnect source port from target port.
         */
        disconnect() {
            graph.removeEdge(this.sourceGadgetId, this.destGadgetId);
            this.destPort.disconnect();
        }
    }

    let newEdge = null;
    let edges = [];
    let defaultInput = new InputGadget(1 * 20, 1 * 20);
    let gadgets = [defaultInput];

    // Handle drag-over events in the workspace.
    //
    // This is used to drag gadgets from the drawer and drop them onto the
    // workspace.
    function handleDragOver(event) {
        event.preventDefault();
    }

    // Handle drop events in the workspace.
    //
    // This is used to drag gadgets from the drawer and drop them onto the
    // workspace.
    function handleDrop(event) {
        event.preventDefault();
        let gadgetInfo = JSON.parse(
            event.dataTransfer.getData("application/vnd.encodingtools-gadget")
        );
        let newGadget = gadgetRegistry.build(
            gadgetInfo.classId,
            event.clientX - gadgetInfo.offsetX + 1,
            event.clientY - gadgetInfo.offsetY - navbarHeight + 1
        );

        gadgets.push(newGadget);
        gadgets = gadgets;
    }

    // Handle new edge creation.
    function handleStartEdge(event) {
        let { gadgetId, port, x, y } = event.detail;
        y -= navbarHeight;
        newEdge = new EdgeModel(x, y, gadgetId, port);
        document.addEventListener("mousemove", handleMoveEdge);
        document.addEventListener("mouseup", handleEndEdge);
    }

    // On mousemove, move the edge to the event location.
    function handleMoveEdge(event) {
        newEdge.moveEndTo(event.clientX, event.clientY - navbarHeight);
        newEdge = newEdge;
    }

    // On mouseup, destroy the current edge.
    function handleEndEdge(event) {
        newEdge = null;
        document.removeEventListener("mousemove", handleMoveEdge);
        document.removeEventListener("mouseup", handleEndEdge);
    }

    // Connect the current edge to a port.
    //
    // This always fires before handleEndEdge, so it's safe to reference
    // newEdge.
    function handleConnectEdge(event) {
        let { gadgetId, port, x, y } = event.detail;
        newEdge.moveEndTo(x, y - navbarHeight);
        try {
            newEdge.setDest(gadgetId, port);
            edges.push(newEdge);
            edges = edges;
        } catch (e) {
            alert(e);
        }
    }

    function removeGadget(gadgetIdx) {
        let [gadget] = gadgets.splice(gadgetIdx, 1);
        let gadgetId = gadget.getId();
        let newEdges = [];

        for (let edge of edges) {
            if (
                edge.sourceGadgetId == gadgetId ||
                edge.destGadgetId == gadgetId
            ) {
                edge.disconnect();
            } else {
                newEdges.push(edge);
            }
        }

        edges = newEdges;
        // Dummy assignment to force reactive update.
        gadgets = gadgets;
    }
</script>

<div id="workspace" on:dragover={handleDragOver} on:drop={handleDrop}>
    {#each gadgets as gadget, idx (gadget.id)}
        <Gadget
            {gadget}
            on:delete={() => {
                removeGadget(idx);
            }}
            on:startEdge={handleStartEdge}
            on:endEdge={handleConnectEdge}
        />
    {/each}
    {#each edges as edge (edge.id)}
        <Edge {...edge.coords} />
    {/each}
    {#if newEdge !== null}
        <Edge {...newEdge.coords} />
    {/if}
</div>

<style>
    div#workspace {
        position: fixed;
        top: var(--nav-height);
        left: 0;
        bottom: 0;
        right: 0;
        overflow: auto;

        background-image: url(/img/grid.png);
        background-repeat: repeat;
    }
</style>
