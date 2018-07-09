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

const String SITE_ID = 'UA-41836740-2';

/// Adds tracking code to the DOM.
void registerTrackingCode() {
    document.body.append(
        $script()
        ..type = 'text/javascript'
        ..async = true
        ..src = 'https://www.googletagmanager.com/gtag/js?id=${SITE_ID}'
    );
    if (context['dataLayer'] == null) {
        context['dataLayer'] = new JsArray();
    }
    var date = new JsObject(context['Date']);
    context['dataLayer'].add(new JsArray.from(['js', date]));
    context['dataLayer'].add(new JsArray.from(['config', SITE_ID]));
}
