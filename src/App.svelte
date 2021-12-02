<script>
    import { onMount } from "svelte";
    import Nav from "./Nav.svelte";
    import Toolbox from "./Toolbox.svelte";
    import Workspace from "./Workspace.svelte";

    onMount(() => {
        // Remove the loading screen.
        document.querySelector("div#loading").remove();
    });
</script>

<main>
    <Nav />
    <Workspace />
    <Toolbox />
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
