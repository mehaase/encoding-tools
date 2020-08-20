# Encoding Tools

## Overview

This is a web application that makes it easy to apply various transformations to
text and binary strings.

## License

This application is licensed under the GNU General Public License version 3.
See the LICENSE.md file included with this application for more information.

## Dev Server

To set put the development environment, you need Dart 2.7. Run `pub get` in the
repository root, then `pub global activate webdev`.

After the initial setup is complete, run the dev server: `webdev serve --auto restart`.
In Chrome, navigate to [http://localhost:8000](http://localhost:8000). This
configuration has hot reloading for modules, so everytime you save a source code file,
the browser will automatically reload the application to show the new changes. This
makes for a quick edit/run cycle. If you choose not to use Chrome or Chromium, you may
omit the `--auto restart` flags.

## Build & Deploy

To build:

```
$ rm -fr build
$ webdev build
```

The resulting build can be placed in any web root. To deploy to an Amazon S3 bucket:

```
$ aws s3 --profile semisuper sync --delete build s3://encoding.tools
```

## Adding A New Gadget

1. Create a new gadget source file. (Or copy an existing one.)
2. Implement gadget functionality.
3. Add gadget to all.dart.
4. Add gadget to drawer.dart.
5. Add gadget to factory.dart.
