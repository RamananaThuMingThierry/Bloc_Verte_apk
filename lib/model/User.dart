class UserM{
  String? id, pseudo, email, genre, adresse, contact, image, roles;
  UserM({this.id, this.pseudo, this.email, this.image, this.contact,this.roles, this.adresse, this.genre});

  static UserM? current;

  factory UserM.fromJson(Map<String, dynamic> j){
    return UserM(
        email: j['email'],
        pseudo: j['pseudo'],
        genre: j['genre'],
        adresse: j['adresse'],
        contact: j['contact'],
        image: j['image'],
        roles: j['roles'],
        id: j['id']);
  }

  Map<String, dynamic> toMap() => {"id": id, "pseudo" : pseudo, "email" : email,"contact" : contact,"roles": roles, "image": image, "adresse": adresse, "genre" : genre};
}