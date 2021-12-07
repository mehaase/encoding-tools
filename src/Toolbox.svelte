<script>
    import {
        HexEncodeGadget,
        HexDecodeGadget,
        Base64EncodeGadget,
        Base64DecodeGadget,
    } from "./gadgets/ChangeBaseGadgets";
    import { Md5Gadget, Sha1Gadget, Sha2Gadget } from "./gadgets/HashGadgets";
    import { InputGadget } from "./gadgets/InputGadgets";
    import {
        UrlEncodeGadget,
        UrlDecodeGadget,
        HtmlEncodeGadget,
        HtmlDecodeGadget,
    } from "./gadgets/WebGadgets";

    export let hidden;

    /**
     * Represents the version of a gadget that is seen in the toolbox.
     */
    class GadgetHandle {
        constructor(factory) {
            this.factory = factory;
            let gadget = factory();
            this.family = gadget.family;
            this.cssClass = gadget.cssClass;
            this.title = gadget.title;
        }
    }

    let gadgetHandles = [
        new GadgetHandle(() => new InputGadget()),
        new GadgetHandle(() => new HexEncodeGadget()),
        new GadgetHandle(() => new HexDecodeGadget()),
        new GadgetHandle(() => new Base64EncodeGadget()),
        new GadgetHandle(() => new Base64DecodeGadget()),
        new GadgetHandle(() => new Md5Gadget()),
        new GadgetHandle(() => new Sha1Gadget()),
        new GadgetHandle(() => new Sha2Gadget()),
        new GadgetHandle(() => new UrlEncodeGadget()),
        new GadgetHandle(() => new UrlDecodeGadget()),
        new GadgetHandle(() => new HtmlEncodeGadget()),
        new GadgetHandle(() => new HtmlDecodeGadget()),
    ];

    let families = [];
    let gadgetHandlesByFamily = {};

    for (let gadgetHandle of gadgetHandles) {
        let family = gadgetHandle.family;
        if (family in gadgetHandlesByFamily) {
            gadgetHandlesByFamily[family].push(gadgetHandle);
        } else {
            families.push(family);
            gadgetHandlesByFamily[family] = [gadgetHandle];
        }
    }
</script>

<div id="toolbox" class:hidden>
    {#each families as family}
        <h2>{family}</h2>
        {#each gadgetHandlesByFamily[family] as gadgetHandle}
            <div
                class="gadget-handle {gadgetHandle.cssClass}-gadget"
                draggable="true"
            >
                {gadgetHandle.title}
            </div>
        {/each}
    {/each}
</div>

<style>
    div#toolbox {
        position: fixed;
        top: var(--nav-height);
        bottom: 0;
        right: 0;
        width: var(--drawer-width);
        z-index: 1;
        padding: 0.5em;
        overflow-x: hidden;
        overflow-y: auto;
        background-color: #f8f9fa;
        border-left: 1px solid #dee2e6;
        transition: transform 1s;
    }

    div#toolbox.hidden {
        transform: translateX(var(--drawer-width));
    }

    div#toolbox h1 {
        font-size: 1.5rem;
        text-align: center;
        margin-top: 1rem;
    }

    div#toolbox h2 {
        font-size: 1.2rem;
        text-align: center;
        margin-top: 1rem;
    }

    div#toolbox .gadget-handle {
        display: inline-block;
        cursor: move;
        height: 2rem;
        padding: 0.3rem 0.8rem;
        background-color: var(--gadget-color);
        font-size: 1rem;
        margin-right: 0.5rem;
        margin-bottom: 0.5rem;
    }
</style>
