<script>
    import Edge from "./Edge.svelte";
    import Gadget from "./Gadget.svelte";
    import { navbarHeight } from "./Layout";
    import gadgetRegistry from "./gadgets/GadgetRegistry";
    import { HexEncodeGadget } from "./gadgets/ChangeBaseGadgets";
    import { Md5Gadget } from "./gadgets/HashGadgets";
    import { InputGadget } from "./gadgets/InputGadgets";
    import { UrlEncodeGadget } from "./gadgets/WebGadgets";

    class EdgeModel {
        constructor(x1, y1, x2, y2) {
            this.x1 = x1;
            this.y1 = y1;
            this.x2 = x2;
            this.y2 = y2;
        }

        moveEndTo(x, y) {
            this.x2 = x;
            this.y2 = y;
        }
    }

    let newEdge = null;
    let edges = [
        // new EdgeModel(50, 110, 70, 150),
        // new EdgeModel(70, 250, 90, 290),
    ];
    let gadgets = [
        new InputGadget(1 * 20, 1 * 20),
        new HexEncodeGadget(2 * 20, 8 * 20),
        new Md5Gadget(3 * 20, 15 * 20),
        new UrlEncodeGadget(4 * 20, 22 * 20),
    ];

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
            let { portIndex, x, y } = detail;
            y -= navbarHeight;
            newEdge = new EdgeModel(x, y, x, y);
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
        console.log("end edge");
        newEdge = null;
        document.removeEventListener("mousemove", handleMoveEdge);
        document.removeEventListener("mouseup", handleEndEdge);
    }

    // Connect the current edge to a port.
    //
    // This always fires before handleEndEdge, so it's safe to reference
    // newEdge.
    function handleConnectEdge(event) {
        console.log("connect edge");
        let detail = event.detail;
        newEdge.moveEndTo(detail.x, detail.y - navbarHeight);
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
    {#each edges as edge, idx}
        <Edge {...edge} />
    {/each}
    {#if newEdge !== null}
        <Edge {...newEdge} />
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
