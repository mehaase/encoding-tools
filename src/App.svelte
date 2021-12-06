<script>
    import { onMount } from "svelte";
    import Help from "./Help.svelte";
    import Nav from "./Nav.svelte";
    import Toolbox from "./Toolbox.svelte";
    import Workspace from "./Workspace.svelte";

    let toolboxVisible = true;
    let helpVisible = false;

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
                toolboxVisible = !toolboxVisible;
                break;
        }
    }
</script>

<svelte:window on:keydown={handleKeyDown} />

<main>
    <Nav
        on:toggleToolbox={() => (toolboxVisible = !toolboxVisible)}
        on:showHelp={() => (helpVisible = true)}
    />
    <Workspace />
    <Toolbox hidden={!toolboxVisible} />
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
