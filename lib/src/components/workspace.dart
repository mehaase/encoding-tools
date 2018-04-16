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

import 'dart:async';

import 'package:angular/angular.dart';

import '../components/input.dart';
import '../components/md5.dart';
import '../components/pipe.dart';
import '../model/gadget.dart';

/// Manages the entire workspace.
@Component(
    selector: 'workspace',
    templateUrl: 'workspace.html',
    styleUrls: const ['workspace.css'],
    directives: const [CORE_DIRECTIVES, InputGadget, Md5Gadget, PipeSvg]
)
class Workspace implements AfterViewInit {
    GadgetPipe pipe1, pipe2;

    @ViewChildren(InputGadget)
    QueryList<InputGadget> inputGadgets;

    @ViewChildren(Md5Gadget)
    QueryList<Md5Gadget> md5Gadgets;

    /// Constructor
    Workspace() {
        this.pipe1 = new GadgetPipe();
        this.pipe2 = new GadgetPipe();
    }

    /// Perform initial placement of components.
    void ngAfterViewInit() {
        new Future(() {
            var x = 20;
            var y = 20;
            for (var gadget in this.inputGadgets) {
                gadget.moveToXY(x, y);
                x += 40;
                y += 200;
            }
            for (var gadget in this.md5Gadgets) {
                gadget.moveToXY(x, y);
                x += 40;
                y += 160;
            }
        });
    }
}
