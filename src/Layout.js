function setCssVar(name, value) {
    try {
        document.body.style.setProperty(name, value);
    } catch (ReferenceError) {
        // Unit tests won't have the DOm elements referenced above. Silently ignore.
    }
}

export const cellSize = 20;
setCssVar("--cell-size", `${cellSize}px`);
export const navbarHeight = 60;
setCssVar("--nav-height", `${navbarHeight}px`);
