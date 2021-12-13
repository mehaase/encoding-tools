<script>
    export let x1;
    export let y1;
    export let x2;
    export let y2;

    const swoopiness = 0.75;
    const thickness = 2;

    let left, top, width, height, path;
    $: {
        // Update curve when endpoints change.
        left = Math.min(x1, x2);
        top = Math.min(y1, y2);
        width = Math.abs(x1 - x2) + 2 * thickness;
        height = Math.abs(y1 - y2) + 2 * thickness;

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

        path = `M ${startX} ${startY} C ${control1X} ${control1Y}, ${control2X} ${control2Y}, ${endX} ${endY}`;
    }
</script>

<svg style="left: {left}px; top: {top}px; width: {width}px; height: {height}px">
    <path d={path} fill="none" stroke="#555" stroke-width="2px" />
</svg>

<style>
    svg {
        position: absolute;
    }
</style>
