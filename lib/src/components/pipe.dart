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

import 'dart:math';

import 'package:angular/angular.dart';

/// A visual representation of a pipe between gadgets.
@Component(
    selector: 'pipe',
    templateUrl: 'pipe.svg',
    styleUrls: const ['pipe.css'],
    directives: const [CORE_DIRECTIVES]
)
class PipeSvg {
    @HostBinding('style.left')
    String get left => '${_rect.left}px';

    @HostBinding('style.top')
    String get top => '${_rect.top}px';

    @HostBinding('style.width')
    String get width => '${_rect.width}px';

    @HostBinding('style.width')
    String get height => '${_rect.height}px';

    Rectangle _rect = const Rectangle(40, 140, 60, 100);

    PipeSvg() {
        print('${width} x $height');
    }
}
