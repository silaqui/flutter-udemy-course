import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped-models/main.dart';
import 'package:flutter_app/widgets/address_tag_widgt.dart';
import 'package:flutter_app/widgets/price_tag_widget.dart';
import 'package:flutter_app/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product _product;

  const ProductCard(this._product);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Column(children: <Widget>[
        Hero(
          tag: _product.id,
          child: FadeInImage(
            image: NetworkImage(
              _product.image,
            ),
            placeholder: AssetImage('assets/grass.jpg'),
            height: 200.0,
            fit: BoxFit.cover,
          ),
        ),
        _buildTitlePriceRow(),
        AddressTag(_product.location.address),
      ]),
      _buildActionButtons(context)
    ]));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.info,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    model.selectProduct(_product.id);
                    Navigator.pushNamed<bool>(context,
                        '/products/' + _product.id)
                        .then((_) => {
                          model.selectProduct(null)
                        });
                  }),
              IconButton(
                color: Colors.red,
                icon: Icon(_product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.selectProduct(_product.id);
                  model.toggleProductFavoriteStatus();
                },
              ),
            ]);
      },
    );
  }

  Row _buildTitlePriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(child: TitleDefault(_product.title)),
        PriceTag(_product.price.toString())
      ],
    );
  }
}
