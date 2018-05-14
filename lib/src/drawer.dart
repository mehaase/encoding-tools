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

import 'base_component.dart';
import 'elements.dart';
import 'gadgets/factory.dart';

/// Displays a collection of gadgets that may be added to the workspace.
class Drawer extends BaseComponent {
    /// The div container for the drawer.
    Element _root;

    /// Gadget currently being dragged.
    dynamic _draggedGadget;

    /// Container for dragged gadget.
    DivElement _draggedGadgetContainer;

    /// Create and mount the drawer component.
    void mount(Element parent) {
        this._root = $div()
            ..id = 'drawer'
            ..append(
                $h1()
                ..appendText('Gadgets ')
            )
            ..append(
                $div()
                ..className = "gadget-handle input-gadget"
                ..appendText('Input')
                ..draggable = true
                ..onDragStart.listen((e) => this._onDragStart(e, 'input'))
                ..onDragEnd.listen(this._onDragEnd)
            )
            ..append(
                $h2()
                ..appendText('Hashes ')
            )
            ..append(
                $div()
                ..className = "gadget-handle transform-gadget"
                ..appendText('MD5')
                ..draggable = true
                ..onDragStart.listen((e) => this._onDragStart(e, 'md5'))
                ..onDragEnd.listen(this._onDragEnd)
            );


        parent.append(this._root);
    }

    /// Remove the drawer from the DOM.
    void unmount() {
        this._root.remove();
    }

    /// Handle the start of a drag-and-drop operation.
    void _onDragStart(MouseEvent event, String type) {
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
        var gadget = gadgetFactory(type);
        gadget.mount(div);
        document.body.append(div);

        // Set the drag image location to be proportional to the location of
        // the click within the gadget handle.
        var offset = event.offset;
        var tclient = (event.target as HtmlElement).client;
        var hclient = gadget.header.client;
        var x = (offset.x / tclient.width  * hclient.width).round();
        var y = (offset.y / tclient.height * hclient.height).round();
        var data = '$type;$x;$y';
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
