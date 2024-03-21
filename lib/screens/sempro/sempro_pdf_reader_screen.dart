
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../widgets/custom_app_bar.dart';

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
      appBar: const CustomAppBar(),
      body: Container(
        child: PdfViewPinch(
          controller: widget.controller,
        ),
      ),
    );
  }
}
