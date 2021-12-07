<script>
    import Gadget from "./Gadget.svelte";
    import { HexEncodeGadget } from "./gadgets/ChangeBaseGadgets";
    import { Md5Gadget } from "./gadgets/HashGadgets";
    import { InputGadget } from "./gadgets/InputGadgets";
    import { UrlEncodeGadget } from "./gadgets/WebGadgets";

    const gadget3 = new InputGadget(1, 1);
    const gadget1 = new HexEncodeGadget(2, 9);
    const gadget2 = new Md5Gadget(3, 15);
    const gadget4 = new UrlEncodeGadget(4, 21);
</script>

<div id="workspace">
    <Gadget gadget={gadget1} />
    <Gadget gadget={gadget2} />
    <Gadget gadget={gadget3} />
    <Gadget gadget={gadget4} />
</div>

<style>
    div#workspace {
        position: fixed;
        top: var(--nav-height);
        left: 0;
        bottom: 0;
        right: 0;
        overflow: auto;

        background-image: url(/img/grid.png);
        background-repeat: repeat;
    }
</style>
