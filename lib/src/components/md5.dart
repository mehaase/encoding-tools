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
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../model/gadget.dart';

@Component(
    selector: 'md5-gadget',
    templateUrl: 'md5.html',
    directives: const [CORE_DIRECTIVES]
)
class Md5Gadget extends BaseGadget implements OnChanges {
    /// This gadget has one input.
    @Input()
    GadgetPipe input;

    /// This gadget outputs the MD5 hash of its input.
    @Input()
    GadgetPipe output;

    String digest;

    /// Calculate MD5 digest of the input.
    void transform(List<int> data) {
        var hashBytes = md5.convert(data).bytes;
        this.digest = hex.encode(hashBytes);
        this.send(this.output, hashBytes);
    }

    /// Wire up the inputs and outputs.
    ///
    /// Angular calls this when the properties change.
    void ngOnChanges(Map<String,SimpleChange> changes) {
        changes.forEach((property, change) {
            if (property == 'input') {
                this.rewire(change, this.transform);
            }
        });
    }
}
