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

const int GRID_SIZE = 20;

/// Base class for gadgets that implements some shared functionality.
abstract class BaseGadget extends BaseComponent {
    Element header;
    Element root;
    StreamSubscription<MouseEvent> dragEvents;

    /// Used for moving gadgets around in the workspace.
    void startMove(MouseEvent startEvent) {
        var parent = this.root.parent;
        var offset = startEvent.offset + parent.offset.topLeft;

        var moveListener = document.onMouseMove.listen((MouseEvent moveEvent) {
            this.moveToPixel(moveEvent.client - offset);
        });

        document.onMouseUp.take(1).listen((MouseEvent finishEvent) {
            this.moveToPixel(finishEvent.client - offset, snap: true);
            moveListener.cancel();
        });
    }

    void mount(Element parent) {
        if (this.header != null) {
            this.dragEvents = this.header.onMouseDown.listen(this.startMove);
        }
    }

    void unmount() {
        if (this.dragEvents != null) {
            this.dragEvents.cancel();
            this.dragEvents = null;
        }
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

/// A callback that is invoked when data is received.
typedef void DataReceivedHandler(List<int> data);


/// Encapsulates information about a user interaction with a port.
class PortEventData {
    dynamic port;
    Point center;
    Event event;
    PortEventData(this.port, this.center, this.event);
}

/// Represents an input port on a gadget.
///
/// Duplicates a lot of logic in OutputPort, which could probably be refactored.
class InputPort extends BaseComponent {
    /// Indicates whether the port is currently connected.
    bool get connected => this._subscription != null;

    /// The div element depicting this port.
    DivElement _div;

    /// The port number; currently used only for positioning the port on the
    /// parent element.
    int _portNum;

    /// A callback that is invoked for every data event.
    DataReceivedHandler _handler;

    /// Subscription to an output port's event stream.
    StreamSubscription<List<int>> _subscription;

    /// Subscription to mouse down events on this port.
    StreamSubscription<MouseEvent> _mouseDownEvents;

    /// Subscription to mouse up events on this port.
    StreamSubscription<MouseEvent> _mouseUpEvents;

    /// Constructor
    InputPort(this._portNum, this._handler);

    /// Connect this input to the specified output port.
    void connect(OutputPort out) {
        if (this._subscription != null) {
            throw new Exception(
                'Cannot connect input port; it is already connected');
        }
        this._subscription = out.stream.listen(this._handler);
        this._div.classes.add('connected');
    }

    /// Disconnect this input from its currently attached output port.
    void disconnect () {
        if (this._subscription == null) {
            throw new Exception(
                'Cannot disconnect input port; it is not connected to anything');
        }
        this._subscription.cancel();
        this._subscription = null;
        this._div.classes.remove('connected');
    }

    /// Mount this port to the DOM.
    void mount(Element parent) {
        this._div = $div()..className = 'input-port port${_portNum}';
        this._mouseDownEvents = this._div.onMouseDown.listen(this._onMouseDown);
        this._mouseUpEvents = this._div.onMouseUp.listen(this._onMouseUp);
        parent.append(this._div);
    }

    /// Called when the component is destroyed.
    void unmount() {
        /// Clean up connection.
        if (this.connected) {
            this.disconnect();
        }

        /// Clean up event handling.
        this._mouseDownEvents.cancel();
        this._mouseDownEvents = null;
        this._mouseUpEvents.cancel();
        this._mouseUpEvents = null;

        /// Clean up DOM.
        this._div.remove();
        super.unmount();
    }

    /// Handles mouse down events on this port by emitting a mouseDownOnPort
    /// event.
    void _onMouseDown(MouseEvent event) {
        if (event.button != 0 || this.connected) {
            return;
        }
        event.stopPropagation();
        var center = this._getCenter();
        var ped = new PortEventData(this, center, event);
        var ce = new CustomEvent('startPipe', detail: ped);
        this._div.dispatchEvent(ce);
    }

    /// Handles mouse up events on this port by emitting a mouseUpOnPort
    /// event.
    void _onMouseUp(MouseEvent event) {
        event.stopPropagation();
        var center = this._getCenter();
        var ped = new PortEventData(this, center, event);
        var ce = new CustomEvent('finishPipe', detail: ped);
        this._div.dispatchEvent(ce);
    }

    /// Return the center point (in pixels) of this port.
    Point _getCenter() {
        var portRect = this._div.getBoundingClientRect();
        var center = new Point(
            portRect.left + (portRect.width  / 2),
            portRect.top  + (portRect.height / 2)
        );
        return center;
    }
}

/// Represents an output port on a gadget.
///
/// Duplicates a lot of logic in InputPort, which could probably be refactored.
class OutputPort extends BaseComponent {
    /// A stream that input ports may subscribe to receive data from this output
    /// port.
    Stream<List<int>> stream;

    /// Contains the last message sent through this port.
    List<int> _lastMessage;

    /// The div element depicting this port.
    DivElement _div;

    /// Controls the data stream for this port.
    StreamController<List<int>> _controller;

    /// Subscription to mouse down events on this port.
    StreamSubscription<MouseEvent> _mouseDownEvents;

    /// Subscription to mouse up events on this port.
    StreamSubscription<MouseEvent> _mouseUpEvents;

    /// The port number; currently used only for positioning the port on the
    /// parent element.
    int _portNum;

    /// Constructor.
    OutputPort(this._portNum) {
        this._controller = new StreamController<List<int>>.broadcast();
        this._controller.onListen = () {
            // Resend last message to new listeners.
            if (this._lastMessage != null) {
                this._controller.add(this._lastMessage);
            }
        };
        this.stream = this._controller.stream;
    }

    /// Mount this port to the DOM.
    void mount(Element parent) {
        this._div = $div()..className = 'output-port port${_portNum}';
        this._mouseDownEvents = this._div.onMouseDown.listen(this._onMouseDown);
        this._mouseUpEvents = this._div.onMouseUp.listen(this._onMouseUp);
        parent.append(this._div);
    }

    /// Send data out of this port.
    void send(List<int> data) {
        this._lastMessage = data;
        this._controller.add(data);
    }

    /// Called when the component is destroyed.
    void unmount() {
        /// Clean up events.
        this._controller.close();
        this._mouseDownEvents.cancel();
        this._mouseDownEvents = null;
        this._mouseUpEvents.cancel();
        this._mouseUpEvents = null;

        /// Clean up DOM.
        this._div.remove();
        super.unmount();
    }

    /// Handles mouse down events on this port by emitting a mouseDownOnPort
    /// event.
    void _onMouseDown(MouseEvent event) {
        if (event.button != 0) {
            return;
        }
        event.stopPropagation();
        var center = this._getCenter();
        var ped = new PortEventData(this, center, event);
        var ce = new CustomEvent('startPipe', detail: ped);
        this._div.dispatchEvent(ce);
    }

    /// Handles mouse up events on this port by emitting a mouseUpOnPort
    /// event.
    void _onMouseUp(MouseEvent event) {
        event.stopPropagation();
        var center = this._getCenter();
        var ped = new PortEventData(this, center, event);
        var ce = new CustomEvent('finishPipe', detail: ped);
        this._div.dispatchEvent(ce);
    }

    /// Return the center point (in pixels) of this port.
    Point _getCenter() {
        var portRect = this._div.getBoundingClientRect();
        var center = new Point(
            portRect.left + (portRect.width  / 2),
            portRect.top  + (portRect.height / 2)
        );
        return center;
    }
}
