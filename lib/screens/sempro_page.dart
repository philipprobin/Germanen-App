import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../network/Database.dart';

class SemproPage extends StatefulWidget {
  const SemproPage({Key? key}) : super(key: key);

  @override
  _SemproPageState createState() => _SemproPageState();
}


class _SemproPageState extends State<SemproPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<SfPdfViewer>(
          future: openPDF(),
          builder:  (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else {
              return CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }

  Future<SfPdfViewer> openPDF() async {
    var snapshot = SfPdfViewer.network(await Database.getSemproUri());
    return snapshot;
  }
}
/*
final file = await PDFApi.loadNetwork(await Database.getSemproUri());
          openPDF(context, file!);
 */
