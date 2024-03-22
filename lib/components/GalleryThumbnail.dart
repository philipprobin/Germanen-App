import 'package:flutter/material.dart';
import 'package:germanenapp/models/galleryItemModel.dart';

class GalleryItemThumbnail extends StatelessWidget {
  final GalleryItemModel galleryItemModel;
  final GestureTapCallback onTap;

  const GalleryItemThumbnail({Key? key, required this.galleryItemModel, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryItemModel.id,
          child: Image.network(
            galleryItemModel.id,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 128.0),
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),//Image.asset(galleryItemModel.id, fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
