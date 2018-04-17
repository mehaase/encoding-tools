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
        this.root.style.top = '${top}px';
        this.root.style.left = '${left}px';
    }
}

typedef void DataReceivedHandler(List<int> data);

class InputPort extends BaseComponent {
    /// Indicates whether the port is currently connected.
    bool get connected => this._subscription != null;

    /// The port number; currently used only for positioning the port on the
    /// parent element.
    int _portNum;

    /// A callback that is invoked for every data event.
    DataReceivedHandler _handler;

    /// Subscription to an output port's event stream.
    StreamSubscription<List<int>> _subscription;

    /// Constructor
    InputPort(this._portNum, this._handler);

    /// Connect this input to the specified output port.
    void connect(OutputPort out) {
        if (this._subscription != null) {
            throw new Exception(
                'Cannot connect input port; it is already connected');
        }
        this._subscription = out.stream.listen(this._handler);
    }

    /// Disconnect this input from its currently attached output port.
    void disconnect () {
        if (this._subscription == null) {
            throw new Exception(
                'Cannot disconnect input port; it is not connected to anything');
        }
        this._subscription.cancel();
        this._subscription = null;
    }

    /// Mount this port to the DOM.
    void mount(Element parent) {
        parent.append($div()..className = 'input-port port${_portNum}');
    }

    /// Called when the component is destroyed.
    void unmount() {
        if (this.connected) {
            this.disconnect();
        }
        super.unmount();
    }
}

class OutputPort extends BaseComponent {
    /// A stream that input ports may subscribe to receive data from this output
    /// port.
    Stream<List<int>> stream;

    /// Controls the data stream for this port.
    StreamController<List<int>> _controller;

    /// The port number; currently used only for positioning the port on the
    /// parent element.
    int _portNum;

    /// Constructor.
    OutputPort(this._portNum) {
        this._controller = new StreamController<List<int>>.broadcast();
        this.stream = this._controller.stream;
    }

    /// Mount this port to the DOM.
    void mount(Element parent) {
        parent.append($div()..className = 'output-port port${_portNum}');
    }

    /// Send data out of this port.
    void send(List<int> data) {
        this._controller.add(data);
    }

    /// Called when the component is destroyed.
    void unmount() {
        this._controller.close();
        super.unmount();
    }
}
