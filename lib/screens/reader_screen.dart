
import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

import '../widgets/app_toolbar.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen(this.controller, {Key? key}) : super(key: key);
  final PdfControllerPinch controller;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: AppToolbar(
          sectionName: 'Germanen-App',
        ),
      ),
      body: Container(
        child: PdfViewPinch(
          controller: widget.controller,
        ),
      ),
    );
  }
}
