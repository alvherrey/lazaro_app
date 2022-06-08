import 'dart:io';

import 'package:flutter/material.dart';

class KnownFaceImage extends StatelessWidget {
  final String? url;
  const KnownFaceImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: _buildBoxDecoration(),
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: getImage(url),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 7),
            ),
          ]);

  Widget getImage(String? picture) {
    if (picture == null) {
      return const Image(
        image: AssetImage('assets/no-image-3.jpg'),
        fit: BoxFit.cover,
      );
    } else if (picture.startsWith('http')) {
      return FadeInImage(
        image: NetworkImage(url!),
        fit: BoxFit.cover,
        placeholder: const AssetImage('assets/jar-loading.gif'),
      );
    } else {
      return Image.file(
        File(picture),
        fit: BoxFit.cover,
      );
    }
  }
}
