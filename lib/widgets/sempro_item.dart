import 'dart:io';
import 'package:flutter/material.dart';

import '../main.dart';

class SemproItem extends StatefulWidget {
  final String fileName;
  final String size;
  final String date;
  final String url;
  String path;
  bool isDownloaded;
  double progress;
  bool loading;

  SemproItem({
    required this.fileName,
    required this.size,
    required this.date,
    required this.url,
    this.path = "",
    this.isDownloaded = false,
    this.progress = 0,
    this.loading = false,
  });

  deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        this.isDownloaded = false;
        debugPrint("file deleted");
      }
    } catch (e) {
      debugPrint("Error on file deleted $e");
      // Error in getting access to the file.
    }
  }

  @override
  State<SemproItem> createState() => _SemproItemWidgetState();
}

class _SemproItemWidgetState extends State<SemproItem> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: buildMaterialColor(Color(0xFFF12A2A)),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.black,
              size: 24.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.fileName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  widget.size,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 24,
                width: 24,
                child: widget.isDownloaded
                    ? Icon(
                      Icons.check,
                      color: Colors.black,
                    )
                    : widget.loading
                        ? CircularProgressIndicator(
                          color: Colors.black,
                          value: widget.progress,
                          strokeWidth: 2.0,
                        )
                        : Icon(
                            Icons.download,
                            color: Colors.black,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
