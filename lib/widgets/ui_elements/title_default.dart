import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String productName;

  const TitleDefault(this.productName);

  @override
  Widget build(BuildContext context) {
    return Text(
      productName,
      style: TextStyle(
          fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
    );
  }
}
