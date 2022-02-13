import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/user.dart';

Future<Uint8List> generateDocument(
    PdfPageFormat format, UserData userData) async {
  final doc = pw.Document(pageMode: PdfPageMode.outlines);

  final font1 = await PdfGoogleFonts.openSansRegular();
  final font2 = await PdfGoogleFonts.openSansBold();

  List<Claim> claims = (await FirebaseFirestore.instance
          .collection('claims')
          .where('userId', isEqualTo: userData.id)
          .get())
      .docs
      .map((s) => Claim.fromFirestore(s))
      .toList();

  var data = <List<String>>[];
  var totalHours = 0.0;

  data.add(['Volunteer Title', 'Date/Time', 'Hours']);
  for (int i = 0; i < claims.length; i++) {
    if (claims[i].completed) {
      await claims[i].getJob();
      data.add([
        claims[i].job!.title,
        DateFormat.yMMMMd('en_US')
            .add_jm()
            .format(claims[i].job!.appointmentTime),
        claims[i].hours.toString()
      ]);
      totalHours += claims[i].hours ?? 0;
    }
  }

  final logo = pw.MemoryImage(
    (await rootBundle.load('assets/colortransparentbk.png'))
        .buffer
        .asUint8List(),
  );
  doc.addPage(pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: font1,
        bold: font2,
      ),
      pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      build: (pw.Context context) => <pw.Widget>[
            pw.Header(
                level: 0,
                title: 'Voluntarius Service Hours Report',
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text('Voluntarius Service Hours Report',
                          textScaleFactor: 2),
                      pw.Container(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Image(logo),
                          width: 60,
                          height: 60)
                    ])),
            pw.Paragraph(text: 'Service Hours For: ' + userData.name),
            pw.Paragraph(
                text: 'Report Generated: ' +
                    DateFormat.yMMMMd('en_US').add_jm().format(DateTime.now())),
            pw.Paragraph(text: 'Total Hours: ' + totalHours.toString()),
            pw.Table.fromTextArray(context: context, data: data),
          ]));
  return doc.save();
  // final file = File('example.pdf');
  // await file.writeAsBytes(await doc.save());
}
