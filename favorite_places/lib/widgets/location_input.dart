import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onPickLocation});
  final Function(PlaceLocation location) onPickLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;
  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${_pickedLocation!.latitude},${_pickedLocation!.longitude}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C${_pickedLocation!.latitude},${_pickedLocation!.longitude}&key=AIzaSyCbUIlfCPfcQi_rVuZrm7IShg8CVYrhY0s';
  }

  Future<void> _saveLocation(double lat, double lng, String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCbUIlfCPfcQi_rVuZrm7IShg8CVYrhY0s');
    final response = await http.get(url);

    final responseData = json.decode(response.body);
    final address = responseData['results'][0]['formatted_address'];
    print(address);
    setState(() {
      _isGettingLocation = false;

      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      widget.onPickLocation(_pickedLocation!);
    });
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }
    _saveLocation(locationData.latitude!, locationData.longitude!, '');
  }

  void _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _saveLocation(selectedLocation.latitude, selectedLocation.longitude, '');
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
    );
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text("Get Current Location"),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: const Text("Select on Map"),
              icon: const Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}
