import "package:flutter/material.dart";

class ProductFab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            height: 70,
            width: 56,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'contact',
              mini: true,
              onPressed: () {},
              child: Icon(Icons.mail, color: Theme.of(context).accentColor,),
            )),
        Container(
          height: 70,
          width: 56,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
            mini: true,
            heroTag: 'favorite',
            onPressed: () {},
            child: Icon(Icons.favorite,color: Theme.of(context).accentColor),
          ),
        ),
        Container(
          height: 70,
          width: 56,
          child: FloatingActionButton(
            heroTag: 'options',
            onPressed: () {},
            child: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}
