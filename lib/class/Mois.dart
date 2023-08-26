import 'package:flutter/material.dart';

class MoisFacture {
  String? nom_mois;
  double? depart;
  double? fin;
  String? date;
  double? montant_facture;

  MoisFacture({String? m, double? d, double? f, String? date, double? montant_facture}){
    this.nom_mois = m;
    this.depart = d;
    this.fin = f;
    this.date = date;
    this.montant_facture = montant_facture;
  }
}