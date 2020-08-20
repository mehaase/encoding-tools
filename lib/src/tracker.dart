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
import 'dart:js';

import 'elements.dart';

const String TRACKER_URL = 'https://www.googletagmanager.com/gtag/js?id=';
const String GOOGLE_ANALYTICS_ID = 'UA-41836740-2';

/// Adds tracking code to the DOM.
void registerTrackingCode() {
    context['ENCODING_TOOLS_TRACKER_ID'] = GOOGLE_ANALYTICS_ID;
    var trackerUrl = TRACKER_URL + GOOGLE_ANALYTICS_ID;

    if (document.querySelector('script[src="tracker.js"]') == null) {
      document.body.append(
          $script()
          ..type = 'text/javascript'
          ..async = true
          ..src = 'tracker.js'
      );
    }

    if (document.querySelector('script[src="$trackerUrl"]') == null) {
      document.body.append(
          $script()
          ..type = 'text/javascript'
          ..async = true
          ..src = trackerUrl
      );
    }
}
