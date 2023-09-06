import 'package:cloud_firestore/cloud_firestore.dart';

class ListFood {
  String docId;
  String item;
  String desc;
  String image;
  String flav;
  String cat;
  int price;
  Timestamp createdAt;
  String user;

  ListFood({
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
  factory ListFood.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;
    return ListFood(
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
  factory ListFood.fromMap(Map<String, dynamic> map) {
    return ListFood(
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
}

class ListFoodSqF {
  String docId;
  String item;
  String desc;
  String image;
  String flav;
  String cat;
  int price;
  String createdAt;
  String user;
  bool isFavorite; // Nouvelle propriété pour indiquer si l'élément est favorisé

  ListFoodSqF({
    required this.docId,
    required this.item,
    required this.desc,
    required this.image,
    required this.price,
    required this.cat,
    required this.flav,
    required this.createdAt,
    required this.user,
    this.isFavorite = false, // Par défaut, l'élément n'est pas favorisé.
  });
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'item': item,
      'desc': desc,
      'image': image,
      'price': price,
      'cat': cat,
      'flav': flav,
      'createdAt': createdAt, // Convert DateTime to milliseconds since epoch
      'user': user,
      'isFavorite': isFavorite,
    };
  }

  factory ListFoodSqF.fromMap(Map<String, dynamic> map) {
    return ListFoodSqF(
      docId: map['docId'],
      item: map['item'],
      desc: map['desc'],
      image: map['image'],
      price: map['price'],
      cat: map['cat'] ?? '',
      flav: map['flav'],
      createdAt: map['createdAt'],
      user: map['user'],
      isFavorite: map['isFavorite'],
    );
  }
}
