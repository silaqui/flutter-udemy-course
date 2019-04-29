import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import '../helpers/ensure_visible.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();

  Uri _staticManUri;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    getStaticMap();
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  //async for future use, not required now
  void getStaticMap() async {
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

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
          ),
        ),
        SizedBox(height: 10.0),
        Image.network(_staticManUri.toString())
      ],
    );
  }
}
