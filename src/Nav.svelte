<script>
    import { createEventDispatcher } from "svelte";

    export let toolboxHidden;

    const dispatch = createEventDispatcher();

    function toggleToolbox(even) {
        toolboxHidden = !toolboxHidden;
        dispatch("toggleToolbox");
    }
</script>

<nav
    class="navbar navbar-expand-lg navbar-light bg-light border-bottom justify-content-between"
>
    <span class="navbar-brand">Encoding <i class="fas fa-wrench" /> Tools</span>
    <div>
        <button
            on:click={toggleToolbox}
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
