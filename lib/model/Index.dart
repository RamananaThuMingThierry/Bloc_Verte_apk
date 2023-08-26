class Indexs{
  String? id, nouvel_index,ancien_index, mois_id, portes_id;
  bool? payer;
  Indexs({this.id, this.nouvel_index, this.ancien_index, this.mois_id, this.portes_id, this.payer});

  static Indexs? current;

  factory Indexs.fromJson(Map<String, dynamic> j){
    return Indexs(
        nouvel_index: j['nouvel_index'],
        ancien_index: j['ancien_index'],
        mois_id: j['mois_id'],
        portes_id: j['portes_id'],
        payer: j['payer'],
        id: j['id']);
  }

  Map<String, dynamic> toMap() => {"id": id, "nouvel_index" : nouvel_index, "ancien_index" : ancien_index,"mois_id" : mois_id, "portes_id": portes_id, "payer": payer};
}