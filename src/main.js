import App from "./App.svelte";

function isTouchEnabled() {
    return ('ontouchstart' in window) ||
        (navigator.maxTouchPoints > 0) ||
        (navigator.msMaxTouchPoints > 0);
}

if (isTouchEnabled()) {
    alert("This application does not support touch screens.");
}

const app = new App({
    target: document.body
});

export default app;
