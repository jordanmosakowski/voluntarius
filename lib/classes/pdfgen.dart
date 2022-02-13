import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List> generateDocument(PdfPageFormat format) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);

  final font1 = await PdfGoogleFonts.openSansRegular();
  final font2 = await PdfGoogleFonts.openSansBold();

  doc.addPage(pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: font1,
        bold: font2,
      ),
      pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      build: (pw.Context context) => <pw.Widget>[
            pw.Table.fromTextArray(context: context, data: const <List<String>>[
              <String>['Date', 'PDF Version', 'Acrobat Version'],
              <String>['1993', 'PDF 1.0', 'Acrobat 1'],
              <String>['1994', 'PDF 1.1', 'Acrobat 2'],
              <String>['1996', 'PDF 1.2', 'Acrobat 3'],
              <String>['1999', 'PDF 1.3', 'Acrobat 4'],
              <String>['2001', 'PDF 1.4', 'Acrobat 5'],
              <String>['2003', 'PDF 1.5', 'Acrobat 6'],
              <String>['2005', 'PDF 1.6', 'Acrobat 7'],
              <String>['2006', 'PDF 1.7', 'Acrobat 8'],
              <String>['2008', 'PDF 1.7', 'Acrobat 9'],
              <String>['2009', 'PDF 1.7', 'Acrobat 9.1'],
              <String>['2010', 'PDF 1.7', 'Acrobat X'],
              <String>['2012', 'PDF 1.7', 'Acrobat XI'],
              <String>['2017', 'PDF 2.0', 'Acrobat DC'],
            ]),
          ]));
  return doc.save();
  // final file = File('example.pdf');
  // await file.writeAsBytes(await doc.save());
}
