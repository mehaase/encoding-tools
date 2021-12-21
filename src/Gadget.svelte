<script>
    import { createEventDispatcher, onDestroy, onMount } from "svelte";
    import { cellSize } from "./Layout";

    export let gadget;

    const dispatch = createEventDispatcher();
    let moveOffsetX, moveOffsetY;
    let display = null;
    let gadgetUnsub = null;

    onMount(() => {
        // When the gadget is first created, snap it to the grid.
        snapToGrid();
        gadgetUnsub = gadget.display.subscribe((value) => {
            display = value;
        });
    });

    onDestroy(() => {
        // Unsubscribe gadget subscription.
        if (gadgetUnsub !== null) {
            gadgetUnsub();
        }
    });

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

    // Snap x and y coordinates to the grid and animate the gadget into the new
    // position.
    function snapToGrid() {
        let [oldX, oldY] = [gadget.x, gadget.y];
        gadget.x = Math.round(oldX / cellSize) * cellSize;
        gadget.y = Math.round(oldY / cellSize) * cellSize;
    }

    // Start the creation of a new edge when a mousedown fires on a port.
    function startEdge(event, port) {
        if (event.button === 0) {
            // The event triggers on the highlight element that's on top of the
            // port, so we need to find the port element from there.
            const portEl = event.target.parentNode;
            const portRect = portEl.getBoundingClientRect();
            const x = (portRect.left + portRect.right) / 2;
            const y = (portRect.top + portRect.bottom) / 2;
            const isInput = portEl.classList.contains("input-port");
            dispatch("startEdge", {
                isInput: isInput,
                gadgetId: gadget.getId(),
                port: port,
                x: x,
                y: y,
            });
        }
    }

    function endEdge(event, port) {
        if (event.button === 0) {
            // The event triggers on the highlight element that's on top of the
            // port, so we need to find the port element from there.
            const portEl = event.target.parentNode;
            const portRect = portEl.getBoundingClientRect();
            const x = (portRect.left + portRect.right) / 2;
            const y = (portRect.top + portRect.bottom) / 2;
            const isInput = portEl.classList.contains("input-port");
            dispatch("endEdge", {
                isInput: isInput,
                gadgetId: gadget.getId(),
                port: port,
                x: x,
                y: y,
            });
        }
    }
</script>

<div
    class="gadget {gadget.cssClass}-gadget"
    style="left: {gadget.x}px;
           top: {gadget.y}px;
           width: {gadget.width}px;
           height: {gadget.height}px;"
>
    <div class="header" on:mousedown={startMove}>
        <i class="fas fa-grip-vertical grip" />
        {gadget.title}
        <i
            class="far fa-times-circle button"
            title="Delete"
            on:click={(e) => dispatch("delete")}
        />
        {#if gadget.isEditable}
            <i class="far fa-clipboard button" title="Paste" />
        {/if}
        <i class="far fa-clone button" title="Copy" />
    </div>
    {#if gadget.editableValue === null}
        <div class="content">
            {#if display !== null && display.hasError()}
                <div class="error">
                    <i class="fas fa-exclamation-triangle" />
                    {display.error}
                </div>
            {:else if display === null || display.isNull()}
                <div class="null">
                    <i class="fas fa-exclamation-triangle" />
                    NULL
                </div>
            {:else}
                <div class="value">{display.text}</div>
            {/if}
        </div>
    {:else}
        <div
            class="content"
            contenteditable="true"
            on:keyup={(e) => gadget.editableValue.set(e.target.textContent)}
        />
    {/if}
    {#each gadget.inputPorts as port, index}
        <div
            class="input-port port{index}"
            on:mousedown={(event) => startEdge(event, port)}
            on:mouseup={(event) => endEdge(event, port)}
        >
            <div class="highlight" />
        </div>
    {/each}
    {#each gadget.outputPorts as port, index}
        <div
            class="output-port port{index}"
            on:mousedown={(event) => startEdge(event, port)}
            on:mouseup={(event) => endEdge(event, port)}
        >
            <div class="highlight" />
        </div>
    {/each}
</div>

<style>
    /* Main gadget element */
    .gadget {
        --border-width: 2px;
        --border-radius: 5px;
        --port-height: calc(var(--cell-size) * 0.75);
        --background-color: rgba(255, 255, 255, 1);

        z-index: 1;
        position: absolute;
        background-color: var(--background-color);
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

    .header i.grip {
        font-size: 0.75em;
        position: relative;
        top: -0.1em;
    }

    .header i.button {
        margin-top: 0.2em;
        margin-right: 0.5em;
        float: right;
        cursor: pointer;
    }

    .header i.button:hover {
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

    .content .null {
        color: var(--gray);
    }

    .content .error {
        color: var(--red);
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
        background-color: var(--background-color);
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
    div.input-port:not(.connected),
    div.output-port {
        cursor: crosshair;
    }

    div.input-port:not(.connected):hover div.highlight,
    div.output-port:hover div.highlight {
        position: absolute;
        border: 2px solid var(--gray-dark);
        background-color: var(--gray);
        left: -7px;
        top: -9px;
        width: 30px;
        height: 30px;
        border-radius: 100%;
        opacity: 0.2;
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

    /* Force display of scroll bars on MacOS, which otherwise hides scrollbars when not
    actively scrolling. */
    ::-webkit-scrollbar {
        -webkit-appearance: none;
        width: 7px;
        height: 7px;
    }

    ::-webkit-scrollbar-thumb {
        border-radius: 4px;
        background-color: rgba(0, 0, 0, 0.5);
        box-shadow: 0 0 1px rgba(255, 255, 255, 0.5);
    }
</style>
