import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import '../helpers/ensure_visible.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {

  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = new TextEditingController();

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
    if(address.isEmpty){
      return;}

    final Uri uri = Uri.https('maps.googleapi.com','/maps/api/geocode/json',{
      'address':address,
      'key':'AIzaSyA4YHhJUn3UNsoQ6ml4g_WK59sGms5DZ7A'
    });
    final http.Response reposone = await http.get(uri);

    final StaticMapProvider staticMapProvider =
        StaticMapProvider('AIzaSyA4YHhJUn3UNsoQ6ml4g_WK59sGms5DZ7A');
    final Uri mapUrl = staticMapProvider.getStaticUriWithMarkers(
        [Marker('Position', 'Position', 41.22222, 2.15452)],
        width: 500,
        height: 300,
        center: Location(41.22222, 2.15452),
        maptype: StaticMapViewType.roadmap);
    setState(() {
      _staticManUri = mapUrl;
    });
  }

  void _updateLocation() {
    if(!_addressInputFocusNode.hasFocus){
      getStaticMap(
          _addressInputController.text
      );
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
            decoration: InputDecoration(
              labelText: 'Address'
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Image.network(_staticManUri.toString())
      ],
    );
  }
}
