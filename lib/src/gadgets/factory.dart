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

import 'base_gadget.dart';
import 'input.dart';
import 'md5.dart';
import 'sha1.dart';
import 'sha2.dart';

/// Instantiate a new gadget based on a type name.
BaseGadget gadgetFactory(String type) {
    switch (type) {
        case 'input':
            return new InputGadget();
        case 'md5':
            return new Md5Gadget();
        case 'sha1':
            return new Sha1Gadget();
        case 'sha2':
            return new Sha2Gadget();
        default:
            throw new Exception('Cannot construct gadget type: $type');
    }
}
