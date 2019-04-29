import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import '../helpers/ensure_visible.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController =
      new TextEditingController();

  Uri _staticManUri;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) {
      return;
    }
    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyA4YHhJUn3UNsoQ6ml4g_WK59sGms5DZ7A'});
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);



    final String formattedAddress =
        decodedResponse['results'][0]['formatted_address'];
    print(formattedAddress);
    final double lat = decodedResponse['results'][0]['geometry']['location']['lat'];
    print(lat);
    final double lng = decodedResponse['results'][0]['geometry']['location']['lng'];
    print(lng);

    final StaticMapProvider staticMapProvider =
        StaticMapProvider('AIzaSyA4YHhJUn3UNsoQ6ml4g_WK59sGms5DZ7A');
    final Uri mapUrl = staticMapProvider.getStaticUriWithMarkers(
        [Marker('Position', 'Position', lat, lng)],
        width: 500,
        height: 300,
        center: Location(lat, lng),
        maptype: StaticMapViewType.roadmap);
    setState(() {
      _addressInputController.text = formattedAddress;
      _staticManUri = mapUrl;
    });
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ),
        SizedBox(height: 10.0),
        Image.network(_staticManUri.toString())
      ],
    );
  }
}
