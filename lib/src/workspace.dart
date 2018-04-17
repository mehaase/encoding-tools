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
import 'dart:html';

import 'base_component.dart';
import 'elements.dart';
import 'gadgets/input.dart';
import 'gadgets/md5.dart';
import 'gadgets/pipe.dart';

/// A view container for gadgets..
class Workspace extends BaseComponent {
    /// Create and mount the workspace component.
    void mount(Element parent) {
        var inputGadget = new InputGadget();
        inputGadget.moveToGrid(new Point(1, 1));
        inputGadget.mount(parent);

        var md5Gadget1 = new Md5Gadget();
        md5Gadget1.moveToGrid(new Point(3, 9));
        md5Gadget1.mount(parent);

        var md5Gadget2 = new Md5Gadget();
        md5Gadget2.moveToGrid(new Point(1, 15));
        md5Gadget2.mount(parent);

        md5Gadget1.in0.connect(inputGadget.out0);
        md5Gadget2.in0.connect(md5Gadget1.out0);

        var pipe1 = new Pipe();
        pipe1.moveToGrid(new Point(2, 7), new Point(4, 8));
        pipe1.mount(parent);

        var pipe2 = new Pipe();
        pipe2.moveToGrid(new Point(4, 13), new Point(2, 14));
        pipe2.mount(parent);
    }
}
