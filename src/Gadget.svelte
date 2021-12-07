<script>
    export let gadget;
    let width, height;
</script>

<div
    class="gadget {gadget.cssClass}-gadget"
    style="left: calc(var(--cell-size) * {gadget.x});
           top: calc(var(--cell-size) * {gadget.y});
           width: calc(var(--cell-size) * {width ?? gadget.defaultWidth});
           height: calc(var(--cell-size) * {height ?? gadget.defaultHeight});"
>
    <div class="header">{gadget.title}</div>
    <div class="content">
        <textarea
            spellcheck="false"
            placeholder="Enter text here…"
            style="height: 2em;"
        />
    </div>
    <div class="output-port port0" />
</div>

<style>
    div.gadget {
        --border-width: 2px;
        --port-height: calc(var(--cell-size) * 0.75);

        z-index: 1;
        position: absolute;
        display: inline-block;
        width: calc(var(--cell-size) * 16);
        background: white;
        border: var(--border-width) solid var(--gadget-color);
    }

    div.gadget .header {
        cursor: move;
        padding-left: 0.5rem;
        background-color: var(--gadget-color);
    }

    div.gadget .content {
        padding: 0.75rem 0.5rem;
    }

    div.gadget .content pre {
        padding: 5px;
        margin-bottom: 0;
        overflow: hidden;
    }

    div.gadget .content span.null {
        color: #747474;
    }

    div.input-gadget textarea {
        border: none;
        resize: none;
        height: 60px;
        width: 100%;
    }

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
        border-top-left-radius: 30%;
        border-top-right-radius: 30%;
        background-color: var(--gadget-color);
    }

    div#workspace:not(.highlight-output-ports)
        div.input-port:not(.connected):hover {
        cursor: crosshair;
        border-color: blue;
        background-color: blue;
    }

    div.output-port {
        bottom: calc(-1 * var(--cell-size) * 0.75);
        border-top: none;
        border-bottom-left-radius: 30%;
        border-bottom-right-radius: 30%;
        background-color: white;
    }

    div#workspace:not(.highlight-available-input-ports) div.output-port:hover {
        cursor: crosshair;
        border-color: blue;
        background-color: blue;
    }

    div.input-port.port0,
    div.output-port.port0 {
        left: calc(var(--cell-size) - var(--border-width));
    }

    div.input-port.port1,
    div.output-port.port1 {
        left: calc(var(--cell-size) * 3 - var(--border-width));
    }

    div.input-port.port2,
    div.output-port.port2 {
        left: calc(var(--cell-size) * 5 - var(--border-width));
    }

    div.input-port.port3,
    div.output-port.port3 {
        left: calc(var(--cell-size) * 7 - var(--border-width));
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
