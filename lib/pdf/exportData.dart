import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> generatePDF() async {
  final pdf = pw.Document();

  // Créez un tableau avec des données
  final List<List<String>> data = [
    ['Nom', 'Âge', 'Ville'],
    ['Alice', '28', 'New York'],
    ['Bob', '32', 'Los Angeles'],
    ['Charlie', '25', 'Chicago'],
  ];

  // Créez une liste de lignes de tableau
  final List<pw.TableRow> tableRows = data.map((row) {
    return pw.TableRow(
      children: row.map((item) {
        return pw.Text(item, style: pw.TextStyle(fontSize: 12));
      }).toList(),
    );
  }).toList();

  // Ajoutez le tableau au document PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                pw.Text('Nom', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Âge', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Ville', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            ...tableRows,
          ],
        );
      },
    ),
  );

  var dir = await getApplicationDocumentsDirectory();
  // File file = File('${dir.path}/$pName.pdf');
  //
  // bool  fileExists = File(await '${dir.path}/$pName.pdf')
  //     .existsSync();
  //
  // if(fileExists)
  // {
  //   urlPdfPath = file.toString();
  //   print('url pdf path $urlPdfPath');
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return PdfViewer(
  //       path: urlPdfPath,
  //       product: pName,
  //     );
  //   }));

    // Enregistrez le PDF sur l'appareil
  final String filePath = '/${dir}/fichier.pdf';
  final File file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  // Ouvrez le PDF avec une application PDF viewer
  OpenFile.open(filePath);
}
