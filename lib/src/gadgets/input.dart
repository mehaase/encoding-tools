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

class InputGadget extends BaseGadget {
    /// Writes data from textarea to out0.
    OutputPort out0;

    /// The textarea that contains the user's input.
    TextAreaElement textarea;

    /// A subscription to keyboard events.
    StreamSubscription _keyboardSubscription;

    /// Constructor
    InputGadget() {
        this.header = $div()
            ..className = 'header'
            ..appendText('Input');

        this.textarea = $textarea()
            ..cols = 40
            ..rows = 2;

        this._keyboardSubscription = this.textarea.onKeyUp.listen(
            this._handleKeyboard);

        this.root = $div()
            ..className='gadget input-gadget'
            ..append(header)
            ..append(
                $div()
                ..className = 'content'
                ..append(textarea)
            );
    }

    /// Mount this gadget to its parent.
    void mount(Element parent) {
        this.out0 = new OutputPort(0)..mount(this.root);
        parent.append(this.root);
        super.mount(parent);
    }

    /// Called when the component is destroyed.
    void unmount() {
        this._keyboardSubscription.cancel();
        this._keyboardSubscription = null;
        this.out0.unmount();
        super.unmount();
    }

    /// Handles keyboard events in the textarea.
    void _handleKeyboard(KeyboardEvent event) {
        var value = this.textarea.value;
        var data = value?.length == 0 ? null : value.codeUnits;
        this.out0.send(data);
    }
}
