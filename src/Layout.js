function lookupCssVarPx(cssVar) {
    let cssString = getComputedStyle(document.body).getPropertyValue(cssVar);
    if (cssString.substring(cssString.length - 2) !== "px") {
        throw new Error(`${cssVar} units must be "px", found "${cssString}"`);
    }
    return parseInt(cssString.substring(0, cssString.length - 2), 10);
}

export const cellSize = lookupCssVarPx("--cell-size");
export const navbarHeight = lookupCssVarPx("--nav-height");
