/// Encoding Tools
/// Copyright (C) 2018 Mark E. Haase
///
/// This program is free software: you can redistribute it and/or modify
/// it under the terms of the GNU Affero General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// This program is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU Affero General Public License for more details.
///
/// You should have received a copy of the GNU Affero General Public License
/// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:html';

import 'package:logging/logging.dart';

import 'base_component.dart';
import 'drawer.dart';
import 'elements.dart';
import 'workspace.dart';

final Logger log = new Logger('app');

class AppComponent extends BaseComponent
{
    /// The drawer that displays all available gadgets.
    Drawer drawer;

    /// The workspace is where gadgets are instantiated and connected together.
    Workspace workspace;

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
        this.workspace = new Workspace();
    }

    /// Create and mount the application component.
    void mount(Element parent) {
        // Clear the loading message.
        while (parent.firstChild != null) {
            parent.firstChild.remove();
        }

        // Mount the application component.
        parent
            ..append(
                $nav()
                ..className = 'navbar navbar-expand-lg navbar-light bg-light border-bottom'
                ..append(
                    $span()
                    ..className = 'navbar-brand'
                    ..appendText('Encoding Tools ')
                    ..append($i()..className = 'fas fa-wrench')
                )
            );

        this.drawer.mount(parent);
        this.workspace.mount(parent);
    }

    /// Do not allow unmounting.
    void unmount() {
        throw new Exception('The application component cannot be unmounted');
    }
}
