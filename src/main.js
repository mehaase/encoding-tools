import App from "./App.svelte";

function isTouchEnabled() {
    return ('ontouchstart' in window) ||
        (navigator.maxTouchPoints > 0) ||
        (navigator.msMaxTouchPoints > 0);
}

if (isTouchEnabled()) {
    let message = "This application does not support touch screens.";
    let loadingDiv = document.querySelector("#loading");
    loadingDiv.innerHTML = message;
    throw new Error(message);
}

const app = new App({
    target: document.body
});

export default app;
