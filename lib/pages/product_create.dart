import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  const ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePage();
  }
}

class _ProductCreatePage extends State<ProductCreatePage> {
  String _title = '';
  String _description = '';
  double _price;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = (deviceWidth - targetWidth)/2;
    return Container(
      width: targetWidth,
        padding: EdgeInsets.symmetric(horizontal: targetPadding),
        child: ListView(children: <Widget>[
          _buildTitleTextField(),
          _buildDescriptionTextField(),
          _buildPriceTextField(),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text("Save"),
            onPressed: () {
              _submitForm(context);
            },
          )
        ]));
  }

  void _submitForm(BuildContext context) {
    final Map<String, dynamic> product = {
      'title': _title,
      'description': _description,
      'price': _price,
      'image': 'assets/bee.jpg'
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/products');
  }

  TextField _buildPriceTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Price',
      ),
      onChanged: (String value) {
        setState(() {
          _price = double.parse(value);
        });
      },
    );
  }

  TextField _buildDescriptionTextField() {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Description',
      ),
      onChanged: (String value) {
        setState(() {
          _description = value;
        });
      },
    );
  }

  TextField _buildTitleTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Title',
      ),
      onChanged: (String value) {
        setState(() {
          _title = value;
        });
      },
    );
  }
}
