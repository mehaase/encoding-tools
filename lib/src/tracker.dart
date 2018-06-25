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

const String SITE_ID = '5b31330dcf25ea7a0e43b6d5';

/// Adds tracking code to the DOM.
void registerTrackingCode() {
    context['_gauges'] = new JsArray();
    document.body.append(
        $script()
        ..type = 'text/javascript'
        ..async = true
        ..id = 'gauges-tracker'
        ..attributes['data-site-id'] = SITE_ID
        ..attributes['data-track-path'] = 'https://track.gaug.es/track.gif'
        ..src = 'https://d2fuc4clr7gvcn.cloudfront.net/track.js'
    );
}
