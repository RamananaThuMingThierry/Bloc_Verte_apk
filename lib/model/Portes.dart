class Portes{
  String? id, nom, numero_porte,contact, image;

  Portes({this.id, this.nom, this.numero_porte, this.image, this.contact});

  static Portes? current;

  factory Portes.fromJson(Map<String, dynamic> j){
    return Portes(
        nom: j['nom'],
        numero_porte: j['numero_porte'],
        contact: j['contact'],
        image: j['image'],
        id: j['id']);
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "nom" : nom,
    "numero_porte" : numero_porte,
    "contact" : contact,
    "image": image
  };
}