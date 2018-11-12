import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../helper/ensure-visible.dart';
import '../../model/location_data.dart';
import '../../model/productinfo.dart';
import 'package:location/location.dart' as geoloc;

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final ProductInfo productInfo;

  LocationInput(this.setLocation, this.productInfo);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  LocationData _locationData;
  Uri _staticuri;
  final FocusNode _inputFormTextField = FocusNode();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    _inputFormTextField.addListener(_updateLocation);
    if (widget.productInfo != null) {
      _getStaticMap(widget.productInfo.location.address, geocode: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _inputFormTextField.removeListener(_updateLocation);
    super.dispose();
  }

  void _getStaticMap(String address,
      {bool geocode = true, double lat, double lng}) async {
    if (address.isEmpty) {
      setState(() {
        _staticuri = null;
      });
      widget.setLocation(null);
      return;
    }
    if (geocode) {
      final Uri uri = Uri.https(
        'maps.google.com',
        '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyAeHEf-EYT6L7vGrr13rHyYgYbloB3BTzk'},
      );
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      final formattedAddress =
          decodedResponse['results'][0]['formatted_address'];
      final coords = decodedResponse['results'][0]['geometry']['location'];
      _locationData = LocationData(
          address: formattedAddress,
          latitude: coords['lat'],
          longitude: coords['lng']);
    } else if (lat == null && lng == null) {
      _locationData = widget.productInfo.location;
    } else {
      _locationData =
          LocationData(address: address, latitude: lat, longitude: lng);
    }
    if (mounted) {
      final StaticMapProvider mapProvider =
          StaticMapProvider('AIzaSyAeHEf-EYT6L7vGrr13rHyYgYbloB3BTzk');
      final Uri staticMapUri = mapProvider.getStaticUriWithMarkers([
        Marker('position', 'position', _locationData.latitude,
            _locationData.longitude)
      ],
          center: Location(_locationData.latitude, _locationData.longitude),
          maptype: StaticMapViewType.roadmap,
          height: 300,
          width: 500);
      widget.setLocation(_locationData);

      setState(() {
        _addressController.text = _locationData.address;
        _staticuri = staticMapUri;
      });
    }
  }

  Future<String> _getAddress(double lat, double lng) async {
    final uri = Uri.https(
      'maps.google.com',
      '/maps/api/geocode/json',
      {
        'latlng': '${lat.toString()},${lng.toString()}',
        'key': 'AIzaSyAeHEf-EYT6L7vGrr13rHyYgYbloB3BTzk'
      },
    );
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formatedAddress = decodedResponse['results'][0]['formatted_address'];
    return formatedAddress;
  }

  void _getUserLocation() async {
    final locations = geoloc.Location();
    final currentLocations = await locations.getLocation();
    final address = await _getAddress(
        currentLocations['latitude'], currentLocations['longitude']);
    _getStaticMap(address,
        geocode: false,
        lat: currentLocations['latitude'],
        lng: currentLocations['longitude']);
  }

  void _updateLocation() {
    if (!_inputFormTextField.hasFocus) {
      _getStaticMap(_addressController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _inputFormTextField,
          child: TextFormField(
            focusNode: _inputFormTextField,
            controller: _addressController,
            validator: (String value) {
              if (_locationData == null || value.isEmpty) {
                return 'No Valid Address Found.';
              }
            },
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ),
        SizedBox(height: 10.0),
        FlatButton(
          child: Text('Locate My Address'),
          onPressed: _getUserLocation,
        ),
        SizedBox(height: 10.0),
        _staticuri == null ? Container() : Image.network(_staticuri.toString()),
      ],
    );
  }
}
