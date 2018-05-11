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
import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:svg' as svg;

import '../base_component.dart';
import '../elements.dart';
import 'base_gadget.dart' show GRID_SIZE;
import 'port.dart';

/// A visual representation of a pipe between gadgets.
class Pipe extends BaseComponent {
    /// The output port.
    OutputPort _output;
    OutputPort get output => this._output;

    /// The input port.
    InputPort _input;
    InputPort get input => this._input;

    /// The SVG container.
    svg.SvgElement _root;

    /// The line.
    svg.PathElement _path;

    /// The pipe's endpoints in pixel coordinates.
    math.Point _start, _end;

    /// Subscription to right clicks.
    StreamSubscription<html.MouseEvent> _rightClickEvents;

    /// Constructor.
    Pipe(this._start, this._end) {
        this._path = $path()
            ..id = 'pipe';

        this._root = $svg()
            ..classes.add('pipe')
            ..append(this._path);

        this._rightClickEvents = this._root.onContextMenu.listen((event) {
            event.preventDefault();
            var ce = new html.CustomEvent('removePipe', detail: this);
            this._root.dispatchEvent(ce);
        });
    }

    /// Connect this pipe to the given ports.
    void connect(OutputPort output, InputPort input) {
        this._input = input;
        this._output = output;
        /// Connect input first, because the output port will immediately try
        /// to send whatever data it is currently holding.
        this._input.connect(this);
        this._output.connect(this);
    }

    /// Disconnect from attached ports.
    void disconnect() {
        this._input.disconnect(this);
        this._output.disconnect(this);
        this._input = null;
        this._output = null;
    }

    /// Move the pipe's endpoints to the given pixel coordinates.
    void moveTo(math.Point start, math.Point end) {
        this._start = start;
        this._end = end;
        this._render();
    }

    /// Move the pipe's start point to the given pixel coordinates.
    void moveStartTo(math.Point start) {
        this._start = start;
        this._render();
    }

    /// Move the pipe's end point to the given pixel coordinates.
    void moveEndTo(math.Point end) {
        this._end = end;
        this._render();
    }

    /// Mount this pipe to the DOM.
    void mount(html.Element parent) {
        this._render();
        parent.append(this._root);
    }

    /// Send data through this pipe.
    void send(List<int> data) {
        this.input.send(data);
    }

    /// Override toString()
    String toString() {
        return 'Pipe#${this.hashCode} (out=${this._output} in=${this._input})';
    }

    /// Remove from the DOM.
    void unmount() {
        this._rightClickEvents.cancel();
        this._rightClickEvents = null;
        this._root.remove();
    }

    /// Set SVG bounding box and draw path between endpoints.
    void _render() {
        var boxPadding = 10;
        var rect = new math.Rectangle.fromPoints(this._start, this._end);

        var top =  rect.top - boxPadding;
        var left = rect.left - boxPadding;
        var width =  rect.width + (2 * boxPadding);
        var height =  rect.height + (2 * boxPadding);

        this._root
            ..attributes['width'] = '${width}px'
            ..attributes['height'] = '${height}px'
            ..style.top = '${top}px'
            ..style.left = '${left}px';

        var x1 = this._start.x - left;
        var y1 = this._start.y - top;
        var x2 = this._end.x - left;
        var y2 = this._end.y - top;
        this._path.attributes['d'] = 'M${x1},${y1} L${x2},${y2}';
    }
}
