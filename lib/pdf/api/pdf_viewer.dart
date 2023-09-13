import 'package:flutter/material.dart';
import 'package:pdf_viewer_v2/pdf_viewer_v2.dart';

class PdfViewer extends StatefulWidget {
  final PDFDocument document;
  const PdfViewer({super.key, required this.document});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: SizedBox.expand(
          child: PDFViewer(document: widget.document)),
    );
  }
}