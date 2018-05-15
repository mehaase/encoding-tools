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

import '../elements.dart';
import 'base_gadget.dart';
import 'port.dart';

class InputGadget extends BaseGadget {
    /// The textarea that contains the user's input.
    TextAreaElement textarea;

    /// A subscription to keyboard events.
    StreamSubscription _keyboardSubscription;

    /// Constructor
    InputGadget() {
        var meta = this.getMeta();

        this.header = $div()
            ..className = 'header'
            ..appendText(meta.title);

        this.textarea = $textarea()
            ..spellcheck = false
            ..placeholder = "Enter text here…"
            ..cols = 40
            ..rows = 2;

        this._keyboardSubscription = this.textarea.onKeyUp.listen(
            this._handleKeyboard);

        this.root = $div()
            ..className='gadget ${meta.cssClass}'
            ..append(header)
            ..append(
                $div()
                ..className = 'content'
                ..append(textarea)
            );
    }

    /// Metadata for input gadget.
    GadgetMeta getMeta() {
        return new GadgetMeta('input', 'input-gadget', 'Input');
    }

    /// Mount this gadget to its parent.
    void mount(Element parent) {
        this.inputs = [];
        this.outputs = [new OutputPort(0)..mount(this.root)];
        parent.append(this.root);
        super.mount(parent);
    }

    /// Called when the component is destroyed.
    void unmount() {
        this._keyboardSubscription.cancel();
        this._keyboardSubscription = null;
        super.unmount();
    }

    /// Handles keyboard events in the textarea.
    void _handleKeyboard(KeyboardEvent event) {
        var value = this.textarea.value;
        var data = value?.length == 0 ? null : value.codeUnits;
        this.outputs[0].send(data);
    }
}
