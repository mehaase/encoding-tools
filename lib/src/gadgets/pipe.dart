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

    /// The pipe's start and end points in grid coordinates.
    math.Point _start, _end;

    /// Constructor.
    Pipe() {
        this._path = $path()
            ..id = 'pipe';

        this._root = $svg()
            ..classes.add('pipe')
            ..attributes['width'] = '60px'
            ..attributes['height'] = '40px'
            ..append(this._path);
    }

    /// Move the pipe's start and end point to the given grid coordinates.
    ///
    /// Note that the pipe is placed in the _middle_ of the given grid cell, not
    /// in the top left corner.
    void moveToGrid(math.Point start, math.Point end) {
        this._start = start;
        this._end = end;
        this._updateRect();
    }

    /// Move the pipe's start point to the given grid coordinates.
    ///
    /// Note that the pipe is placed in the _middle_ of the given grid cell, not
    /// in the top left corner.
    void moveStartToGrid(math.Point start) {
        this._start = start;
        this._updateRect();
    }

    /// Move the pipe's end point to the given grid coordinates.
    ///
    /// Note that the pipe is placed in the _middle_ of the given grid cell, not
    /// in the top left corner.
    void moveEndToGrid(math.Point end) {
        this._end = end;
        this._updateRect();
    }

    /// Mount this pipe to the DOM.
    void mount(html.Element parent) {
        parent.append(this._root);
    }

    /// Remove from the DOM.
    void unmount() {
        this._root.remove();
    }

    /// Set SVG bounding box based on start and end points.
    void _updateRect() {
        var rect = new math.Rectangle.fromPoints(this._start, this._end);

        var top =  rect.top * GRID_SIZE;
        var left = rect.left * GRID_SIZE;
        var width =  (rect.width + 1) * GRID_SIZE;
        var height =  (rect.height + 1) * GRID_SIZE;

        this._root
            ..attributes['width'] = '${width}px'
            ..attributes['height'] = '${height}px'
            ..style.top = '${top}px'
            ..style.left = '${left}px';

        var x1 = ((this._start.x - rect.left) * GRID_SIZE) + (GRID_SIZE / 2);
        var y1 = ((this._start.y - rect.top)  * GRID_SIZE) + (GRID_SIZE / 2);
        var x2 = ((this._end.x   - rect.left) * GRID_SIZE) + (GRID_SIZE / 2);
        var y2 = ((this._end.y   - rect.top)  * GRID_SIZE) + (GRID_SIZE / 2);
        this._path.attributes['d'] = 'M${x1},${y1} L${x2},${y2}';
    }
}
