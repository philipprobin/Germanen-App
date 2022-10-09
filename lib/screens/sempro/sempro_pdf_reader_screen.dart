
import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

import '../../widgets/app_toolbar.dart';

class SemproPdfReaderScreen extends StatefulWidget {
  const SemproPdfReaderScreen(this.controller, {Key? key}) : super(key: key);
  final PdfControllerPinch controller;

  @override
  State<SemproPdfReaderScreen> createState() => _SemproPdfReaderScreenState();
}

class _SemproPdfReaderScreenState extends State<SemproPdfReaderScreen> {
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
