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
  final Map<String, dynamic> _formDate = {
    'title':null,
    'description':null,
    'price':null,
    'image': 'assets/bee.jpg'
  };

  String _title = '';
  String _description = '';
  double _price;
  final GlobalKey<FormState> CREATE_FORM = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = (deviceWidth - targetWidth) / 2;
    return GestureDetector(
      onTap:  (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
        child: Container(
            width: targetWidth,
            padding: EdgeInsets.symmetric(horizontal: targetPadding),
            child: Form(
                key: CREATE_FORM,
                child: ListView(children: <Widget>[
                  _buildTitleTextFormField(),
                  _buildDescriptionTextFormField(),
                  _buildPriceTextFormField(),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: Text("Save"),
                    onPressed: () {
                      _submitForm(context);
                    },
                  )
                ]))));
  }

  void _submitForm(BuildContext context) {
    if (!CREATE_FORM.currentState.validate()) {
      return;
    }
    CREATE_FORM.currentState.save();
    widget.addProduct(_formDate);
    Navigator.pushReplacementNamed(context, '/products');
  }

  TextFormField _buildPriceTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Price',
      ),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value))
          return 'Price is required';
      },
      onSaved: (String value) {
        _formDate['price'] = double.parse(value);
      },
    );
  }

  TextFormField _buildDescriptionTextFormField() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Description',
      ),
      validator: (String value) {
        if (value.isEmpty) return 'Description is required';
      },
      onSaved: (String value) {
        _formDate['description'] = value;
      },
    );
  }

  TextFormField _buildTitleTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Title',
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 5)
          return 'Title is required and should have at least 5 characters';
      },
      onSaved: (String value) {
        _formDate['title'] = value;
      },
    );
  }
}
