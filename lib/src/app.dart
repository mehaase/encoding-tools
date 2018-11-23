/* Encoding Tools
 * Copyright (C) 2018 Mark E. Haase <mehaase@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:html';

import 'package:logging/logging.dart';

import 'assembly.dart';
import 'base_component.dart';
import 'drawer.dart';
import 'elements.dart';
import 'gadgets/input.dart';
import 'help.dart';
import 'tracker.dart';
import 'warning.dart';
import 'workspace.dart';

final Logger log = new Logger('app');

const String TRACKING_DOMAIN = 'encoding.tools';
const String DEFAULT_TITLE = 'Encoding Tools';

class AppComponent extends BaseComponent
{
    /// The drawer that displays all available gadgets.
    Drawer drawer;

    /// The component that displays help text.
    HelpComponent help;

    /// The workspace is where gadgets are instantiated and connected together.
    Workspace workspace;

    /// Used to display warnings in an overlay.
    WarningComponent warning;

    HtmlElement _navTitle;

    /// Constructor.
    AppComponent() {
        Logger.root.level = Level.ALL;
        Logger.root.onRecord.listen((LogRecord rec) {
            window.console.log(
                '${rec.time} [${rec.level.name}]'
                ' ${rec.loggerName}: ${rec.message}'
            );
        });

        this.drawer = new Drawer();
        this.help = new HelpComponent();
        this.workspace = new Workspace();
    }

    /// Create and mount the application component.
    void mount(Element parent) {
        // Clear the loading message.
        while (parent.firstChild != null) {
            parent.firstChild.remove();
        }

        var helpButton = $button()
            ..type = 'button'
            ..className = 'btn btn-primary'
            ..style.marginRight = '1em'
            ..append($i()..className = 'fas fa-question-circle')
            ..appendText(' Help')
            ..onClick.listen((event) => this.help.toggle());

        var repoButton = $a()
            ..className = 'btn btn-primary'
            ..style.marginRight = '1em'
            ..append($i()..className = 'fab fa-github')
            ..appendText(' View Repo')
            ..href='https://github.com/mehaase/encoding-tools'
            ..target='_blank';

        var drawerButton = $button()
            ..type = 'button'
            ..className = 'btn btn-primary'
            ..append($i()..className = 'fas fa-toolbox')
            ..appendText(' Toolbox')
            ..onClick.listen((_) => this.drawer.toggle());

        // Mount the application component.
        this._navTitle = $span()
            ..className = 'navbar-brand'
            ..appendText('Encoding ')
            ..append($i()..className = 'fas fa-wrench')
            ..appendText(' Tools ');

        parent
            ..append(
                $nav()
                ..className = 'navbar navbar-expand-lg navbar-light bg-light border-bottom justify-content-between'
                ..append(this._navTitle)
                ..append(
                    $div()
                    ..append(helpButton)
                    ..append(repoButton)
                    ..append(drawerButton)
                )
            );

        document.onKeyPress.listen((event) {
            if (event.target is TextAreaElement) {
                return;
            }
            switch (event.key) {
                case '?':
                    event.preventDefault();
                    this.help.toggle();
                    break;
                case 't':
                    event.preventDefault();
                    this.drawer.toggle();
                    break;
            }
        });

        this.drawer.mount(parent);
        this.help.mount(parent);
        this.workspace.mount(parent);

        window.onTouchStart.take(1).listen((event) {
            this.warning = new WarningComponent('This site does not work well'
                ' on small screens or touchscreen devices.');
            this.warning.mount(parent);
        });

        // Check URL hash for assembly to load, and listen for changes to URL
        // hash.
        this._loadAssemblyFromHash();
        window.onHashChange.listen((_) => this._loadAssemblyFromHash());

        if (window.location.hostname == TRACKING_DOMAIN) {
            registerTrackingCode();
        }
    }

    /// Set the application title.
    ///
    /// This updates the window title and the title displayed in the navbar.
    void setTitle(String title) {
        var document = window.document as HtmlDocument;
        if (title == null) {
            document.title = DEFAULT_TITLE;
            this._navTitle
                ..lastChild.remove()
                ..appendText(' Tools');
        } else {
            document.title = '$title—${DEFAULT_TITLE}';
            this._navTitle
                ..lastChild.remove()
                ..appendText(' Tools: ${title}');
        }
    }

    /// Do not allow unmounting.
    void unmount() {
        throw new Exception('The application component cannot be unmounted.');
    }

    /// Load an assembly based on the URL hash.
    void _loadAssemblyFromHash() {
        var name;
        try {
            name = window.location.hash.substring(1);
        } catch (RangeError) {
            name = '';
        }
        if (name.isEmpty) {
            this.setTitle(null);
            var inputGadget = new InputGadget();
            inputGadget.moveToGrid(new Point(1, 1));
            this.workspace.addGadget(inputGadget);
        } else {
            try {
                var assembly = loadStaticAssembly(name);
                this.workspace.clear();
                for (var gadget in assembly.gadgets) {
                    this.workspace.addGadget(gadget);
                }
                for (var pipe in assembly.pipes) {
                    this.workspace.addPipe(pipe);
                }
                this.setTitle(assembly.name);
            } on AssemblyNotFound catch (anf) {
                print('Could not find assembly: ${anf.name}.');
            }
        }
    }
}
