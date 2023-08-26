class Mois{
  String? id,nom_mois, nouvel_index, ancien_index, montant_mois, date_mois;
  bool? payer;
  Mois({this.id, this.nom_mois, this.nouvel_index, this.ancien_index,this.payer, this.montant_mois, this.date_mois});

  static Mois? current;

  factory Mois.fromJson(Map<String, dynamic> j){
    return Mois(
        nom_mois: j['nom_mois'],
        nouvel_index: j['nouvel_index'],
        ancien_index: j['ancien_index'],
        montant_mois: j['montant_mois'],
        payer: j['payer'],
        date_mois: j['date_mois']);
  }

  get length => null;

  Map<String, dynamic> toMap() => {
    "id": id,
    "nom_mois" : nom_mois,
    "nouvel_index" : nouvel_index,
    "ancien_index" : ancien_index,
    "montant_mois": montant_mois,
    "payer": payer,
    "date_mois": date_mois
  };
}