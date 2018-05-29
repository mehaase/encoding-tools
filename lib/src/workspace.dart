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
import 'gadgets/pipe.dart';
import 'gadgets/port.dart';
import 'gadgets/factory.dart';

/// A view container for gadgets..
class Workspace extends BaseComponent {
    /// The div container for the workspace.
    Element _root;

    /// Represents a pipe that is currently being created, or null if no pipe is
    /// being created.
    Pipe _newPipe;

    /// When a pipe is being created, this points to the port where the pipe
    /// begins, or null if no pipe is being created. It's either an `InputPort`
    /// or an `OutputPort`.
    dynamic _newPipePort;

    /// Keep track of all gadgets in the workspace.
    List<BaseGadget> _gadgets;

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

    /// Subscription to drag-over events in the workspace.
    StreamSubscription<MouseEvent> _dragOverSubscription;

    /// Subscription to [drag and] drop events in the workspace.
    StreamSubscription<MouseEvent> _dropSubscription;

    /// Constructor.
    Workspace() {
        this._gadgets = [];
        this._pipes = [];
    }

    /// Create and mount the workspace component.
    void mount(Element parent) {
        this._root = $div()..id = 'workspace';

        var inputGadget = gadgetFactory('input');
        inputGadget.moveToGrid(new Point(1, 1));
        inputGadget.mount(this._root);
        this._gadgets.add(inputGadget);

        this._startPipeSubscription = this._root.on['startPipe'].listen(
            this._onStartPipe);
        this._finishPipeSubscription = this._root.on['finishPipe'].listen(
            this._onFinishPipe);
        this._mouseUpSubscription = this._root.onMouseUp.listen(this._onMouseUp);
        this._removePipeSubscription = this._root.on['removePipe'].listen(
            this._removePipe);
        this._removeGadgetSubscription = this._root.on['removeGadget'].listen(
            this._removeGadget);
        this._dragOverSubscription = this._root.onDragOver.listen(
            this._onDragOver);
        this._dropSubscription = this._root.onDrop.listen(
            this._onDrop);

        parent.append(this._root);
    }

    /// Remove the workspace from the DOM.
    void unmount() {
        this._startPipeSubscription.cancel();
        this._startPipeSubscription = null;
        this._finishPipeSubscription.cancel();
        this._finishPipeSubscription = null;
        this._removePipeSubscription.cancel();
        this._removePipeSubscription = null;
        this._dragOverSubscription.cancel();
        this._dragOverSubscription = null;
        this._dropSubscription.cancel();
        this._dropSubscription = null;
        this._root.remove();
        super.unmount();
    }

    /// Handle a start-pipe event on a port.
    void _onStartPipe(Event event) {
        event.stopPropagation();
        var portEventData = (event as CustomEvent).detail;
        var workspaceRect = this._root.offset;
        var endpoint = portEventData.port.getCenter() - workspaceRect.topLeft;
        this._newPipe = new Pipe(endpoint, endpoint)..mount(this._root);
        this._newPipePort = portEventData.port;
        if (this._newPipePort is InputPort) {
            this._root.classes.add('highlight-output-ports');
        } else if (this._newPipePort is OutputPort) {
            this._root.classes.add('highlight-available-input-ports');
        }
        this._mouseMoveSubscription = this._root.onMouseMove.listen((mouseEvent) {
            this._newPipe.moveEndTo(mouseEvent.page - workspaceRect.topLeft);
        });
    }

    /// Handle a finish-pipe event on a port.
    void _onFinishPipe(Event event) {
        /// Cleanup pipe-creation state.
        event.stopPropagation();
        var portEventData = (event as CustomEvent).detail;
        var workspaceRect = this._root.offset;
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
            try {
                this._newPipe.connect(start, end);
            } catch (RangeError) {
                window.alert('You\'ve created a circular flow of data which has'
                    ' caused the universe to collapse into itself and create a'
                    ' blackhole so massive that even light cannot escape it.'
                    ' \n\nOk not really, but you did fuck up this program and'
                    ' I\'m gonna have to reload the page.');
                window.location.reload();
            }
            this._newPipe.moveEndTo(endpoint);
            this._pipes.add(this._newPipe);
        } else {
            this._newPipe.unmount();
        }

        this._newPipe = null;
        this._newPipePort = null;
        this._mouseMoveSubscription.cancel();
        this._mouseMoveSubscription = null;
        this._root.classes.remove('highlight-output-ports');
        this._root.classes.remove('highlight-available-input-ports');
    }

    /// Handle drag-over events in the workspace.
    ///
    /// This is used to drag gadgets from the drawer and drop them onto the
    /// workspace.
    void _onDragOver(MouseEvent event) {
        event.preventDefault();
        event.dataTransfer.dropEffect = 'copy';
    }

    /// Handle [drag and] drop events in the workspace.
    ///
    /// This is used to drag gadgets from the drawer and drop them onto the
    /// workspace.
    void _onDrop(MouseEvent event) {
        var data = event.dataTransfer
                        .getData('application/vnd.strtools-gadget')
                        .split(';');
        event.preventDefault();
        var type = data[0];
        var mouseOffset = new Point(int.parse(data[1]), int.parse(data[2]));
        var client = this._root.getBoundingClientRect();
        var location = event.page - client.topLeft - mouseOffset;
        var gadget = gadgetFactory(type);
        gadget.moveToPixel(location, snap: true);
        gadget.mount(this._root);
        this._gadgets.add(gadget);
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
        this._root.classes.remove('highlight-output-ports');
        this._root.classes.remove('highlight-available-input-ports');
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
        this._gadgets.remove(gadget);
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
