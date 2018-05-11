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
import 'gadgets/base_gadget.dart';
import 'gadgets/input.dart';
import 'gadgets/md5.dart';
import 'gadgets/pipe.dart';
import 'gadgets/port.dart';

/// A view container for gadgets..
class Workspace extends BaseComponent {
    /// The div container for the workspace.
    Element root;

    /// Represents a pipe that is currently being created, or null if no pipe is
    /// being created.
    Pipe _newPipe;

    /// When a pipe is being created, this points to the port where the pipe
    /// begins, or null if no pipe is being created. It's either an `InputPort`
    /// or an `OutputPort`.
    dynamic _newPipePort;

    /// Keep track of all pipes in the workspace.
    List<Pipe> _pipes;

    /// Subscription to startPipe events on ports.
    StreamSubscription<Event> _startPipeSubscription;

    /// Subscription to finishPipe events on ports.
    StreamSubscription<Event> _finishPipeSubscription;

    /// Subscription to removePipe events.
    StreamSubscription<Event> _removePipeSubscription;

    /// Subscription to removeGadget events.
    StreamSubscription<Event> _removeGadgetSubscription;

    /// Subscription to mouse-move events in the workspace. Only subscribed to
    /// during pipe creation.
    StreamSubscription<MouseEvent> _mouseMoveSubscription;

    /// Subscription to mouse-up events in the workspace.
    StreamSubscription<MouseEvent> _mouseUpSubscription;

    /// Constructor.
    Workspace() {
        this._pipes = [];
    }

    /// Create and mount the workspace component.
    void mount(Element parent) {
        this.root = parent;
        var inputGadget = new InputGadget();
        inputGadget.moveToGrid(new Point(1, 1));
        inputGadget.mount(parent);

        var md5Gadget1 = new Md5Gadget();
        md5Gadget1.moveToGrid(new Point(3, 9));
        md5Gadget1.mount(parent);

        var md5Gadget2 = new Md5Gadget();
        md5Gadget2.moveToGrid(new Point(1, 15));
        md5Gadget2.mount(parent);

        this._startPipeSubscription = parent.on['startPipe'].listen(
            this._onStartPipe);
        this._finishPipeSubscription = parent.on['finishPipe'].listen(
            this._onFinishPipe);
        this._mouseUpSubscription = parent.onMouseUp.listen(this._onMouseUp);
        this._removePipeSubscription = parent.on['removePipe'].listen(
            this._removePipe);
        this._removeGadgetSubscription = parent.on['removeGadget'].listen(
            this._removeGadget);
    }

    /// Remove the workspace from the DOM.
    void unmount() {
        this._startPipeSubscription.cancel();
        this._startPipeSubscription = null;
        this._finishPipeSubscription.cancel();
        this._finishPipeSubscription = null;
        this._removePipeSubscription.cancel();
        this._removePipeSubscription = null;
        super.unmount();
    }

    /// Handle a start-pipe event on a port.
    void _onStartPipe(Event event) {
        event.stopPropagation();
        var portEventData = (event as CustomEvent).detail;
        var workspaceRect = this.root.offset;
        var endpoint = portEventData.port.getCenter() - workspaceRect.topLeft;
        this._newPipe = new Pipe(endpoint, endpoint)..mount(this.root);
        this._newPipePort = portEventData.port;
        if (this._newPipePort is InputPort) {
            this.root.classes.add('highlight-output-ports');
        } else if (this._newPipePort is OutputPort) {
            this.root.classes.add('highlight-available-input-ports');
        }
        this._mouseMoveSubscription = this.root.onMouseMove.listen((mouseEvent) {
            this._newPipe.moveEndTo(mouseEvent.page - workspaceRect.topLeft);
        });
    }

    /// Handle a finish-pipe event on a port.
    void _onFinishPipe(Event event) {
        /// Cleanup pipe-creation state.
        event.stopPropagation();
        var portEventData = (event as CustomEvent).detail;
        var workspaceRect = this.root.offset;
        var endpoint = portEventData.port.getCenter() - workspaceRect.topLeft;

        /// Make the connection.
        var start = this._newPipePort;
        var end = portEventData.port;
        if (start is InputPort && end is OutputPort) {
            /// Switch the ports so that `start` is an output.
            var temp = start;
            start = end;
            end = temp;
        }

        if (start is OutputPort && end is InputPort) {
            this._newPipe.connect(start, end);
            this._newPipe.moveEndTo(endpoint);
            this._pipes.add(this._newPipe);
        } else {
            this._newPipe.unmount();
        }

        this._newPipe = null;
        this._newPipePort = null;
        this._mouseMoveSubscription.cancel();
        this._mouseMoveSubscription = null;
        this.root.classes.remove('highlight-output-ports');
        this.root.classes.remove('highlight-available-input-ports');
   }

    /// Handle mouse-up events in the workspace.
    ///
    /// If a mouse-up occurs while creating a new pipe, that means the pipe
    /// was not connected to a valid port. Remove the pipe and clean up the
    /// listeners.
    void _onMouseUp(MouseEvent event) {
        this._newPipe?.unmount();
        this._newPipe = null;
        this._newPipePort = null;
        this._mouseMoveSubscription?.cancel();
        this._mouseMoveSubscription = null;
        this.root.classes.remove('highlight-output-ports');
        this.root.classes.remove('highlight-available-input-ports');
    }

    /// Remove a gadget from the workspace.
    ///
    /// Remove any connected pipes.
    void _removeGadget(Event event) {
        var gadget = (event as CustomEvent).detail;
        for (var pipe in gadget.getPipes()) {
            print(pipe);
            pipe.disconnect();
            pipe.unmount();
            this._pipes.remove(pipe);
        }
        gadget.unmount();
    }

    /// Remove a pipe from the workspace.
    ///
    /// Disconnect the pipe from its input ports.
    void _removePipe(Event event) {
        var pipe = (event as CustomEvent).detail;
        pipe.disconnect();
        pipe.unmount();
        this._pipes.remove(pipe);
    }
}
