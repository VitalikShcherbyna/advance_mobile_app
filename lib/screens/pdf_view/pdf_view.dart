import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:app/style_provider.dart';
import 'package:app/widgets/flutter_18n.dart';

enum PdfDoc { Regulation, Pravicy }

class PdfView extends StatelessWidget {
  const PdfView({Key key, @required this.showDocument}) : super(key: key);
  final PdfDoc showDocument;

  Future<PDFDocument> _getRegulation() async {
    String url = await FirebaseStorage()
        .ref()
        .child(showDocument == PdfDoc.Regulation
            ? '/regulation/regulation.pdf'
            : '/privacy/privacy.pdf')
        .getDownloadURL();
    return await PDFDocument.fromURL(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StylesProvider.of(context).colors.primaryColor,
        title: Text(
          CustomFlutterI18n.translate(
              context,
              showDocument == PdfDoc.Regulation
                  ? 'RegulationView.regulation'
                  : 'RegulationView.privacy'),
          style: StylesProvider.of(context)
              .fonts
              .normalWhite
              .copyWith(fontSize: 22),
        ),
      ),
      body: FutureBuilder(
        future: _getRegulation(),
        builder: (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
          if (snapshot.hasData) {
            return PDFViewer(document: snapshot.data);
          } else {
            return Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    StylesProvider.of(context).colors.primaryColor,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
