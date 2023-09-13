

import 'package:bv/model/customer.dart';
import 'package:bv/model/mois_pdf.dart';

class FacturePdf {
  final List<PortesItem> items;
  final MoisPdf moisPdf;
  const FacturePdf({
    required this.moisPdf,
    required this.items,
  });
}



class PortesItem {
  final String portes;
  final String new_index;
  final String ancien_index;
  final String consommer;
  final String tarif;
  final String compteur;
  final String ar;
  final String fmg;

  const PortesItem({
    required this.portes,
    required this.new_index,
    required this.ancien_index,
    required this.consommer,
    required this.tarif,
    required this.compteur,
    required this.ar,
    required this.fmg
  });
}
