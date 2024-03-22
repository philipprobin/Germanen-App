import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoWrapper extends StatefulWidget {
  //final LoadingBuilder loadingBuilder;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleries;
  final Axis scrollDirection;

  GalleryPhotoWrapper({
    Key? key,
    //required this.loadingBuilder,
    required this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.initialIndex,
    required this.galleries,
    required this.scrollDirection,
  }) : pageController = PageController(initialPage: initialIndex);

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoWrapper();
  }
}

class _GalleryPhotoWrapper extends State<GalleryPhotoWrapper> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints:
            BoxConstraints.expand(height: MediaQuery.of(context).size.height),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            PhotoViewGallery.builder(
              itemCount: widget.galleries.length,
              builder: _buildItem,
              scrollPhysics: const BouncingScrollPhysics(),
              //loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            /*Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: _downloadImage,
                child: Icon(Icons.file_download),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.galleries[index];
    return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(item),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.contained * 1.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item),
          );
  }
}
