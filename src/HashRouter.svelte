<script>
    import { onMount } from "svelte";

    export let hashRouteStore;

    onMount(() => {
        handleHashChange();
    });

    /**
     * Get the current location hash and emit an event.
     */
    function handleHashChange() {
        // Log to Google Analytics (if enabled)
        if (window.ga) {
            ga(
                "set",
                "page",
                location.pathname + location.search + location.hash
            );
            ga("send", "pageview");
        }

        // Write the new hash to the store.
        const hash = location.hash.substring(1);
        hashRouteStore.set(hash);
    }
</script>

<svelte:window on:hashchange={handleHashChange} />
