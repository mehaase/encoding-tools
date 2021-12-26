# Encoding.Tools

## Overview

Encoding.Tools is a web application that makes it easy to chain together various
transformations on binary strings.

<iframe src="https://player.vimeo.com/video/660256549?h=b19e017bd4" width="640" height="526" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>

## Getting Started

The easiest and fastest way to use the application is the hosted version at
[https://encoding.tools/](https://encoding.tools/).

You can also run it locally if you want to use it offline. You need to have [Node.js and
NPM installed](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) and
cloned this repo.

Next, install the NPM dependencies. You only need to run this step once after the
initial cloning of the repo, and once more after any updates.

```bash
npm install
```

Once the dependencies are installed, run this command to build the application.

```bash
npm run build
```

In your browser, open the file `public/index.html` and it should operate locally just
like the hosted version.

## Development

### Dev Setup
If you want to modify Encoding.Tools' code, follow the steps above to get it running
locally. Once that it is working, then run:

Once the dependencies are installed, start the server:

```bash
npm run dev
```

The application will now be running on [http://localhost:5000/](http://localhost:5000/).
The server has live reloading, so everytime you edit and save a source file, it will
automatically reload the application in your browser.

> By default, the server will only respond to requests from localhost. To allow
> connections from other computers, edit the `sirv` commands in package.json to include
> the option `--host 0.0.0.0`.

The application is written [in SvelteJS](https://svelte.dev/) which is a Reactive
framework that uses a compiler to make DOM updates lean and efficient. If you're new to
Svelte, the following are good resources to start learning:

* [SvelteJS Tutorial](https://svelte.dev/tutorial/basics)
* [SvelteJS Docs](https://svelte.dev/docs)

If you're using [Visual Studio Code](https://code.visualstudio.com/), you should install
the official extension [Svelte for VS
Code](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode). If you
are using other editors you may need to install a plugin in order to get syntax
highlighting and intellisense.

### Adding a New Gadget

Gadgets are the core concept in Encoding.Tools. Each gadget is able to read an input
stream of bytes, transform it in some way, and write the results to an output stream.
Write a new gadget involves the following steps.

1. (Optional) If your transform logic depends on an NPM package, install that package:
   `npm install --save-dev <PACKAGE>`
2. (Optional) Create a new gadget family (gadgets are grouped by family in the toolbox)
    1. Copy the imports from one of the existing files, e.g.
       `src/gadgets/ChangeBaseGadget.js`.
    2. Create a `Base<Family>` class that extends `BaseGadget` and overrides the
       constructor to set up the family name and CSS class. You may also want to set up
       the input and output ports in the constructor, if all gadgets in a family will
       have identical port setups.
3. Add a new class to the chosen gadget family file (e.g.
   `src/gadgets/ChangeBaseGadget.js`) that extends the `Base<Family>` class of the
   chosen gadget family.
4. Override the transform() method. This method should generally:
    1. Read from the gadget's input ports. Each input port has a `Buffer` that contains
       the data.
    2. Update the components display state, setting it to `DisplayState.null()`,
       `DisplayState.error("error message")`, or `DisplayState.text("text to display")`.
    3. Write the transformed data as a `Buffer` to the output ports.
5. Register the new gadget in `GadgetRegistry.js`, e.g. `gadgetRegistry.register((...args) => new HexEncodeGadget(...args));`

## License

This application is licensed under the GNU General Public License version 3. See the
[LICENSE.md](LICENSE.md) file included with this application for more information.
