<script>
    import { onMount } from "svelte";
    import Help from "./Help.svelte";
    import Nav from "./Nav.svelte";
    import Toolbox from "./Toolbox.svelte";
    import Tracker from "./Tracker.svelte";
    import Workspace from "./Workspace.svelte";

    let toolboxHidden = false;
    let helpVisible = false;
    let trackingEnabled = window?.location?.hostname == "encoding.tools";

    onMount(() => {
        // Remove the loading screen.
        document.querySelector("div#loading").remove();
    });

    // Handle global keyboard shorcuts.
    function handleKeyDown(event) {
        switch (event.key) {
            case "?":
                helpVisible = !helpVisible;
                break;
            case "t":
                toolboxHidden = !toolboxHidden;
                break;
        }
    }
</script>

<svelte:window on:keydown={handleKeyDown} />

<main>
    {#if trackingEnabled}
        <Tracker />
    {/if}
    <Nav bind:toolboxHidden on:showHelp={() => (helpVisible = true)} />
    <Workspace />
    <Toolbox hidden={toolboxHidden} />
    {#if helpVisible}
        <Help on:hideHelp={() => (helpVisible = false)} />
    {/if}
</main>

<style>
    /* The app covers the entire viewport. */
    main {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
    }
</style>
