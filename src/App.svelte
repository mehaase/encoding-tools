<script>
    import { onMount } from "svelte";
    import { writable } from "svelte/store";
    import HashRouter from "./HashRouter.svelte";
    import Help from "./Help.svelte";
    import Nav from "./Nav.svelte";
    import Toolbox from "./Toolbox.svelte";
    import Tracker from "./Tracker.svelte";
    import Warehouse from "./Warehouse.svelte";
    import Workspace from "./Workspace.svelte";

    let warehouseVisible = false;
    let toolboxVisible = true;
    let helpVisible = false;
    let hashRouteStore = writable();
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
                toolboxVisible ? hideToolbox() : showToolbox();
                break;
            case "w":
                warehouseVisible ? hideWarehouse() : showWarehouse();
                break;
        }
    }

    /**
     * Display the warehouse that contains assemblies
     * @param _
     */
    function showWarehouse(_) {
        warehouseVisible = true;
        hideToolbox();
    }

    /**
     * Display the toolbox
     * @param _
     */
    function showToolbox(_) {
        toolboxVisible = true;
        hideWarehouse();
    }

    /**
     * Hide the warehouse
     * @param _
     */
    function hideWarehouse(_) {
        warehouseVisible = false;
    }

    /**
     * Hide the toolbox
     * @param _
     */
    function hideToolbox(_) {
        toolboxVisible = false;
    }
</script>

<svelte:window on:keydown={handleKeyDown} />

<main>
    {#if trackingEnabled}
        <Tracker />
    {/if}
    <HashRouter {hashRouteStore} />
    <Nav
        warehouseHidden={!warehouseVisible}
        toolboxHidden={!toolboxVisible}
        on:showWarehouse={showWarehouse}
        on:hideWarehouse={hideWarehouse}
        on:showToolbox={showToolbox}
        on:hideToolbox={hideToolbox}
        on:showHelp={() => (helpVisible = true)}
    />
    <Workspace {hashRouteStore} />
    <Warehouse hidden={!warehouseVisible} />
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
