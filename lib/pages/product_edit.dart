import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Product product;
  final int productIndex;

  const ProductEditPage(
      {this.product, this.updateProduct, this.addProduct, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPage();
  }
}

class _ProductEditPage extends State<ProductEditPage> {
  final Map<String, dynamic> _formDate = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/bee.jpg'
  };

  final GlobalKey<FormState> editForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Widget pageContent = _buildPageContent();
    return widget.product == null
        ? pageContent
        : Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
      ),
      body: pageContent,
    );
  }

  Widget _buildPageContent() {
    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = (deviceWidth - targetWidth) / 2;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: targetPadding),
            child: Form(
                key: editForm,
                child: ListView(children: <Widget>[
                  _buildTitleTextFormField(),
                  _buildDescriptionTextFormField(),
                  _buildPriceTextFormField(),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    color: Theme
                        .of(context)
                        .accentColor,
                    textColor: Colors.white,
                    child: Text("Save"),
                    onPressed: () {
                      _submitForm(context);
                    },
                  )
                ]))));
  }

  void _submitForm(BuildContext context) {
    if (!editForm.currentState.validate()) {
      return;
    }
    editForm.currentState.save();

    if (widget.product == null) {
      widget.addProduct(Product(
          title: _formDate['title'],
          description: _formDate['description'],
          price: _formDate['price'],
          image: _formDate['image']
      ));
    } else {
      widget.updateProduct(widget.productIndex, Product(
          title: _formDate['title'],
          description: _formDate['description'],
          price: _formDate['price'],
          image: _formDate['image']));
      }
          Navigator.pushReplacementNamed(context, '/products');
    }

  TextFormField _buildPriceTextFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Price',
      ),
      initialValue:
      widget.product == null ? '' : widget.product.price.toString(),
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
      initialValue: widget.product == null
          ? ''
          : widget.product.description,
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
      initialValue:
      widget.product == null ? '' : widget.product.title,
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
