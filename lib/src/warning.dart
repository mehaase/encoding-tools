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

import 'base_component.dart';
import 'elements.dart';

/// Displays a full-screen warning message.
class WarningComponent extends BaseComponent
{
    Node _warningText;

    /// Constructor
    WarningComponent(String warning) {
        this._warningText = new Text(warning);
    }

    /// Create and mount the application component.
    void mount(Element parent) {
        var okButton = $button()
            ..type = 'button'
            ..className = 'btn btn-outline-dark'
            ..style.marginRight = '1em'
            ..append($i()..className = 'fas fa-check-circle')
            ..appendText(' OK');

        var warningDiv = $div()
            ..className = 'warning'
            ..append($h1()
                ..append($i()..className='fas fa-exclamation-triangle')
                ..appendText(' Warning')
            )
            ..append($p()..append(this._warningText))
            ..append(okButton);

        parent.append(warningDiv);
        okButton.onClick.take(1).listen((event) => warningDiv.remove());
    }
}
