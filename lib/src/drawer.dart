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

import 'dart:async';
import 'dart:html';

import 'base_component.dart';
import 'elements.dart';
import 'gadgets/all.dart';
import 'gadgets/factory.dart';

/// Displays a collection of gadgets that may be added to the workspace.
class Drawer extends BaseComponent {
    Element _root;
    dynamic _draggedGadget;
    DivElement _draggedGadgetContainer;
    List<StreamSubscription> _subscriptions;

    /// Constructor
    Drawer() {
        this._subscriptions = [];
    }

    /// Create and mount the drawer component.
    void mount(Element parent) {
        this._root = $div()
            ..id = 'drawer'
            ..append($h1()..appendText('Gadget Drawer'))
            ..append(this._gadgetHandle(new InputGadget()))
            ..append($h2()..appendText('Change Base'))
            ..append(this._gadgetHandle(new Base64DecoderGadget()))
            ..append(this._gadgetHandle(new Base64EncoderGadget()))
            ..append(this._gadgetHandle(new HexDecoderGadget()))
            ..append(this._gadgetHandle(new HexEncoderGadget()))
            ..append($h2()..appendText('Hashes'))
            ..append(this._gadgetHandle(new Md5Gadget()))
            ..append(this._gadgetHandle(new Sha1Gadget()))
            ..append(this._gadgetHandle(new Sha2Gadget()))
            ..append($h2()..appendText('Web'))
            ..append(this._gadgetHandle(new HtmlDecoderGadget()))
            ..append(this._gadgetHandle(new HtmlEncoderGadget()))
            ..append(this._gadgetHandle(new UrlDecoderGadget()))
            ..append(this._gadgetHandle(new UrlEncoderGadget()));

        parent.append(this._root);
    }

    /// Show or hide the drawer.
    void toggle() {
        this._root.classes.toggle('hidden');
    }

    /// Remove the drawer from the DOM.
    void unmount() {
        for (var subscription in this._subscriptions) {
            subscription.cancel();
        }
        this._subscriptions.clear();
        this._root.remove();
    }

    /// Returns a new gadget handle that is registered for drag-and-drop
    /// operations.
    DivElement _gadgetHandle(BaseGadget gadget) {
        var meta = gadget.getMeta();
        var handle = $div()
            ..className = "gadget-handle ${meta.cssClass}"
            ..appendText(meta.title)
            ..draggable = true;

        this._subscriptions.add(handle.onDragStart.listen(
            (e) => this._onDragStart(e, gadget)));
        this._subscriptions.add(handle.onDragEnd.listen(this._onDragEnd));

        return handle;
    }

    /// Handle the start of a drag-and-drop operation.
    void _onDragStart(MouseEvent event, dynamic gadget) {
        event.stopPropagation();

        // This is a weird hack where the element to be displayed as the drag
        // image has to be attached to the DOM. It's z-index will put it
        // underneath the workspace.
        var div = $div();
        div.style
            ..position = 'absolute'
            ..zIndex = '-1'
            ..paddingTop = '20px'
            ..top = '40px'
            ..left = '40px'
            ..width = '320px'
            ..height = '160px'
            ..opacity = '0.5';
        gadget.mount(div);
        document.body.append(div);

        // Set the drag image location to be proportional to the location of
        // the click within the gadget handle.
        var offset = event.offset;
        var tclient = (event.target as HtmlElement).client;
        var hclient = gadget.header.client;
        var x = (offset.x / tclient.width  * hclient.width).round();
        var y = (offset.y / tclient.height * hclient.height).round();
        var meta = gadget.getMeta();
        var data = '${meta.name};$x;$y';
        event.dataTransfer
            ..effectAllowed = 'copy'
            // The y coordinate needs to add in the paddingTop from above.
            ..setDragImage(div, x, y + 20)
            ..setData('text/plain', data);

        this._draggedGadget = gadget;
        this._draggedGadgetContainer = div;
    }

    /// Handle the end of a drag-and-drop operation.
    void _onDragEnd(MouseEvent event) {
        this._draggedGadget.unmount();
        this._draggedGadget = null;
        this._draggedGadgetContainer.remove();
        this._draggedGadgetContainer = null;
    }
}
