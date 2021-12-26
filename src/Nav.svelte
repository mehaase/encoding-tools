<script>
    import { createEventDispatcher } from "svelte";

    export let warehouseHidden;
    export let toolboxHidden;

    const dispatch = createEventDispatcher();
</script>

<nav
    class="navbar navbar-expand-lg navbar-light bg-light border-bottom justify-content-between"
>
    <span class="navbar-brand">Encoding <i class="fas fa-wrench" /> Tools</span>
    <div>
        <button
            on:click={() =>
                dispatch(warehouseHidden ? "showWarehouse" : "hideWarehouse")}
            type="button"
            class="btn btn-primary"
            style="margin-right: 1em;"
            ><i class="fas fa-warehouse" />
            {#if warehouseHidden}
                Show
            {:else}
                Hide
            {/if}
            Warehouse
        </button>
        <button
            on:click={() =>
                dispatch(toolboxHidden ? "showToolbox" : "hideToolbox")}
            type="button"
            class="btn btn-primary"
            style="margin-right: 1em;"
            ><i class="fas fa-toolbox" />
            {#if toolboxHidden}
                Show
            {:else}
                Hide
            {/if}
            Toolbox
        </button><button
            on:click={() => dispatch("showHelp", null)}
            type="button"
            class="btn btn-primary"
            ><i class="fas fa-question-circle" /> Help</button
        >
    </div>
</nav>

<style>
    nav {
        height: calc(var(--nav-height) + 1px);
        z-index: 1;
    }

    nav .navbar-brand {
        font-size: 1.6rem;
    }
</style>
