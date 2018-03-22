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

import 'package:angular/angular.dart';

/// The value service connects value producers to value consumers.
@Injectable()
class ValueService {
    Map<String,Stream<ValueEvent>> _valueProviders;

    /// Constructor.
    ValueService() {
        this._valueProviders = {};
    }

    /// Return a new stream controller for a value provider.
    StreamController<ValueEvent> registerValueProvider(String providerName) {
        if (this._valueProviders.containsKey(providerName)) {
            throw new Exception('Provider $providerName is already registered.');
        }
        var sc = new StreamController<ValueEvent>.broadcast();
        this._valueProviders[providerName] = sc.stream;
        return sc;
    }

    /// Return an event stream for a named value provider.
    Stream<ValueEvent> getValueProviderStream(String providerName) {
        if (!this._valueProviders.containsKey(providerName)) {
            throw new Exception('Provider $providerName does not exist.');
        }
        return this._valueProviders[providerName];
    }
}

/// A container for event data.
class ValueEvent {
    List<int> data;
    ValueEvent(this.data);
}
