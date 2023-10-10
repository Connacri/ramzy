import 'package:cloud_firestore/cloud_firestore.dart';

class ListFood2 {
  String docId;
  String item;
  String desc;
  String image;
  String flav;
  String cat;
  int price;
  Timestamp createdAt;
  String user;

  ListFood2({
    required this.docId,
    required this.item,
    required this.desc,
    required this.image,
    required this.price,
    required this.cat,
    required this.flav,
    required this.createdAt,
    required this.user,
  });
  // factory ListFood2.fromSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   Map<String, dynamic> data = snapshot.data()!;
  //   return ListFood2(
  //     docId: data['docId'],
  //     item: data['item'],
  //     flav: data['flav'],
  //     desc: data['desc'],
  //     price: data['price'],
  //     image: data['image'],
  //     cat: data['cat'] ?? '',
  //     createdAt: data['createdAt'],
  //     user: data['user'],
  //   );
  // }

  factory ListFood2.fromMap(Map<String, dynamic> map) {
    return ListFood2(
      docId: map['docId'],
      item: map['item'],
      desc: map['desc'],
      image: map['image'],
      price: map['price'],
      cat: map['cat'] ?? '',
      flav: map['flav'],
      createdAt: map['createdAt'],
      user: map['user'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'item': item,
      'desc': desc,
      'image': image,
      'price': price,
      'cat': cat,
      'flav': flav,
      'createdAt': createdAt,
      'user': user,
    };
  }

  factory ListFood2.fromSnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ListFood2(
      docId: data['docId'],
      item: data['item'],
      flav: data['flav'],
      desc: data['desc'],
      price: data['price'],
      image: data['image'],
      cat: data['cat'] ?? '',
      createdAt: data['createdAt'],
      user: data['user'],
    );
  }
}

class TransactionModel {
  String senderUserId;
  String receiverUserId;
  double amount;
  Timestamp timestamp; // Utilisez Timestamp au lieu de DateTime

  TransactionModel({
    required this.senderUserId,
    required this.receiverUserId,
    required this.amount,
    required this.timestamp,
  });

  // Méthode pour convertir votre modèle en Map
  Map<String, dynamic> toMap() {
    return {
      'senderUserId': senderUserId,
      'receiverUserId': receiverUserId,
      'amount': amount,
      'timestamp': timestamp, // Conservez le Timestamp ici
    };
  }

  // Méthode pour créer un modèle à partir d'une Map
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      senderUserId: map['senderUserId'],
      receiverUserId: map['receiverUserId'],
      amount: map['amount'],
      timestamp: map['timestamp'], // Conservez le Timestamp ici
    );
  }
}
