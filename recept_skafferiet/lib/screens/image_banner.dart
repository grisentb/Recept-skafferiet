import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String _assetPath; // underscore means private
  final double _height;

  ImageBanner(this._assetPath, this._height);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(height: _height),
        decoration: BoxDecoration(color: Colors.grey),
        child: Image.network(
          _assetPath,
          fit: BoxFit.cover,
        ));
  }
}
