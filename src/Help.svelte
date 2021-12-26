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
                <h5 class="modal-title">Help for Encoding.Tools</h5>
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
                    <h1>What is encoding.tools?</h1>
                    <p>
                        Encoding.tools is a utility for performing a series of
                        arbitrary transforms on binary data. This tool can be
                        useful for security researchers or programmers who need
                        to encode or decode strings with multiple steps, e.g. to
                        decode an obfuscated string in a web application, you
                        may need to perform multiple steps, e.g. URL decode,
                        then base64 decode, etc.
                    </p>
                    <p>
                        Each gadget reads a stream of binary data, applies some
                        transformation, and produces an output stream. You can
                        connect gadgets together to make complex chains of
                        transformations.
                    </p>
                    <h1>How do I use it?</h1>
                    <p>
                        The toolbox on the right side of the screen contains all
                        of the gadgets you can use. Drag a gadget onto the
                        workspace (the area with the gridlines). Wire two
                        gadgets together by drawing a pipe from one gadget's
                        output port to the other gadget's input port. Then enter
                        some text into the input gadget, and you will see all of
                        the connected gadgets update the results as you type.
                    </p>
                    <p>
                        If you only want one input gadget and one transform
                        gadget, then you can double click on the transform to
                        automatically add it to the workspace and wire it to the
                        input. There are also some pre-built assemblies of
                        gadgets in the warehouse that you may find useful or
                        draw inspiration from.
                    </p>
                    <p>
                        Gadgets and edges can be removed by clicking the
                        <i class="far fa-times-circle" /> icons on the gadget or
                        edge.
                    </p>
                    <h1>Keyboard shortcuts</h1>
                    <ul>
                        <li><code>?</code> toggle help</li>
                        <li><code>t</code> toggle toolbox</li>
                        <li><code>w</code> toggle warehouse</li>
                    </ul>
                    <h1>Why am I getting nulls?</h1>
                    <p>
                        A gadget will display
                        <span style="color: var(--gray);"
                            ><i class="fas fa-exclamation-triangle" /> NULL</span
                        >
                        when its input is not connected to anything or if its input
                        stream is 0 bytes long.
                        <em
                            >Don't forget that white space counts as characters!</em
                        >
                    </p>
                    <h1>Open Source &amp; Private</h1>
                    <p>
                        Encoding tools is released under the GPL3. Submit
                        feedback, suggestions, and bug reports
                        <a
                            href="https://github.com/mehaase/encoding-tools"
                            target="_blank"
                            ><i class="fab fa-github" /> on GitHub.</a
                        >
                    </p>
                    <p>
                        All data is processed locally. None of the transform
                        data is sent to the server. If you wish, you can also
                        download and run this locally and run it without an
                        internet connection.
                    </p>
                    <p>
                        Google Analytics is used to keep track of traffic on the
                        site.
                    </p>
                    <p>
                        To learn more about the project, see
                        <a
                            href="https://markhaa.se/series/encoding-tools/"
                            target="_blank">the series of blog posts.</a
                        >
                    </p>
                    <p class="built-with">
                        Built by
                        <a href="https://github.com/mehaase" target="_blank"
                            >mehaase</a
                        >
                        with
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
