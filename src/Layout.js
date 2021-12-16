function lookupCssVarPx(cssVar) {
    // Hack for unit testing: if any of these globals don't exist, then
    // we're running inside a test harness and can return any value.
    try {
        let cssString = getComputedStyle(document.body).getPropertyValue(cssVar);
        if (cssString.substring(cssString.length - 2) !== "px") {
            throw new Error(`${cssVar} units must be "px", found "${cssString}"`);
        }
        return parseInt(cssString.substring(0, cssString.length - 2), 10);
    } catch (ReferenceError) {
        return -1;
    }
}

export const cellSize = lookupCssVarPx("--cell-size");
export const navbarHeight = lookupCssVarPx("--nav-height");
