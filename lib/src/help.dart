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

import 'dart:async';
import 'dart:html';

import 'base_component.dart';
import 'elements.dart';

const String HELP_CONTENT = '''<h1>What is encoding tools?</h1>
<p>
    Encoding tools is a graphical utility for putting text or binary data
    through an abritrary series of transforms. This tool can be useful for
    security researchers or programmers who need to encode or decode strings
    with multiple steps, e.g. to decode an obfuscated string in a URL path, you
    may need to perform multiple steps: String → URL decode → Base64 decode.
</p>
<p>
    For more information, see this
    <a href="https://markhaa.se/introducing-encoding-tools.html">introductory blog post.</a>
</p>
<h1>How do I use it?</h1>
<p>
    The drawer on the right side of the screen contains all of the gadgets you
    can use. Drag a gadget onto the workspace (the area with the gridlines).
    Connect two gadgets together by drawing a pipe from gadget's output port to
    the other gadget's input port. Then enter some text into the input gadget
    and you will see all of the connected gadgets update the results as you
    type.
</p>
<h1>How do I delete things?</h1>
<p>
    Right click on a gadget's header (the colored area that displays the
    gadget's name) to remove it. Right click on a pipe to remove.
</p>
<h1>Why am I getting nulls?</h1>
<p>
    A gadget that transforms an input will display <code>null</code> when its
    input is not connected to anything. Some transforms will also display null
    if their input is invalid, for example trying to hex decode an odd number
    of characters. <strong>Don't forget that white space counts as
    characters!</strong>
</p>
<h1>Keyboard shortcuts</h1>
<ul>
    <li><code>?</code> toggle help
    <li><code>g</code> toggle gadget drawer
</ul>''';

class HelpComponent extends BaseComponent
{
    StreamSubscription<MouseEvent> _onClickSubscription;
    DivElement _modal;
    bool _showing = false;

    /// Attach the help component to the DOM.
    void mount(Element parent) {
        var closeEl = $span()
            ..attributes['aria-hidden'] = 'true'
            ..append(
                $i()
                ..className = 'far fa-times-circle'
            );

        this._onClickSubscription = closeEl.onClick.listen((event) {
            this.toggle();
        });

        var header = $div()
            ..className = 'modal-header'
            ..append(
                $h5()
                ..className = 'modal-title'
                ..appendText('Help for Encoding Tools')
            )
            ..append(
                $button()
                ..type = 'button'
                ..className = 'close'
                ..attributes['aria-label'] = 'Close'
                ..append(closeEl)
            );

        var nodeValidator = new NodeValidatorBuilder()
            ..allowHtml5(uriPolicy: new HelpUriPolicy());

        var body = $div()
            ..className = 'modal-body'
            ..append(
                $div()
                ..setInnerHtml(HELP_CONTENT, validator: nodeValidator)
            );

        this._modal = $div()
            ..className = 'modal'
            ..tabIndex = -1
            ..attributes['role'] = 'dialog'
            ..append(
                $div()
                ..className = 'modal-dialog'
                ..attributes['role'] = 'document'
                ..append(
                    $div()
                    ..className = 'modal-content'
                    ..append(header)
                    ..append(body)
                )
            );

        parent.append(this._modal);
    }

    /// Show or hide the help content.
    void toggle() {
        if (this._showing) {
            document.body.classes.remove('modal-open');
            this._modal.style.display = null;
            this._modal.classes.remove('show');
        } else {
            document.body.classes.add('modal-open');
            this._modal.style.display = 'block';
            this._modal.classes.add('show');
        }
        this._showing = !this._showing;
    }

    /// Remove the help component from the DOM.
    void unmount() {
        this._modal.remove();
        this._modal = null;
        this._onClickSubscription.cancel();
        this._onClickSubscription = null;
    }
}

/// Allow hrefs to the Encoding Tools blog.
class HelpUriPolicy implements UriPolicy {
    bool allowsUri(String uri) {
        return uri.startsWith('https://markhaa.se');
    }
}
