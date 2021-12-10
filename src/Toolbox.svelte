<script>
    import { tick } from "svelte";
    import Gadget from "./Gadget.svelte";
    import gadgetRegistry from "./gadgets/GadgetRegistry";

    export let hidden;

    let families = [];
    let gadgetRegistrationsByFamily = {};

    for (let gadgetRegistration of gadgetRegistry.list()) {
        let family = gadgetRegistration.family;
        if (family in gadgetRegistrationsByFamily) {
            gadgetRegistrationsByFamily[family].push(gadgetRegistration);
        } else {
            families.push(family);
            gadgetRegistrationsByFamily[family] = [gadgetRegistration];
        }
    }

    let draggedGadget;
    let dragProxyElement;

    // When a drag starts, show a proxy object that can be dragged around.
    async function handleDragStart(event, gadgetRegistration) {
        event.stopPropagation();
        draggedGadget = gadgetRegistry.build(gadgetRegistration.classId);

        // Wait one tick for Svelte to render the <Gadget/>.
        await tick();

        // Set the drag image location to be proportional to the location of
        // the click within the gadget handle.
        let tclient = event.target;
        let header = dragProxyElement.querySelector("div.header");
        let offsetX = Math.round(
            (event.offsetX / tclient.clientWidth) * header.clientWidth
        );
        let offsetY = Math.round(
            (event.offsetY / tclient.clientHeight) * header.clientHeight
        );
        event.dataTransfer.setDragImage(dragProxyElement, offsetX, offsetY);
        let dragData = {
            classId: draggedGadget.getClassId(),
            offsetX: offsetX,
            offsetY: offsetY,
        };
        event.dataTransfer.setData(
            "application/vnd.encodingtools-gadget",
            JSON.stringify(dragData)
        );
    }

    // When the drag ends, hide the proxy object.
    function handleDragEnd(event) {
        draggedGadget = null;
    }
</script>

<div id="toolbox" class:hidden>
    {#each families as family}
        <h2>{family}</h2>
        {#each gadgetRegistrationsByFamily[family] as gadgetRegistration}
            <div
                class="gadget-handle {gadgetRegistration.cssClass}-gadget"
                draggable="true"
                on:dragstart={(event) =>
                    handleDragStart(event, gadgetRegistration)}
                on:dragend={(event) => handleDragEnd(event, gadgetRegistration)}
            >
                {gadgetRegistration.title}
            </div>
        {/each}
    {/each}
</div>

<div id="drag-proxy" bind:this={dragProxyElement}>
    {#if draggedGadget}
        <Gadget gadget={draggedGadget} />
    {/if}
</div>

<style>
    div#toolbox {
        position: fixed;
        top: var(--nav-height);
        bottom: 0;
        right: 0;
        width: var(--drawer-width);
        z-index: 1;
        padding: 0.5em;
        overflow-x: hidden;
        overflow-y: auto;
        background-color: #f8f9fa;
        border-left: 1px solid #dee2e6;
        transition: transform 1s;
    }

    div#toolbox.hidden {
        transform: translateX(var(--drawer-width));
    }

    div#toolbox h2 {
        font-size: 1.2rem;
        text-align: center;
        margin-top: 1rem;
    }

    div#toolbox .gadget-handle {
        display: inline-block;
        cursor: move;
        height: 2rem;
        padding: 0.3rem 0.8rem;
        background-color: var(--gadget-color);
        font-size: 1rem;
        margin-right: 0.5rem;
        margin-bottom: 0.5rem;
    }

    /* This element must be attached to the DOM and visible, so it is placed just off
    the bottom right corner of the screen. */
    div#drag-proxy {
        position: absolute;
        left: 100vw;
        top: 100vh;
    }
</style>