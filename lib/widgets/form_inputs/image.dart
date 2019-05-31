import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Product product;

  const ImageInput(this.setImage, this.product);

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Pick an Image",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text("Use Camera"),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text("Use Galery"),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).accentColor;

    Widget previewImage = Text('Please pick image');
    if (_imageFile != null) {
      previewImage = Image.file(_imageFile,
          fit: BoxFit.cover,
          height: 300.0,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topCenter);
    } else if (widget.product != null) {
      previewImage = Image.network(widget.product.image,
          fit: BoxFit.cover,
          height: 300.0,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topCenter);
    }

    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(color: buttonColor, width: 2.0),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt, color: buttonColor),
              SizedBox(width: 5.0),
              Text(
                'Add Image',
                style: TextStyle(color: buttonColor),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0),
        previewImage
//            == null
//            ? Text('Please pick image')
//            : Image.file(
//                _imageFile,
//                fit: BoxFit.cover,
//                height: 300.0,
//                width: MediaQuery.of(context).size.width,
//                alignment: Alignment.topCenter,
//              ),
      ],
    );
  }
}
