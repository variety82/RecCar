import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


class MakeDamagePdfScreen extends StatefulWidget {
  final Map<String, dynamic> detailRentInfo;
  final Map<String, dynamic> simpleDamageInfo;

  const MakeDamagePdfScreen({
    required this.detailRentInfo,
    required this.simpleDamageInfo,
    super.key,
  });

  @override
  State<MakeDamagePdfScreen> createState() => _MakeDamagePdfScreenState();
}

class _MakeDamagePdfScreenState extends State<MakeDamagePdfScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColor, title: Text('PDF 미리 보기', style: TextStyle(color: Colors.white, fontSize: 14,),),),
        body: PdfPreview(
          build: (format) => _generatePdf(format, 'pdf'),
        ),
      ),
    );
  }
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}
