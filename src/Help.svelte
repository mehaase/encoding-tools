<script>
    import { createEventDispatcher } from "svelte";

    const dispatch = createEventDispatcher();

    // Escape key closes this modal.
    function handleKeyDown(event) {
        if (event.key == "Escape") {
            dispatch("hideHelp");
        }
    }
</script>

<svelte:window on:keydown={handleKeyDown} />

<div class="modal show" tabindex="-1" role="dialog" style="display: block;">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Help for Encoding Tools</h5>
                <button
                    on:click={() => dispatch("hideHelp")}
                    type="button"
                    class="close"
                    aria-label="Close"
                    ><span aria-hidden="true"
                        ><i class="far fa-times-circle" /></span
                    ></button
                >
            </div>
            <div class="modal-body">
                <div>
                    <h1>What is encoding tools?</h1>
                    <p>
                        Encoding tools is a graphical utility for putting text
                        or binary data through an abritrary series of
                        transforms. This tool can be useful for security
                        researchers or programmers who need to encode or decode
                        strings with multiple steps, e.g. to decode an
                        obfuscated string in a URL path, you may need to perform
                        multiple steps: String → URL decode → Base64 decode.
                    </p>
                    <p>
                        For more information, see this
                        <a
                            href="https://markhaa.se/series/encoding-tools/"
                            target="_blank">series of blog posts.</a
                        >
                    </p>
                    <p>
                        Encoding tools is released under the GPL3.
                        <a
                            href="https://github.com/mehaase/encoding-tools"
                            target="_blank">Go to the GitHub repo.</a
                        >
                    </p>
                    <h1>How do I use it?</h1>
                    <p>
                        The toolbox on the right side of the screen contains all
                        of the gadgets you can use. Drag a gadget onto the
                        workspace (the area with the gridlines). Connect two
                        gadgets together by drawing a pipe from gadget's output
                        port to the other gadget's input port. Then enter some
                        text into the input gadget and you will see all of the
                        connected gadgets update the results as you type.
                    </p>
                    <h1>How do I delete things?</h1>
                    <p>
                        Right click on a gadget's header (the colored area that
                        displays the gadget's name) to remove it. Right click on
                        a pipe to remove.
                    </p>
                    <h1>Why am I getting nulls?</h1>
                    <p>
                        A gadget that transforms an input will display <code
                            >null</code
                        >
                        when its input is not connected to anything. Some transforms
                        will also display null if their input is invalid, for example
                        trying to hex decode an odd number of characters.
                        <strong
                            >Don't forget that white space counts as characters!</strong
                        >
                    </p>
                    <h1>Keyboard shortcuts</h1>
                    <ul>
                        <li><code>?</code> toggle help</li>
                        <li><code>t</code> toggle toolbox</li>
                    </ul>
                    <p class="built-with">
                        Built with
                        <a href="https://svelte.dev/" target="_blank"
                            >Svelte.js</a
                        >
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    div.modal {
        background-color: rgba(0, 0, 0, 0.5);
    }

    div.modal-dialog {
        max-width: 750px;
    }

    div.modal-body {
        height: 80vh;
        overflow-y: scroll;
    }

    .built-with {
        font-weight: bold;
        text-align: center;
    }
</style>
