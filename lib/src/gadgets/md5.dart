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

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../elements.dart';
import 'base_gadget.dart';
import 'port.dart';

class Md5Gadget extends BaseGadget {
    /// The element that displays the hash.
    SpanElement display;

    /// Constructor
    Md5Gadget() {
        this.display = $span();
        this._setDisplay(null);

        this.header = $div()
            ..className = 'header'
            ..appendText('MD5');

        this.root = $div()
            ..className = 'gadget transform-gadget'
            ..append(header)
            ..append(
                $div()
                ..className = 'content'
                ..append(this.display)
            );
    }

    /// Mount this gadget to the DOM.
    void mount(Element parent) {
        this.inputs = [new InputPort(0, this.transform)..mount(this.root)];
        this.outputs = [new OutputPort(0)..mount(this.root)];
        parent.append(this.root);
        super.mount(parent);
    }

    /// Called when the component is destroyed.
    void unmount() {
        super.unmount();
    }

    /// Calculate MD5 digest of the input.
    void transform(List<int> input) {
        var data;
        var digest;

        if (input == null) {
            data = null;
            digest = null;
        } else {
            data = md5.convert(input).bytes;
            digest = hex.encode(data);
        }

        this._setDisplay(digest);
        this.outputs[0].send(data);
    }

    /// Update the gadget's display with new data.
    void _setDisplay(String digest) {
        var data;

        if (digest == null) {
            data = $span()
                ..className = 'null'
                ..appendText('null');
        } else {
            data = $pre()
                ..className = 'user-select'
                ..appendText(digest);
        }

        this.display
            ..firstChild?.remove()
            ..append(data);
    }
}
