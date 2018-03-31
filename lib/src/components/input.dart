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

import 'package:angular/angular.dart';

import '../model/gadget.dart';

@Component(
    selector: 'input-gadget',
    templateUrl: 'input.html',
    styleUrls: const ['gadget-base.css', 'gadget-input.css'],
    directives: const [CORE_DIRECTIVES]
)
class InputGadget extends BaseGadget {
    /// This gadget outputs the value of its embedded text field.
    @Input()
    GadgetPipe output;

    /// Hooked to ngModelChange
    void setInput(String value) {
        this.send(this.output, value.codeUnits);
    }
}
