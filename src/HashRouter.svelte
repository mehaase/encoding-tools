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
        // Write the new hash to the store.
        const hash = location.hash.substring(1);
        hashRouteStore.set(hash);
    }
</script>

<svelte:window on:hashchange={handleHashChange} />
