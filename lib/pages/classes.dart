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

// class UserDetail {
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
//   UserDetail(
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
//   Map<String, dynamic> createMap() {
//     return {
//       'UcreatedAt': UcreatedAt,
//       'userAge': userAge,
//       'userAvatar': userAvatar,
//       'userDisplayName': userDisplayName,
//       'userEmail': userEmail,
//       'userID': userID,
//       'userItemsNbr': userItemsNbr,
//       'userPhone': userPhone,
//       'userSex': userSex,
//       'userState': userState,
//       'userRole': userRole,
//     };
//   }
//
//   UserDetail.fromFirestore(Map<String, dynamic> parsedJSON)
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

class Post {
  final String userID;
  final String item;
  final String category;
  final int likes;
  final int price;
  final DateTime createdAt;
  final List imageUrls;
  final String themb;
  final String decription;
  final List usersLike;
  final DateTime dateDebut;
  final DateTime dateFin;
  final GeoPoint position;
  final String levelItem;
  final String type;
  final int phone;
  final int views;
  final List viewed_by;

  const Post({
    required this.userID,
    required this.item,
    required this.price,
    required this.category,
    required this.likes,
    required this.createdAt,
    required this.imageUrls,
    required this.themb,
    required this.decription,
    required this.usersLike,
    required this.dateDebut,
    required this.dateFin,
    required this.position,
    required this.levelItem,
    required this.type,
    required this.phone,
    required this.views,
    required this.viewed_by,
  });
  Post.fromJson(Map<String, Object?> json)
      : this(
          userID: json['userID']! as String,
          item: json['item']! as String,
          category: json['category']! as String,
          likes: json['likes']! as int,
          price: json['price']! as int,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          decription: json['Description']! as String,
          imageUrls: json['imageUrls']! as List,
          themb: json['themb']! as String,
          usersLike: json['usersLike'] as List,
          dateDebut: (json['dateDebut']! as Timestamp).toDate(),
          dateFin: (json['dateFin']! as Timestamp).toDate(),
          position: json['position'] as GeoPoint,
          levelItem: json['levelItem']! as String,
          type: json['type']! as String,
          phone: json['phone'] as int,
          views: json['views'] as int,
          viewed_by: json['viewed_by']! as List,
        );
  Map<String, Object?> toJson() => {
        'userID': userID,
        'likes': likes,
        'createdAt': createdAt,
        'imageUrls': imageUrls,
        'themb': themb,
        "item": item,
        'price': price, // + '.00 dzd ',
        'category': category,
        'Description': decription,
        'usersLike': usersLike,
        'dateDebut': dateDebut,
        'dateFin': dateFin,
        'position': position,
        'levelItem': levelItem,
        'type': type,
        'phone': phone,
        'viewed_by': viewed_by,
        'views': views,
      };
}

class UserClass {
  final String id;
  final int phone;
  final String email;
  final DateTime createdAt;
  final String avatar;
  final String timeline;
  final String displayName;
  final DateTime lastActive;
  final bool state;
  final String role;
  final String plan;
  final double coins;
  final String levelUser;
  final double stars;
  final int userItemsNbr;
  final int views;
  final List viewed_by;
  UserClass({
    required this.id,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.avatar,
    required this.timeline,
    required this.displayName,
    required this.lastActive,
    required this.role,
    required this.state,
    required this.plan,
    required this.coins,
    required this.levelUser,
    required this.stars,
    required this.userItemsNbr,
    required this.views,
    required this.viewed_by,
  });
  UserClass.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          phone: json['phone'] as int,
          email: json['email']! as String,
          avatar: json['avatar']! as String,
          timeline: json['timeline']! as String,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          displayName: json['displayName']! as String,
          role: json['role']! as String,
          lastActive: (json['lastActive']! as Timestamp).toDate(),
          state: json['state']! as bool,
          plan: json['plan']! as String,
          coins: json['coins'] as double,
          levelUser: json['levelUser']! as String,
          stars: json['stars'] as double,
          userItemsNbr: json['userItemsNbr'] as int,
          views: json['views'] as int,
          viewed_by: json['viewed_by']! as List,
        );

  Map<String, Object?> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'createdAt': createdAt,
        'avatar': avatar,
        'timeline': timeline,
        'displayName': displayName,
        'lastActive': lastActive,
        'role': role,
        'state': state,
        'plan': plan,
        'coins': coins,
        'levelUser': levelUser,
        'stars': stars,
        'userItemsNbr': userItemsNbr,
        'viewed_by': viewed_by,
        'views': views,
      };
}
