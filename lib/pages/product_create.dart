import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePage();
  }
}

class _ProductCreatePage extends State<ProductCreatePage> {
  String title = '';
  String description = '';
  double price;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15.0),
        child: ListView(children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            onChanged: (String value) {
              setState(() {
                title = value;
              });
            },
          ),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
            onChanged: (String value) {
              setState(() {
                description = value;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price',
            ),
            onChanged: (String value) {
              setState(() {
                price = double.parse(value);
              });
            },
          ),
          RaisedButton(
            child: Text("Save"),
            onPressed: (){},
          )
        ]));
  }
}
