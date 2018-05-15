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

import 'dart:convert';
import 'dart:html';

import '../elements.dart';
import 'base_gadget.dart';
import 'port.dart';

class HtmlEncoderGadget extends BaseGadget {
    /// The element that displays the result.
    SpanElement display;

    /// Constructor
    HtmlEncoderGadget() {
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
        return new GadgetMeta('html-encoder', 'web-gadget', 'HTML Encode');
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
        var encoded;

        if (input == null) {
            encoded = null;
        } else {
            encoded = HTML_ESCAPE.convert(new String.fromCharCodes(input));
        }

        this._setDisplay(encoded);
        this.outputs[0].send(encoded?.codeUnits);
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
