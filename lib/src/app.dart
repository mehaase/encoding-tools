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

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:logging/logging.dart';

import 'components/input.dart';
import 'components/md5.dart';
import 'services/value.dart';

final Logger log = new Logger('app');
InputComponent ic;

@Component(
    selector: 'app',
    templateUrl: 'app.html',
    directives: const [CORE_DIRECTIVES, InputComponent, Md5Component],
    providers: const [ValueService]
)
class AppComponent {
    AppComponent() {
        Logger.root.level = Level.ALL;
        Logger.root.onRecord.listen((LogRecord rec) {
            window.console.log(
                '${rec.time} [${rec.level.name}]'
                ' ${rec.loggerName}: ${rec.message}'
            );
        });
    }
}
