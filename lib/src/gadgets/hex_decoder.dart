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

import 'dart:html';

import 'package:convert/convert.dart';

import '../elements.dart';
import 'base_gadget.dart';
import 'port.dart';

class HexDecoderGadget extends BaseGadget {
    /// The element that displays the result.
    SpanElement display;

    /// Constructor
    HexDecoderGadget() {
        var meta = this.getMeta();
        this.display = $span();
        this._setDisplay(null);

        this.header = $div()
            ..className = 'header'
            ..appendText(meta.title);

        this.root = $div()
            ..className = 'gadget ${meta.cssClass}'
            ..style.width = '280px'
            ..append(header)
            ..append(
                $div()
                ..className = 'content'
                ..append(this.display)
            );
    }

    /// Return metadata for MD5 gadget.
    GadgetMeta getMeta() {
        return new GadgetMeta('hex-decoder', 'change-base-gadget', 'Hex Decode');
    }

    /// Mount this gadget to the DOM.
    void mount(Element parent) {
        this.inputs = [new InputPort(0, this.transform)..mount(this.root)];
        this.outputs = [new OutputPort(0)..mount(this.root)];
        parent.append(this.root);
        super.mount(parent);
    }

    /// URL encode the input.
    void transform(List<int> input) {
        var encoded, display;

        if (input == null || input.length % 2 == 1) {
            encoded = null;
            display = null;
        } else {
            encoded = hex.decode(new String.fromCharCodes(input));
            display = new String.fromCharCodes(encoded);
        }

        this._setDisplay(display);
        this.outputs[0].send(encoded);
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

        this.display.firstChild?.remove();
        this.display.append(data);
    }
}
