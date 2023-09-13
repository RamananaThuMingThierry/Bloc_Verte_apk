import 'dart:io';

import 'package:bv/fonts/myFont.dart';
import 'package:bv/model/facturesPdf.dart';
import 'package:bv/model/mois_pdf.dart';
import 'package:bv/utils/functions.dart';
import 'package:bv/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {

  static Future<File> generateCenteredText(FacturePdf facturePdf, String? nom) async{
    final pdf = Document(deflate: zlib.encode);

    final font = await rootBundle.load("assets/OpenSans-Regular.ttf");
    final ttf = Font.ttf(font);

    pdf.addPage(MultiPage(
        build: (context) => [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Trano Maitso",textAlign: TextAlign.center, style: TextStyle(color: PdfColors.green, font: ttf, fontWeight: FontWeight.bold, fontSize: 32)),
            ]
          ),
          SizedBox(height: 3 * PdfPageFormat.cm),
          buildFacturesMois(facturePdf.moisPdf),
          Divider(),
          buildFacturesPortes(facturePdf),
          Divider(),
          buildTotal(facturePdf.moisPdf),
        ],
      footer: (context) => buildFooter(),
      )
    );
    return saveDocument(name: "${nom}.pdf", pdf: pdf);
  }

  static Widget buildTotal(MoisPdf moisPdf) {

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Montant en Ar',
                  value: Utils.formatPrice(double.parse(moisPdf.montant_ar)),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Montant en Fmg',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(double.parse(moisPdf.montant_fmg)),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: 'Adresse', value: "VT 29 RAI bis Ampahateza"),
    ],
  );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  // static Widget buildFacturesMois(MoisPdf moisPdf){
  //   return Table(
  //     border: TableBorder.all(), // Ajout d'une bordure autour du tableau (facultatif)
  //     children: [
  //       TableRow(
  //         decoration: BoxDecoration(color: PdfColors.grey300), // Style pour la ligne d'en-tête
  //         children: [
  //           Center(
  //             child: Text(
  //               'Nouvel Index',
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           Center(
  //             child: Text(
  //               'Ancien Index',
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           Center(
  //             child: Text(
  //               'Consommer',
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           Center(
  //             child: Text(
  //               'Reste Compteur',
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ],
  //       ),
  //       TableRow(
  //         children: [
  //           Center(
  //             child: Text('${moisPdf.new_index}'),
  //           ),
  //           Center(
  //             child: Text('${moisPdf.ancien_index}'),
  //           ),
  //           Align(
  //             alignment: Alignment.centerRight,
  //             child: Text('${moisPdf.consommer}'),
  //           ),
  //           Align(
  //             alignment: Alignment.centerRight,
  //             child: Text('${moisPdf.reste_compteur}'),
  //           ),
  //         ],
  //       ),
  //       // Ajoutez d'autres lignes de données ici si nécessaire
  //     ],
  //   );
  // }

  static Widget buildFacturesMois(MoisPdf moisPdf) {

    final titles = <String>[
      'Mois : ',
      'Nouvel index:',
      'Ancien index :',
      'Consommer :',
      'Consommer par porte',
      'Reste Compteur:',
      'Payer reste compteur :'
    ];

    final data = <String>[
      moisPdf.nom_mois,
      moisPdf.new_index,
      moisPdf.ancien_index,
      moisPdf.consommer,
      moisPdf.total_consommer_portes,
      moisPdf.reste_compteur,
      moisPdf.payer_reste_compteur
     ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static buildText({ required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold,);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );

  }

  static Widget buildFacturesPortes(FacturePdf facturePdf) {
    final headers = [
      'Portes',
      'Nouvel | Ancien',
      'Consommer',
      'Compteur',
      'Ar',
      'Fmg'
    ];

    final data = facturePdf.items.map((item) {
      return [
        item.portes,
        "${formatAmount(item.new_index) }  |  ${formatAmount(item.ancien_index)}",
        formatAmount(item.consommer),
        formatAmount(item.compteur),
        formatAmount(item.ar),
        formatAmount(item.fmg)
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        5: Alignment.center,
      },
    );
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
    }) async {

    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
