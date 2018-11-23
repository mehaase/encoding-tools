/* Encoding Tools
 * Copyright (C) 2018 Mark E. Haase <mehaase@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:convert';
import 'dart:html';

import 'gadgets/base_gadget.dart';
import 'gadgets/factory.dart';
import 'gadgets/pipe.dart';

/// An assembly is a collection of components with connections and layout that
/// can be deployed into a space. Assemblies are serialized to JSON.
class Assembly {
    /// The assembly name.
    String get name => this._name;

    /// A read-only list of gadgets in this assembly.
    List<BaseGadget> get gadgets => new List.unmodifiable(this._gadgets);

    /// A read-only list of pipes in this assembly.
    List<Pipe> get pipes => new List.unmodifiable(this._pipes);

    String _name;
    List<BaseGadget> _gadgets;
    List<Pipe> _pipes;

    /// Load an assembly from a JSON map, i.e. a JSON string that has been
    /// decoded into an object.
    Assembly.fromJson(Map json) {
        this._name = json['name'];
        this._gadgets = [];
        this._pipes = [];
        // This map is used to temporarily match serialized gadget IDs to
        // in-memory gadget instances.
        Map gadgets = {};

        for (var gadgetJson in json['gadgets']) {
            var id = gadgetJson['id'];
            var gadget = gadgetFactory(gadgetJson['type']);
            gadgets[id] = gadget;
            var x = gadgetJson['x'] as num;
            var y = gadgetJson['y'] as num;
            gadget.moveToGrid(new Point(x, y));
            this._gadgets.add(gadget);
        }

        for (var pipeJson in json['pipes']) {
            var sourceGadget = gadgets[pipeJson['source']['id']];
            var destGadget = gadgets[pipeJson['dest']['id']];
            var sourcePort = sourceGadget.outputs[pipeJson['source']['portNum']];
            var destPort = destGadget.inputs[pipeJson['dest']['portNum']];
            // Create a dummy coordinate for the pipe's initial position. This
            // will get updated automatically when it is connected to the ports.
            var point = new Point(0, 0);
            var pipe = new Pipe(point, point);
            pipe.connect(sourcePort, destPort);
            this._pipes.add(pipe);
        }
    }
}

/// Load one of the named static assemblies. These are defined in the
/// STATIC_ASSEMBLIES constant below.
Assembly loadStaticAssembly(String name) {
    if (STATIC_ASSEMBLIES.containsKey(name)) {
        return new Assembly.fromJson(STATIC_ASSEMBLIES[name]);
    } else {
        throw new AssemblyNotFound(name);
    }
}

/// This exception is thrown if no assembly matches the given name.
class AssemblyNotFound implements Exception {
    String name;
    AssemblyNotFound(this.name);
}

/// A listing of static assemblies written in the same format that serialized
/// JSON assemblies will decode to.
final Map STATIC_ASSEMBLIES = {
    'base64-encoder': {
        // The name is displayed in the UI.
        'name': 'Base64 Encoder',
        // Each gadget has a unique ID number when serialized.
        'gadgets': [
            {
                'id': 0,
                'type': 'input', // Must match gadget factory.
                'x': 1, // Coordinates on workspace grid.
                'y': 1,
            },
            {
                'id': 1,
                'type': 'base64-encoder',
                'x': 1,
                'y': 10,
            },
        ],
        // Pipes refer to gadgets by ID.
        'pipes': [
            {
                'source': {'id': 0, 'portNum': 0},
                'dest':   {'id': 1, 'portNum': 0},
            },
        ],
    },
    'base64-decoder': {
        'name': 'Base64 Decoder',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'base64-decoder', 'x': 1, 'y': 10},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
        ],
    },
    'hex-encoder': {
        'name': 'Hex Encoder',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'hex-encoder', 'x': 1, 'y': 10},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
        ],
    },
    'hex-decoder': {
        'name': 'Hex Decoder',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'hex-decoder', 'x': 1, 'y': 10},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
        ],
    },
    'html-encoder': {
        'name': 'HTML Encoder',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'html-encoder', 'x': 1, 'y': 10},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
        ],
    },
    'html-decoder': {
        'name': 'HTML Decoder',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'html-decoder', 'x': 1, 'y': 10},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
        ],
    },
    'md5-hash': {
        'name': 'MD5 Hash',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'md5', 'x': 1, 'y': 17},
            {'id': 2, 'type': 'input', 'x': 18, 'y': 1},
            {'id': 3, 'type': 'hex-decoder', 'x': 18, 'y': 10},
            {'id': 4, 'type': 'md5', 'x': 18, 'y': 17},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
            {'source': {'id': 2, 'portNum': 0}, 'dest':   {'id': 3, 'portNum': 0}},
            {'source': {'id': 3, 'portNum': 0}, 'dest':   {'id': 4, 'portNum': 0}},
        ],
    },
    'sha1-hash': {
        'name': 'SHA-1 Hash',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'sha1', 'x': 1, 'y': 17},
            {'id': 2, 'type': 'input', 'x': 18, 'y': 1},
            {'id': 3, 'type': 'hex-decoder', 'x': 18, 'y': 10},
            {'id': 4, 'type': 'sha1', 'x': 19, 'y': 17},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
            {'source': {'id': 2, 'portNum': 0}, 'dest':   {'id': 3, 'portNum': 0}},
            {'source': {'id': 3, 'portNum': 0}, 'dest':   {'id': 4, 'portNum': 0}},
        ],
    },
    'sha2-hash': {
        'name': 'SHA-2 Hash',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'sha2', 'x': 1, 'y': 21},
            {'id': 2, 'type': 'input', 'x': 18, 'y': 1},
            {'id': 3, 'type': 'hex-decoder', 'x': 18, 'y': 9},
            {'id': 4, 'type': 'sha2', 'x': 18, 'y': 15},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
            {'source': {'id': 2, 'portNum': 0}, 'dest':   {'id': 3, 'portNum': 0}},
            {'source': {'id': 3, 'portNum': 0}, 'dest':   {'id': 4, 'portNum': 0}},
        ],
    },
    'url-encoder': {
        'name': 'URL Encoder',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'url-encoder', 'x': 1, 'y': 10},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
        ],
    },
    'url-decoder': {
        'name': 'URL Decoder',
        'gadgets': [
            {'id': 0, 'type': 'input', 'x': 1, 'y': 1},
            {'id': 1, 'type': 'url-decoder', 'x': 1, 'y': 10},
        ],
        'pipes': [
            {'source': {'id': 0, 'portNum': 0}, 'dest':   {'id': 1, 'portNum': 0}},
        ],
    },
};
