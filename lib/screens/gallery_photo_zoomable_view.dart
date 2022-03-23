import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/components/GalleryPhotoWrapper.dart';
import 'package:germanenapp/components/GalleryThumbnail.dart';
import 'package:germanenapp/models/galleryItemModel.dart';

class GalleryPhotoZoomableView extends StatefulWidget {
  final List<dynamic> images;

  const GalleryPhotoZoomableView({
    required this.images,
  });

  @override
  _GalleryPhotoZoomableViewState createState() =>
      _GalleryPhotoZoomableViewState();
}

class _GalleryPhotoZoomableViewState extends State<GalleryPhotoZoomableView> {
  bool verticalGallery = false;

  late List<String> itemList = widget.images.map((e) => e as String).toList();

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: itemList
                .map(
                  (e) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        GalleryItemThumbnail(
                          galleryItemModel: GalleryItemModel(id: e),
                          onTap: () {
                            _open(context, current);
                          },
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
                enableInfiniteScroll: false,
                viewportFraction: 1.0,
                //enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                }),
          ),
          itemList.length == 1
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.images.map((e) {
                    int index = widget.images.indexOf(e);
                    return Container(
                      width: 6,
                      height: 6,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList()),
        ],
      ),
    );
  }

  void _open(BuildContext context, final int index) {
    //cast stringlist to GalleryItemModelList
    List<GalleryItemModel> galleries = [];
    itemList.map((element) {
      galleries.add(GalleryItemModel(id: element));
    });
    debugPrint('galleries $galleries');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoWrapper(
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            initialIndex: index,
            galleries: itemList,
            scrollDirection: Axis.horizontal),
      ),
    );
  }
}
/*
CarouselSlider(
          items: galleries
              .map(
                (item) => Container(
                  padding: EdgeInsets.all(2),
                  color: Colors.grey[800],
                  child: GalleryItemThumbnail(
                    galleryItemModel: item,
                    onTap: () {
                      _open(context, 0);
                    },
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  current = index;
                });
              }),
        ),
 */
