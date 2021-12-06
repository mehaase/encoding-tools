<script>
    export let hidden;
</script>

<div id="toolbox" class:hidden>
    <h1>Gadgets</h1>
    <div class="gadget-handle input-gadget" draggable="true">Input</div>
    <h2>Change Base</h2>
    <div class="gadget-handle change-base-gadget" draggable="true">
        Base64 Decode
    </div>
    <div class="gadget-handle change-base-gadget" draggable="true">
        Base64 Encode
    </div>
    <div class="gadget-handle change-base-gadget" draggable="true">
        Hex Decode
    </div>
    <div class="gadget-handle change-base-gadget" draggable="true">
        Hex Encode
    </div>
    <h2>Hashes</h2>
    <div class="gadget-handle hash-gadget" draggable="true">MD5</div>
    <div class="gadget-handle hash-gadget" draggable="true">SHA-1</div>
    <div class="gadget-handle hash-gadget" draggable="true">SHA-2</div>
    <h2>Web</h2>
    <div class="gadget-handle web-gadget" draggable="true">HTML Decode</div>
    <div class="gadget-handle web-gadget" draggable="true">HTML Encode</div>
    <div class="gadget-handle web-gadget" draggable="true">URL Decode</div>
    <div class="gadget-handle web-gadget" draggable="true">URL Encode</div>
    <h1>Assemblies</h1>
    <a href="#base64-encoder">Base64 Encoder</a> /
    <a href="#base64-decoder">Decoder</a><br /><a href="#hex-encoder"
        >Hex Encoder</a
    >
    / <a href="#hex-decoder">Decoder</a><br /><a href="#html-encoder"
        >HTML Encoder</a
    >
    / <a href="#html-decoder">Decoder</a><br /><a href="#md5-hash">Hash MD5</a>
    / <a href="#sha1-hash">SHA-1</a> / <a href="#sha2-hash">SHA-2</a><br /><a
        href="#url-encoder">URL Encoder</a
    >
    / <a href="#url-decoder">Decoder</a><br />
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
