<script>
    import { onDestroy, onMount, tick } from "svelte";
    import { assemblyRegistry } from "./assembly";
    import Graph from "./Graph.js";
    import { navbarHeight } from "./Layout.js";
    import gadgetRegistry from "./gadgets/GadgetRegistry.js";
    import { InputPort, OutputPort } from "./gadgets/BaseGadget.js";
    import { InputGadget } from "./gadgets/InputGadgets.js";
    import Edge from "./Edge.svelte";
    import Gadget from "./Gadget.svelte";

    export let hashRouteStore;

    let nextEdgeId = 0;
    let graph = new Graph();
    let hashStoreUnsubscribe;
    let newEdge = null;
    let edges = [];
    let gadgets = [];

    onMount(() => {
        resetWorkspace();
        hashStoreUnsubscribe = hashRouteStore.subscribe(handleHashChange);
    });

    onDestroy(() => {
        hashStoreUnsubscribe();
    });

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
        constructor(x, y, sourceGadgetId, sourcePort, sourcePortIndex) {
            this.id = nextEdgeId++;
            this.coords = { x1: x, y1: y, x2: x, y2: y };
            this.sourceGadgetId = sourceGadgetId;
            this.sourcePort = sourcePort;
            this.sourcePortIndex = sourcePortIndex;
            this.destGadgetId = null;
            this.destPort = null;
            this.destPortIndex = null;
        }

        /**
         * Set the edge's destination, i.e. the gadget/port that it is connected to.
         * @param gadgetId
         * @param port
         * @param portIndex
         */
        setDest(gadgetId, port, portIndex) {
            // Make sure that the source port is always an output port, and destination
            // is always an input.
            if (this.sourcePort instanceof InputPort) {
                this.destGadgetId = this.sourceGadgetId;
                this.destPort = this.sourcePort;
                this.destPortIndex = this.sourcePortIndex;
                this.sourceGadgetId = gadgetId;
                this.sourcePort = port;
                this.sourcePortIndex = portIndex;
            } else {
                this.destGadgetId = gadgetId;
                this.destPort = port;
                this.destPortIndex = portIndex;
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
         * Move the endpoint to the specified coordinates. This method is used when a
         * gadget is being moved around.
         * @param x
         * @param y
         */
        moveStartTo(x, y) {
            this.coords.x1 = x;
            this.coords.y1 = y;
        }

        /**
         * Move the endpoint to the specified coordinates. This method is used while the
         * user is dragging out a new edge to make the edge follow the cursor, or when a
         * gadget is being moved around.
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

    async function handleHashChange(hash) {
        if (hash === "") {
            resetWorkspace();
        } else if (hash.substring(0, 7) === "gadget/") {
            await loadGadget(hash.substring(7));
        } else {
            if (!(hash in assemblyRegistry)) {
                throw new Error(`Could not find assembly "${hash}"`);
            }
            await loadAssembly(assemblyRegistry[hash]);
        }

        await tick();

        // Log to Google Analytics (if enabled)
        if (window.gtag) {
            console.log(
                "gtag",
                location.pathname + location.search + location.hash
            );
            // window.gtag(
            //     "set",
            //     "page_path",
            //     location.pathname + location.search + location.hash
            // );
            window.gtag("event", "page_view", {
                page_title: document.title,
                page_location: location.href,
                page_path: location.pathname + location.search + location.hash,
            });
        }
    }

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
        let { gadgetId, port, portIndex, x, y } = event.detail;
        y -= navbarHeight;
        newEdge = new EdgeModel(x, y, gadgetId, port, portIndex);
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
        let { gadgetId, port, portIndex, x, y } = event.detail;
        newEdge.moveEndTo(x, y - navbarHeight);
        try {
            newEdge.setDest(gadgetId, port, portIndex);
            edges.push(newEdge);
            edges = edges;
            gadgets = gadgets;
        } catch (e) {
            alert(e);
        }
    }

    /**
     * Handle a gadget that was removed.
     * @param gadgetIdx
     */
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

    /**
     * Called when a gadget is moved.
     * @param event
     */
    function handleGadgetMove(event) {
        let { gadgetId, inputPorts, outputPorts } = event.detail;

        for (let edge of edges) {
            if (edge.sourceGadgetId === gadgetId) {
                let start = outputPorts[edge.sourcePortIndex];
                edge.moveStartTo(start.x, start.y - navbarHeight);
            } else if (edge.destGadgetId === gadgetId) {
                let end = inputPorts[edge.destPortIndex];
                edge.moveEndTo(end.x, end.y - navbarHeight);
            }
        }

        // Dummy assignment to trigger reactive update.
        edges = edges;
    }

    /**
     * Called when an edge is deleted.
     */
    function deleteEdge(edge) {
        const edgeIndex = edges.indexOf(edge);
        edges.splice(edgeIndex, 1);
        edge.disconnect();
        // Dummy assignment to force reactive update.
        edges = edges;
        gadgets = gadgets;
    }

    /**
     *
     * @param classId
     */
    function setPageTitle(title) {
        document.title = `${title}–Encoding Tools`;
    }

    /**
     * Configure the workspace with one input gadget.
     */
    function resetWorkspace() {
        for (let edge of edges) {
            edge.disconnect();
        }
        edges = [];
        gadgets = [new InputGadget(1 * 20, 1 * 20)];
        document.title = "Encoding Tools";
    }

    /**
     * Load an input gadget and one transform gadget into the workspace and wire them
     * together. These replace all existing gadgets in the workspace, unless the gadget
     * in the first position is an input gadget, in which case that is used instead of
     * creating a new input.
     * @param classId The class ID of the transform gadget
     */
    async function loadGadget(classId) {
        let inputGadget;

        if (gadgets.length > 0 && gadgets[0] instanceof InputGadget) {
            inputGadget = gadgets[0];
        } else {
            inputGadget = new InputGadget(20, 20);
        }

        let transformGadget = gadgetRegistry.build(
            classId,
            inputGadget.x + 60,
            inputGadget.y + inputGadget.height + 60
        );

        // Bit of a hack here. If the input gadget is being reused, then it won't get
        // snapped to grid, so the edge's start position won't be set correctly. This is
        // brittle as written but will work for now.
        let newEdge = new EdgeModel(
            inputGadget.x + 30,
            inputGadget.y + inputGadget.height + 10,
            inputGadget.getId(),
            inputGadget.outputPorts[0],
            0
        );
        newEdge.setDest(
            transformGadget.getId(),
            transformGadget.inputPorts[0],
            0
        );

        for (let edge of edges) {
            edge.disconnect();
        }

        edges = [newEdge];
        await tick();
        gadgets = [inputGadget, transformGadget];
        setPageTitle(transformGadget.title);
    }

    /**
     * Load an "assembly", i.e. a predefined configuration of gadgets
     * @param Object assembly
     */
    async function loadAssembly(assembly) {
        let newGadgets = [];
        let newEdges = [];

        for (let ag of assembly.gadgets) {
            let gadget = gadgetRegistry.build(ag.classId, ag.x, ag.y);
            newGadgets.push(gadget);
        }

        for (let ae of assembly.edges) {
            // Notice that edge coordinates are initialized to bogus values. When the
            // gadgets are initially placed in the workspace, they will be snapped to
            // the grid, which will broadcast their locations and move all edges to the
            // correct locations.
            let sourceGadget = newGadgets[ae.sourceGadget];
            let sourcePort = sourceGadget.outputPorts[ae.sourcePort];
            let sourcePortIndex = ae.sourcePort;

            let destGadget = newGadgets[ae.destGadget];
            let destPort = destGadget.inputPorts[ae.destPort];
            let destPortIndex = ae.destPort;

            let edge = new EdgeModel(
                0,
                0,
                sourceGadget.getId(),
                sourcePort,
                sourcePortIndex
            );
            edge.setDest(destGadget.getId(), destPort, destPortIndex);
            newEdges.push(edge);
        }

        for (let edge of edges) {
            edge.disconnect();
        }

        edges = newEdges;
        await tick();
        gadgets = newGadgets;
        setPageTitle(assembly.title);
    }
</script>

<div id="workspace" on:dragover={handleDragOver} on:drop={handleDrop}>
    {#each gadgets as gadget, idx (gadget.id)}
        <Gadget
            {gadget}
            on:delete={() => {
                removeGadget(idx);
            }}
            on:moved={handleGadgetMove}
            on:startEdge={handleStartEdge}
            on:endEdge={handleConnectEdge}
        />
    {/each}
    {#each edges as edge (edge.id)}
        <Edge on:delete={() => deleteEdge(edge)} {...edge.coords} />
    {/each}
    {#if newEdge !== null}
        <Edge {...newEdge.coords} isNewEdge={true} />
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

        background-image: url(../img/grid.png);
        background-repeat: repeat;
    }
</style>
