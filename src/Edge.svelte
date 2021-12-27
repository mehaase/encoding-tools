<script>
    import { createEventDispatcher } from "svelte";

    export let x1;
    export let y1;
    export let x2;
    export let y2;
    export let isNewEdge = false;

    const dispatch = createEventDispatcher();
    const swoopiness = 0.75;
    const thickness = 2;

    let left, top, width, height, path;
    let centerX, centerY;
    let showCloseButton = false;

    $: {
        // Update curve when endpoints change.
        left = Math.min(x1, x2);
        top = Math.min(y1, y2);
        width = Math.abs(x1 - x2) + 2 * thickness;
        height = Math.abs(y1 - y2) + 2 * thickness;
        centerX = left + width / 2;
        centerY = top + height / 2;

        let startX, startY;
        let control1X, control1Y;
        let control2X, control2Y;
        let endX, endY;

        // Because the y-axis grows downward, positive slope means it
        // slants down to the right.
        let positiveSlope = (y2 - y1) / (x2 - x1) > 0;

        if (positiveSlope) {
            [startX, startY] = [thickness, thickness];
            [control1X, control1Y] = [thickness, height * swoopiness];
            [control2X, control2Y] = [
                width - thickness,
                height * (1 - swoopiness),
            ];
            [endX, endY] = [width - thickness, height - thickness];
        } else {
            [startX, startY] = [width - thickness, thickness];
            [control1X, control1Y] = [width - thickness, height * swoopiness];
            [control2X, control2Y] = [thickness, height * (1 - swoopiness)];
            [endX, endY] = [thickness, height - thickness];
        }

        console.log(left, top);
        path = `M ${startX} ${startY} C ${control1X} ${control1Y}, ${control2X} ${control2Y}, ${endX} ${endY}`;
    }
</script>

<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<svg
    on:mouseover={(event) => (showCloseButton = !isNewEdge)}
    on:mouseout={(event) => (showCloseButton = false)}
    style="left: {left}px; top: {top}px; width: {width}px; height: {height}px"
>
    <g>
        <path d={path} fill="none" stroke="#555" stroke-width="2px" />
    </g>
</svg>

<div
    on:mouseover={(event) => (showCloseButton = !isNewEdge)}
    on:focus={(event) => (showCloseButton = !isNewEdge)}
    on:click={(event) => dispatch("delete")}
    class="close-button"
    style="left: {centerX - 22}px; top: {centerY -
        16}px; visibility: {showCloseButton ? 'visible' : 'hidden'}"
>
    <i class="fas fa-circle" />
    <i class="fas fa-times" />
</div>

<style>
    svg {
        position: absolute;
    }

    div.close-button {
        position: absolute;
        visibility: hidden;
    }

    div.close-button:hover {
        color: var(--red);
    }

    .fa-circle {
        position: relative;
        left: 11px;
        top: 5px;
    }

    .fa-circle:before {
        font-size: 14pt;
    }

    .fa-times {
        position: relative;
        left: -7px;
        top: 3px;
    }

    .fa-times:before {
        color: var(--white);
        font-size: 10pt;
    }
</style>
