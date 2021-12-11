<script>
    import Gadget from "./Gadget.svelte";
    import { navbarHeight } from "./Layout";
    import gadgetRegistry from "./gadgets/GadgetRegistry";
    import { HexEncodeGadget } from "./gadgets/ChangeBaseGadgets";
    import { Md5Gadget } from "./gadgets/HashGadgets";
    import { InputGadget } from "./gadgets/InputGadgets";
    import { UrlEncodeGadget } from "./gadgets/WebGadgets";

    let gadgets = [
        // new InputGadget(1 * 20, 1 * 20),
        // new HexEncodeGadget(2 * 20, 9 * 20),
        // new Md5Gadget(3 * 20, 15 * 20),
        // new UrlEncodeGadget(4 * 20, 21 * 20),
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
</script>

<div id="workspace" on:dragover={handleDragOver} on:drop={handleDrop}>
    {#each gadgets as gadget, idx (gadget.id)}
        <Gadget
            {gadget}
            on:delete={() => {
                gadgets.splice(idx, 1);
                // Dummy assignment forces reactive update.
                gadgets = gadgets;
            }}
        />
    {/each}
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
