import 'package:cloud_firestore/cloud_firestore.dart';

class Charges {
  double amount;
  Timestamp createdAt;
  bool credit;
  Timestamp date;
  int deadline;
  String model;
  bool periodic;
  String type;

  Charges.name(this.amount, this.createdAt, this.credit, this.date,
      this.deadline, this.model, this.periodic, this.type);

  Charges.fromJson(Map<String, dynamic> parsedJSON)
      : amount = parsedJSON['amount'],
        createdAt = parsedJSON['createdAt'],
        credit = parsedJSON['credit'],
        date = parsedJSON['date'],
        deadline = parsedJSON['deadline'],
        model = parsedJSON['model'],
        periodic = parsedJSON['periodic'],
        type = parsedJSON['type'];
}

class ItemsA {
  final String category;
  final String code;
  final String codebar;
  final String description;
  final String model;
  final int oldStock;
  final String origine;
  final double prixAchat;
  final double prixVente;
  final String size;
  final int stock;
  final String user;

  const ItemsA(
      {required this.category,
      required this.code,
      required this.codebar,
      required this.description,
      required this.model,
      required this.oldStock,
      required this.origine,
      required this.prixAchat,
      required this.prixVente,
      required this.size,
      required this.stock,
      required this.user});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'code': code,
      'codebar': codebar,
      'description': description,
      'model': model,
      'oldStock': oldStock,
      'origine': origine,
      'prixAchat': prixAchat,
      'prixVente': prixVente,
      'size': size,
      'stock': stock,
      'user': user,
    };
  }

  static ItemsA fromJson(json) => ItemsA(
        code: json['code']! as String,
        category: json['category']! as String,
        model: json['model']! as String,
        description: json['description']! as String,
        size: json['size']! as String,
        prixAchat: double.parse(json['prixAchat']!.toString()),
        prixVente: double.parse(json['prixVente']!.toString()),
        stock: json['stock']! as int,
        oldStock: json['oldStock']! as int,
        codebar: json['codebar']!.toString() as String,
        origine: json['origine']! as String,
        user: json['user']! as String,
      );
}

// class Invoice {
//   final double benef;
//   final String customer;
//   final Timestamp date;
//   final List itemCodeBar;
//   final double total;
//
//   const Invoice({
//     required this.benef,
//     required this.customer,
//     required this.date,
//     required this.itemCodeBar,
//     required this.total,
//   });
//
//   static Invoice fromJson(json) => Invoice(
//         benef: json['benef'] as double,
//         customer: json['customer']! as String,
//         date: json['date']! as Timestamp,
//         itemCodeBar: json['itemCodeBar']! as List,
//         total: json['total'] as double,
//       );
// }

class UserDetail {
  Timestamp UcreatedAt;
  int userAge;
  String userAvatar;
  String userDisplayName;
  String userEmail;
  String userID;
  int userItemsNbr;
  int userPhone;
  String userSex;
  bool userState;
  String userRole;

  UserDetail(
      this.UcreatedAt,
      this.userAge,
      this.userAvatar,
      this.userDisplayName,
      this.userEmail,
      this.userID,
      this.userItemsNbr,
      this.userPhone,
      this.userSex,
      this.userState,
      this.userRole);

  Map<String, dynamic> createMap() {
    return {
      'UcreatedAt': UcreatedAt,
      'userAge': userAge,
      'userAvatar': userAvatar,
      'userDisplayName': userDisplayName,
      'userEmail': userEmail,
      'userID': userID,
      'userItemsNbr': userItemsNbr,
      'userPhone': userPhone,
      'userSex': userSex,
      'userState': userState,
      'userRole': userRole,
    };
  }

  UserDetail.fromFirestore(Map<String, dynamic> parsedJSON)
      : UcreatedAt = parsedJSON['UcreatedAt'],
        userAge = parsedJSON['userAge'],
        userAvatar = parsedJSON['userAvatar'],
        userDisplayName = parsedJSON['userDisplayName'],
        userEmail = parsedJSON['userEmail'],
        userID = parsedJSON['userID'],
        userItemsNbr = parsedJSON['userItemsNbr'],
        userPhone = parsedJSON['userPhone'],
        userSex = parsedJSON['userSex'],
        userState = parsedJSON['userState'],
        userRole = parsedJSON['userRole'];
}

// class UserPro {
//   Timestamp UcreatedAt;
//   int userAge;
//   String userAvatar;
//   String userDisplayName;
//   String userEmail;
//   String userID;
//   int userItemsNbr;
//   int userPhone;
//   String userSex;
//   bool userState;
//   String userRole;
//
//   UserPro.name(
//       this.UcreatedAt,
//       this.userAge,
//       this.userAvatar,
//       this.userDisplayName,
//       this.userEmail,
//       this.userID,
//       this.userItemsNbr,
//       this.userPhone,
//       this.userSex,
//       this.userState,
//       this.userRole);
//
//   UserPro.fromJson(Map<String, dynamic> parsedJSON)
//       : UcreatedAt = parsedJSON['UcreatedAt'],
//         userAge = parsedJSON['userAge'],
//         userAvatar = parsedJSON['userAvatar'],
//         userDisplayName = parsedJSON['userDisplayName'],
//         userEmail = parsedJSON['userEmail'],
//         userID = parsedJSON['userID'],
//         userItemsNbr = parsedJSON['userItemsNbr'],
//         userPhone = parsedJSON['userPhone'],
//         userSex = parsedJSON['userSex'],
//         userState = parsedJSON['userState'],
//         userRole = parsedJSON['userRole'];
// }

class Invoice {
  final String id;
  final double benef;
  final String customer;
  final Timestamp date;
  final List itemCodeBar;
  final double total;

  const Invoice({
    required this.id,
    required this.benef,
    required this.customer,
    required this.date,
    required this.itemCodeBar,
    required this.total,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'benef': benef,
      'customer': customer,
      'date': date,
      'itemCodeBar': itemCodeBar,
      'total': total,
    };
  }

  static Invoice fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      benef: map['benef'],
      customer: map['customer'],
      date: map['date'],
      itemCodeBar: List.from(map['itemCodeBar']),
      total: map['total'],
    );
  }
}

class SuperHero {
  final String userDisplayName;
  final String userAvatar;

  SuperHero({required this.userDisplayName, required this.userAvatar});

  static SuperHero fromJson(json) => SuperHero(
        userDisplayName: json['userDisplayName'] ?? '',
        userAvatar: json['userAvatar'] ?? '',
      );
}
