class MoisPdf {
  final String nom_mois;
  final String new_index;
  final String ancien_index;
  final String consommer;
  final String total_consommer_portes;
  final String reste_compteur;
  final String payer_reste_compteur;
  final String montant_ar;
  final String montant_fmg;

  const MoisPdf({
    required this.nom_mois,
    required this.new_index,
    required this.ancien_index,
    required this.consommer,
    required this.total_consommer_portes,
    required this.reste_compteur,
    required this.payer_reste_compteur,
    required this.montant_fmg,
    required this.montant_ar
  });
}
