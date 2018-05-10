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

/// A callback that is invoked when data is received.
typedef void DataReceivedHandler(List<int> data);


/// Encapsulates information about a user interaction with a port.
class PortEventData {
    dynamic port;
    Event event;
    PortEventData(this.port, this.event);
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

    /// The pipe connected to this port, if any.
    Pipe _pipe;

    /// Constructor
    InputPort(this._portNum, this._handler);

    /// Connect this input to the specified output port.
    void connect(Pipe pipe, OutputPort out) {
        if (this._subscription != null) {
            throw new Exception(
                'Cannot connect input port; it is already connected');
        }
        this._pipe = pipe;
        this._subscription = out.connect(pipe, this._handler);
        /// If the output port already has data, then send it to the handler.
        if (out.lastMessage != null) {
            this._handler(out.lastMessage);
        }
        this._div.classes.add('connected');
    }

    /// Disconnect this input from its currently attached output port.
    void disconnect () {
        if (this._subscription == null) {
            throw new Exception(
                'Cannot disconnect input port; it is not connected to anything');
        }
        this._handler(null);
        this._subscription.cancel();
        this._subscription = null;
        this._div.classes.remove('connected');
    }

    /// Return the center point (in pixels) of this port.
    Point getCenter() {
        var portRect = this._div.getBoundingClientRect();
        var center = new Point(
            portRect.left + (portRect.width  / 2),
            portRect.top  + (portRect.height / 2)
        );
        return center;
    }

    /// Move pipe start point to match the port's current location.
    void movePipe() {
        this._pipe.moveEndTo(this.getCenter() + new Point(0, -60));
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
        this._pipe = null;

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
        var ped = new PortEventData(this, event);
        var ce = new CustomEvent('startPipe', detail: ped);
        this._div.dispatchEvent(ce);
    }

    /// Handles mouse up events on this port by emitting a mouseUpOnPort
    /// event.
    void _onMouseUp(MouseEvent event) {
        event.stopPropagation();
        var ped = new PortEventData(this, event);
        var ce = new CustomEvent('finishPipe', detail: ped);
        this._div.dispatchEvent(ce);
    }
}

/// Represents an output port on a gadget.
///
/// Duplicates a lot of logic in InputPort, which could probably be refactored.
class OutputPort extends BaseComponent {
    /// Contains the last message sent through this port.
    List<int> get lastMessage => this._lastMessage;
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

    /// Collection of pipes attached to this port.
    List<Pipe> _pipes;

    /// Constructor.
    OutputPort(this._portNum) {
        this._controller = new StreamController<List<int>>.broadcast();
        this._pipes = [];
    }

    /// Connect a handler to this output port.
    ///
    /// This is only meant to be called from InputPort.
    StreamSubscription<List<int>> connect(Pipe pipe, DataReceivedHandler handler) {
        this._pipes.add(pipe);
        return this._controller.stream.listen(handler);
    }

    /// Return the center point (in pixels) of this port.
    Point getCenter() {
        var portRect = this._div.getBoundingClientRect();
        var center = new Point(
            portRect.left + (portRect.width  / 2),
            portRect.top  + (portRect.height / 2)
        );
        return center;
    }

    /// Move pipe start points to match the port's current location.
    void movePipes() {
        this._pipes.forEach((pipe) {
            pipe.moveStartTo(this.getCenter() + new Point(0, -60));
        });
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
        this._pipes.clear();

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
        var ped = new PortEventData(this, event);
        var ce = new CustomEvent('startPipe', detail: ped);
        this._div.dispatchEvent(ce);
    }

    /// Handles mouse up events on this port by emitting a mouseUpOnPort
    /// event.
    void _onMouseUp(MouseEvent event) {
        event.stopPropagation();
        var ped = new PortEventData(this, event);
        var ce = new CustomEvent('finishPipe', detail: ped);
        this._div.dispatchEvent(ce);
    }
}
