<script>
    import Edge from "./Edge.svelte";
    import Gadget from "./Gadget.svelte";
    import { navbarHeight } from "./Layout";
    import gadgetRegistry from "./gadgets/GadgetRegistry";
    import { InputGadget } from "./gadgets/InputGadgets";
    import { Md5Gadget, Sha1Gadget, Sha2Gadget } from "./gadgets/HashGadgets";

    let nextEdgeId = 0;

    class EdgeModel {
        constructor(x, y) {
            this.id = nextEdgeId++;
            this.coords = { x1: x, y1: y, x2: x, y2: y };
            this.sourceGadgetId = null;
            this.sourcePortIndex = null;
            this.destGadgetId = null;
            this.destPortIndex = null;
        }

        setSource(gadgetId, portIndex) {
            this.sourceGadgetId = gadgetId;
            this.sourcePortIndex = portIndex;
        }

        setDest(gadgetId, portIndex) {
            this.destGadgetId = gadgetId;
            this.destPortIndex = portIndex;
        }

        moveEndTo(x, y) {
            this.coords.x2 = x;
            this.coords.y2 = y;
        }

        toString() {
            return `Edge(${this.sourceGadgetId}:${this.sourcePortIndex} -> ${this.destGadgetId}:${this.destPortIndex})`;
        }
    }

    let newEdge = null;
    let edge1 = new EdgeModel(50, 100);
    edge1.moveEndTo(70, 150);
    let edge2 = new EdgeModel(70, 250);
    edge2.moveEndTo(90, 290);
    let edges = [edge1, edge2];
    let ig = new InputGadget(1 * 20, 1 * 20);
    let heg = new Md5Gadget(2 * 20, 8 * 20);
    let hdg = new Sha2Gadget(3 * 20, 15 * 20);
    let gadgets = [ig, heg, hdg];
    heg.inputPorts[0].connectTo(ig.outputPorts[0]);
    hdg.inputPorts[0].connectTo(ig.outputPorts[0]);
    let gadgetsById = {};
    for (let gadget of gadgets) {
        gadgetsById[gadget.id] = gadget;
    }
    // Graph is just nodes. Multiple roots. Each node is a dict that contains mapping of
    // sub nodes to their respective subtrees (or null if leaf node.)
    // let graph = [
    //   nodeid: {nodeid: null, nodeid: {nodeid: null}, nodeid: null}
    // ];

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
        let detail = event.detail;
        if (detail.isInput) {
            throw new Error("not implemented");
        } else {
            let { gadgetId, portIndex, x, y } = detail;
            y -= navbarHeight;
            newEdge = new EdgeModel(x, y);
            newEdge.setSource(gadgetId, portIndex);
            document.addEventListener("mousemove", handleMoveEdge);
            document.addEventListener("mouseup", handleEndEdge);
        }
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
        let { gadgetId, portIndex, x, y } = event.detail;
        newEdge.moveEndTo(x, y - navbarHeight);
        newEdge.setDest(gadgetId, portIndex);
        edges.push(newEdge);
        edges = edges;
    }
</script>

<div id="workspace" on:dragover={handleDragOver} on:drop={handleDrop}>
    {#each gadgets as gadget, idx (gadget.id)}
        <Gadget
            {gadget}
            on:delete={() => {
                gadgets.splice(idx, 1);
                // Dummy assignment to force reactive update.
                gadgets = gadgets;
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
