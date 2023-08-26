class Chats{
  String? id, nom,email,contact,message, date;

  Chats({this.id, this.nom, this.email, this.contact, this.message, this.date});

  static Chats? current;

  factory Chats.fromJson(Map<String, dynamic> j){
    return Chats(
        nom: j['nom'],
        email: j['email'],
        contact: j['contact'],
        message: j['message'],
        date:j['date'],
        id: j['id']);
  }

  Map<String, dynamic> toMap() => {"id": id, "nom" : nom, "email" : email,"contact" : contact, "message": message, "date": date};
}