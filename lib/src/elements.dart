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
import 'dart:svg';

// Shortcuts for creating HTML elements.
Function $a = () => new Element.tag('a');
Function $em = () => new Element.tag('em');
Function $i = () => new Element.tag('i');
Function $div = () => new Element.tag('div');
Function $nav = () => new Element.tag('nav');
Function $pre = () => new Element.tag('pre');
Function $span = () => new Element.tag('span');
Function $textarea = () => new Element.tag('textarea');

// Shortcuts for creating SVG elements.
Function $path = () => new SvgElement.tag('path');
Function $svg = () => new SvgElement.tag('svg');
