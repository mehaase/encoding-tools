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

const String MATOMO_DOMAIN = 'semisuper.innocraft.cloud';
const String MATOMO_SITE_ID = '2';

/// Adds tracking code to the DOM.
void registerTrackingCode() {
    if (context['_paq'] == null) {
        context['_paq'] = new JsArray();
    }

    var paq = context['_paq'];
    var baseUrl = 'https://${MATOMO_DOMAIN}/';
    var trackerUrl = '${baseUrl}piwik.php';
    var javascriptUrl = '${baseUrl}piwik.js';

    paq.add(new JsArray.from(['trackPageView']));
    paq.add(new JsArray.from(['enableLinkTracking']));
    paq.add(new JsArray.from(['setTrackerUrl', trackerUrl]));
    paq.add(new JsArray.from(['setSiteId', MATOMO_SITE_ID]));

    document.body.append(
        $script()
        ..type = 'text/javascript'
        ..src = javascriptUrl
    );
}
