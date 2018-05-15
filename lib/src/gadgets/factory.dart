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

import 'all.dart';

/// Instantiate a new gadget based on a type name.
BaseGadget gadgetFactory(String type) {
    switch (type) {
        case 'base64-decoder':
            return new Base64DecoderGadget();
        case 'base64-encoder':
            return new Base64EncoderGadget();
        case 'hex-decoder':
            return new HexDecoderGadget();
        case 'hex-encoder':
            return new HexEncoderGadget();
        case 'html-decoder':
            return new HtmlDecoderGadget();
        case 'html-encoder':
            return new HtmlEncoderGadget();
        case 'input':
            return new InputGadget();
        case 'md5':
            return new Md5Gadget();
        case 'sha1':
            return new Sha1Gadget();
        case 'sha2':
            return new Sha2Gadget();
        case 'url-decoder':
            return new UrlDecoderGadget();
        case 'url-encoder':
            return new UrlEncoderGadget();
        default:
            throw new Exception('Cannot construct gadget type: $type');
    }
}
