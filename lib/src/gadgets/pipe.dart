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

import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:svg' as svg;

import '../base_component.dart';
import '../elements.dart';
import 'base_gadget.dart' show GRID_SIZE;

/// A visual representation of a pipe between gadgets.
class Pipe extends BaseComponent {
    /// The SVG container.
    svg.SvgElement _root;

    /// The line.
    svg.PathElement _path;

    /// The pipe's endpoints in pixel coordinates.
    math.Point _start, _end;

    /// Constructor.
    Pipe(this._start, this._end) {
        this._path = $path()
            ..id = 'pipe';

        this._root = $svg()
            ..classes.add('pipe')
            ..append(this._path)
            ..onContextMenu.listen((event) {
                event.preventDefault();
                var ce = new html.CustomEvent('removePipe', detail: this);
                this._root.dispatchEvent(ce);
            });
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

    /// Remove from the DOM.
    void unmount() {
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
