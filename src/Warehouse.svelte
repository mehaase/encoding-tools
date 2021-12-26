<script>
    import { assemblyRegistry } from "./assembly.js";

    export let hidden;

    class Assembly {
        constructor(id, title) {
            this.id = id;
            this.title = title;
        }
    }

    let assemblies = [];
    for (let [id, ar] of Object.entries(assemblyRegistry)) {
        let ar = assemblyRegistry[id];
        assemblies.push(new Assembly(id, ar.title));
    }
</script>

<div id="warehouse" class:hidden>
    <h2>Warehouse</h2>
    <p class="description">Pre-built assemblies of gadgets.</p>
    <ul>
        {#each assemblies as assembly}
            <li><a href="#{assembly.id}">{assembly.title}</a></li>
        {/each}
    </ul>
</div>

<style>
    div#warehouse {
        position: fixed;
        top: var(--nav-height);
        bottom: 0;
        right: 0;
        width: var(--warehouse-width);
        z-index: 2;
        padding: 0.5em;
        overflow-x: hidden;
        overflow-y: auto;
        background-color: #f8f9fa;
        border-left: 1px solid #dee2e6;
        transition: transform 1s;
    }

    div#warehouse.hidden {
        z-index: 1;
        transform: translateX(var(--warehouse-width));
    }

    h2 {
        font-size: 1.2rem;
        text-align: center;
        margin-top: 1rem;
    }

    .description {
        font-size: 10pt;
        font-style: italic;
        text-align: center;
    }
</style>
