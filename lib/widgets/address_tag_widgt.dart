import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String address;

  const AddressTag(this.address);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(address!=null ? address:'Location unknown'),
      );
  }
}