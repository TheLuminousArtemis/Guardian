import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';

class LocationScreen extends StatefulWidget {
  final void Function(String) onLocationSelected;

  const LocationScreen({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Location'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CSCPicker(
            flagState: CountryFlag.DISABLE,
            layout: Layout.vertical,
            onCountryChanged: (String? country) {
              setState(() {
                selectedCountry = country;
              });
            },
            onStateChanged: (String? state) {
              setState(() {
                selectedState = state;
              });
            },
            onCityChanged: (String? city) {
              setState(() {
                selectedCity = city?.trim().replaceAll(RegExp(r'[^\w\s]+'), ''); // Remove special characters and trim spaces
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Construct the location string without null values
          String location = '';
          if (selectedCity != null && selectedCity!.isNotEmpty) {
            location += '$selectedCity';
          }
          // Pass the location string to the onLocationSelected callback
          widget.onLocationSelected(location);
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
