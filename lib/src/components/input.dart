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

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../services/value.dart';

const String SELECTOR = 'transform-input';

@Component(
    selector: SELECTOR,
    templateUrl: 'input.html',
    directives: const [CORE_DIRECTIVES, formDirectives]
)
class InputComponent {
    /// Stream controller for emitting value events.
    StreamController<ValueEvent> _streamController;

    /// Constructor.
    InputComponent(ValueService valueService) {
        var name = 'tx1'; // TODO auto name generation
        this._streamController = valueService.registerValueProvider(name);
    }

    /// Hooked to ngModelChange
    void setInput(String value) {
        this._streamController.add(new ValueEvent(value.codeUnits));
    }
}
