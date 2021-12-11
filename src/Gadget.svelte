<script>
    import { createEventDispatcher, onMount, tick } from "svelte";
    import { cellSize } from "./Layout";
    import { sleep } from "./Sleep";

    export let gadget;

    const dispatch = createEventDispatcher();
    let gadgetEl;
    let moveOffsetX, moveOffsetY;

    // Move gadget's absolute location to a mousemove event location (offset by
    // the relative location of the original mousedown event.).
    function moveGadget(event) {
        gadget.x = event.clientX - moveOffsetX;
        gadget.y = event.clientY - moveOffsetY;
    }

    // Start a gadget move when the header is left-clicked.
    function startMove(event) {
        if (event.button === 0) {
            moveOffsetX = event.clientX - gadget.x;
            moveOffsetY = event.clientY - gadget.y;
            document.addEventListener("mousemove", moveGadget);
            document.addEventListener("mouseup", endMove);
        }
    }

    // End a gadget move when the mouse is up.
    function endMove() {
        snapToGrid();
        document.removeEventListener("mousemove", moveGadget);
        document.removeEventListener("mouseup", endMove);
    }

    onMount(() => {
        // When the gadget is first created, snap it to the grid.
        snapToGrid();
    });

    // Snap x and y coordinates to the grid and animate the gadget into the new
    // position.
    async function snapToGrid() {
        let [oldX, oldY] = [gadget.x, gadget.y];
        gadget.x = Math.round(oldX / cellSize) * cellSize;
        gadget.y = Math.round(oldY / cellSize) * cellSize;
        let translateX = oldX - gadget.x;
        let translateY = oldY - gadget.y;
        gadgetEl.style.transform = `translate(${translateX}px,${translateY}px)`;
        let duration = Math.sqrt(translateX ** 2 + translateY ** 2) * 0.01;
        gadgetEl.style.transition = `transform ${duration}s ease-in`;

        // Not sure why, but await tick() doesn't work. It requires some amount of
        // sleep.
        await sleep(10);

        gadgetEl.style.transform = "translate(0px, 0px)";
        gadgetEl.addEventListener("transitionend", snapToGridTransitionEnd);
    }

    // This callback disables the transition on the element.
    function snapToGridTransitionEnd() {
        gadgetEl.transition = "none";
        gadgetEl.removeEventListener("transitionend", snapToGridTransitionEnd);
    }
</script>

<div
    bind:this={gadgetEl}
    class="gadget {gadget.cssClass}-gadget"
    style="left: {gadget.x}px;
           top: {gadget.y}px;
           width: {gadget.width}px;
           height: {gadget.height}px;"
>
    <div class="header" on:mousedown={startMove}>
        {gadget.title}
        <i
            class="far fa-times-circle"
            title="Delete"
            on:click={() => dispatch("delete")}
        />
        {#if gadget.isEditable}
            <i class="far fa-clipboard" title="Paste" />
        {/if}
        <i class="far fa-clone" title="Copy" />
    </div>
    <div class="content" contenteditable={gadget.isEditable}>
        <div class="value">placeholder</div>
    </div>
    {#each gadget.inputPorts as port, index}
        <div class="input-port port{index}" />
    {/each}
    {#each gadget.outputPorts as port, index}
        <div class="output-port port{index}" />
    {/each}
</div>

<style>
    /* Main gadget element */
    .gadget {
        --border-width: 2px;
        --border-radius: 5px;
        --port-height: calc(var(--cell-size) * 0.75);

        z-index: 1;
        position: absolute;
        background: white;
        border: var(--border-width) solid var(--gadget-color);
        border-radius: var(--border-radius);
    }

    /* Gadget header */
    .header {
        cursor: move;
        padding-left: 0.5rem;
        height: 1.5em;
        background-color: var(--gadget-color);
    }

    .header i {
        float: right;
        margin-top: 0.2em;
        margin-right: 0.5em;
        cursor: pointer;
    }

    .header i:hover {
        text-shadow: 0 0 3px var(--light);
        color: var(--light);
    }

    /* Contents */
    .content {
        position: absolute;
        top: 1.5em;
        left: 0;
        right: 0;
        bottom: 0;
        margin: 4px;
        background-color: white;
        border-bottom-left-radius: var(--border-radius);
        border-bottom-right-radius: var(--border-radius);
        overflow-y: auto;
    }

    .content[contenteditable="true"]:hover {
        background-color: #f0f0f0;
        margin: 2px;
        border: 2px solid #ccc;
    }

    .content[contenteditable="true"]:focus {
        background-color: #f0f0f0;
        outline: none;
        margin: 2px;
        border: 2px solid var(--gadget-color);
    }

    .content span.null {
        color: #747474;
    }

    .content .value {
        user-select: text;
    }

    /* Ports */
    div.input-port,
    div.output-port {
        position: absolute;
        z-index: -1;
        width: var(--cell-size);
        height: var(--port-height);
        border: var(--border-width) solid var(--gadget-color);
    }

    div.input-port {
        top: calc(-1 * var(--cell-size) * 0.75);
        border-top-left-radius: var(--border-radius);
        border-top-right-radius: var(--border-radius);
        background-color: var(--gadget-color);
    }

    div.output-port {
        bottom: calc(-1 * var(--cell-size) * 0.75);
        border-top: none;
        border-bottom-left-radius: var(--border-radius);
        border-bottom-right-radius: var(--border-radius);
        background-color: white;
    }

    div.port0 {
        left: calc(var(--cell-size) - var(--border-width));
    }

    div.port1 {
        left: calc(var(--cell-size) * 3 - var(--border-width));
    }

    div.port2 {
        left: calc(var(--cell-size) * 5 - var(--border-width));
    }

    div.port3 {
        left: calc(var(--cell-size) * 7 - var(--border-width));
    }

    /* Port highlighting */
    div#workspace:not(.highlight-output-ports)
        div.input-port:not(.connected):hover {
        cursor: crosshair;
        border-color: blue;
        background-color: blue;
    }

    div#workspace:not(.highlight-available-input-ports) div.output-port:hover {
        cursor: crosshair;
        border-color: blue;
        background-color: blue;
    }

    div#workspace.highlight-available-input-ports
        div.input-port:not(.connected) {
        border-color: lightblue;
        background-color: lightblue;
    }

    div#workspace.highlight-output-ports div.output-port {
        border-color: lightblue;
        background-color: lightblue;
    }
</style>
