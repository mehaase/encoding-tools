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
import 'dart:math' as math;

import '../base_component.dart';
import '../elements.dart';
import 'pipe.dart';
import 'port.dart';

const int GRID_SIZE = 20;

/// Base class for gadgets that implements some shared functionality.
abstract class BaseGadget extends BaseComponent {
    /// The header area where the gadget name is displayed.
    Element header;

    /// The root element containing the header and body.
    Element root;

    /// A stream of drag events.
    StreamSubscription<MouseEvent> dragEvents;

    /// Subscription to right clicks.
    StreamSubscription<MouseEvent> rightClickEvents;

    /// List of input ports.
    List<InputPort> inputs;

    /// List of output ports.
    List<OutputPort> outputs;

    /// Used for moving gadgets around in the workspace.
    void startMove(MouseEvent startEvent) {
        var parent = this.root.parent;
        var offset = startEvent.offset + parent.offset.topLeft;

        var moveListener = document.onMouseMove.listen((MouseEvent moveEvent) {
            this.moveToPixel(moveEvent.client - offset);
            this.inputs?.forEach((input) => input.movePipe());
            this.outputs?.forEach((output) => output.movePipes());
        });

        document.onMouseUp.take(1).listen((MouseEvent finishEvent) {
            this.moveToPixel(finishEvent.client - offset, snap: true);
            this.inputs?.forEach((input) => input.movePipe());
            this.outputs?.forEach((output) => output.movePipes());
            moveListener.cancel();
        });
    }

    /// Return a list of all pipes connected to this gadget's ports.
    List<Pipe> getPipes() {
        var pipes = new List<Pipe>();
        for (var input in this.inputs) {
            if (input.pipe != null) {
                pipes.add(input.pipe);
            }
        }
        for (var output in this.outputs) {
            pipes.addAll(output.pipes);
        }
        return pipes;
    }

    /// Attach this component to the DOM.
    void mount(Element parent) {
        if (this.header != null) {
            this.dragEvents = this.header.onMouseDown.listen(this.startMove);
            this.rightClickEvents = this.header.onContextMenu.listen((event) {
                event.preventDefault();
                var ce = new CustomEvent('removeGadget', detail: this);
                this.root.dispatchEvent(ce);
            });
        }
    }

    /// Remove this component from the DOM.
    void unmount() {
        this.dragEvents?.cancel();
        this.dragEvents = null;
        this.rightClickEvents?.cancel();
        this.rightClickEvents = null;
        this.inputs.forEach((input) => input.unmount());
        this.outputs.forEach((outputs) => outputs.unmount());
        this.root.remove();
        super.unmount();
    }

    /// Position the element absolutely using grid coordinates.
    void moveToGrid(Point p) {
        var left = p.x * GRID_SIZE;
        var top = p.y * GRID_SIZE;
        this.root.style.top = '${top}px';
        this.root.style.left = '${left}px';
    }

    /// Position the element absolutely using pixel coordinates.
    ///
    /// If snap is true, then round off to nearest multiple of `GRID_SIZE`.
    void moveToPixel(Point p, {bool snap: false}) {
        var top = p.y;
        var left = p.x;
        if (snap) {
            top = (top / GRID_SIZE).round() * GRID_SIZE;
            left = (left / GRID_SIZE).round() * GRID_SIZE;
        }
        top = math.max(0, top);
        left = math.max(0, left);
        this.root.style.top = '${top}px';
        this.root.style.left = '${left}px';
    }
}
