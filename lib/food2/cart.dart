import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food2/MesAchatsPage.dart';
import 'package:ramzy/food2/main.dart';
import 'package:intl/intl.dart' as intl;

// class CartPage2 extends StatelessWidget {
//   double calculateTotalAmount(List<Map<String, dynamic>> cartItems) {
//     double totalAmount = 0.0;
//
//     for (var cartItem in cartItems) {
//       // Assurez-vous que les clés correspondent à la structure de vos articles
//       final int price = cartItem['price'] as int;
//       final int quantity = cartItem['qty'] as int;
//
//       // Calculez le montant total pour cet article
//       final int itemTotal = price * quantity;
//
//       // Ajoutez le montant de cet article au montant total
//       totalAmount += itemTotal;
//     }
//
//     return totalAmount;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context);
//     final cartItems = dataProvider.getCart(); // Obtenez les articles du panier
//     final totalAmount = calculateTotalAmount(cartItems);
//
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 80.0,
//         title: Text('Mon Panier'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Text(
//               intl.NumberFormat.currency(symbol: 'DZD ', decimalDigits: 2)
//                   .format(totalAmount),
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.orange),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: // ...
//                 ListView.builder(
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 final cartItem = cartItems[index];
//                 final sumLine = cartItem['price'] * cartItem['qty'];
//
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Container(
//                         width: 50, // Ajustez la largeur selon vos besoins
//                         height: 50, // Ajustez la hauteur selon vos besoins
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(
//                               10), // Ajustez le rayon selon vos besoins
//                           image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: cartItem['image'] == null
//                                 ? CachedNetworkImageProvider(
//                                     "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg")
//                                 : CachedNetworkImageProvider(cartItem['image']),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Text(
//                         cartItem['qty'] > 99
//                             ? 'nd'
//                             : cartItem['qty'].toString().padLeft(2, '0'),
//                         style: TextStyle(fontSize: 35),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(cartItem['item']),
//                             Text('DZD ${cartItem['price'].toStringAsFixed(2)}'),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.remove),
//                             onPressed: () {
//                               // Diminuer la quantité
//                               Provider.of<DataProvider>(context, listen: false)
//                                   .decreaseQuantity(index);
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.add),
//                             onPressed: () {
//                               // Augmenter la quantité
//                               Provider.of<DataProvider>(context, listen: false)
//                                   .increaseQuantity(index);
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                             ),
//                             onPressed: () {
//                               // Supprimer l'article du panier
//                               Provider.of<DataProvider>(context, listen: false)
//                                   .removeItemFromCart(index);
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
// // ...
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Text(
//                     'Total : \DZD ${totalAmount.toStringAsFixed(2)}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.green),
//                   onPressed: () {
//                     confirmAndSendToFirestore(context); // Pass the context here
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void confirmAndSendToFirestore(BuildContext context) async {
//     final dataProvider = Provider.of<DataProvider>(context, listen: false);
//     final cartItems = dataProvider.getCart();
//     final totalAmount = calculateTotalAmount(cartItems);
//     final currentTime = DateTime.now();
//
//     final Map<String, dynamic> userData =
//         await dataProvider.getCurrentUserDocument();
//
//     if (userData.isNotEmpty && userData.containsKey('id')) {
//       final String userId = userData['id'];
//
//       try {
//         // Create a reference to the subcollection "carts" under the user's document
//         final userRef = FirebaseFirestore.instance
//             .collection('usersCommande')
//             .doc(userId)
//             .collection('cartsUsers')
//             .doc();
//
//         // Create a list of items from cartItems
//         final List<Map<String, dynamic>> itemsList = cartItems.map((cartItem) {
//           return {
//             'image': cartItem['image'],
//             'fournisseur': cartItem['user'],
//             'item': cartItem['item'],
//             'price': cartItem['price'],
//             'qty': cartItem['qty'],
//           };
//         }).toList();
//
//         // Update the Firestore document with cart data, total, and createdAt
//         await userRef.set({
//           'items': itemsList,
//           'cartTotal': totalAmount,
//           'createdAt': currentTime,
//         });
//
//         // Show a confirmation message or navigate to a success page.
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             showCloseIcon: true,
//             closeIconColor: Colors.red,
//             duration: Duration(seconds: 2),
//             content: Text('Cart data sent to Firestore.'),
//           ),
//         );
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => MesAchatsPage()));
//       } catch (e) {
//         // Handle any errors that occur during Firestore update.
//         print('Error sending cart data to Firestore: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error sending cart data. Please try again.'),
//           ),
//         );
//       }
//     } else {
//       // Handle the case where user data or userId is not available.
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('User data not available. Please try again later.'),
//         ),
//       );
//     }
//   }
// }

class CartPage2 extends StatelessWidget {
  double calculateTotalAmount(List<Map<String, dynamic>> cartItems) {
    double totalAmount = 0.0;

    for (var cartItem in cartItems) {
      final int price = cartItem['price'] as int;
      final int quantity = cartItem['qty'] as int;
      final int itemTotal = price * quantity;
      totalAmount += itemTotal;
    }

    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final cartItems = dataProvider.getCart();
    final totalAmount = calculateTotalAmount(cartItems);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: Text('Mon Panier'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              intl.NumberFormat.currency(symbol: 'DZD ', decimalDigits: 2)
                  .format(totalAmount),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: cartItem['image'] == null
                                ? CachedNetworkImageProvider(
                                    "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg")
                                : CachedNetworkImageProvider(cartItem['image']),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        cartItem['qty'] > 99
                            ? 'nd'
                            : cartItem['qty'].toString().padLeft(2, '0'),
                        style: TextStyle(fontSize: 35),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cartItem['item']),
                            Text('DZD ${cartItem['price'].toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              Provider.of<DataProvider>(context, listen: false)
                                  .decreaseQuantity(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Provider.of<DataProvider>(context, listen: false)
                                  .increaseQuantity(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Provider.of<DataProvider>(context, listen: false)
                                  .removeItemFromCart(index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Total : \DZD ${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: () async {
                    confirmAndSendToFirestore(context, cartItems, totalAmount);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void confirmAndSendToFirestore(BuildContext context,
      List<Map<String, dynamic>> cartItems, double totalAmount) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final currentTime = DateTime.now();
    final Map<String, dynamic> userData =
        await dataProvider.getCurrentUserDocument();

    if (userData.isNotEmpty && userData.containsKey('id')) {
      final String userId = userData['id'];

      try {
        final userRef = FirebaseFirestore.instance
            .collection('usersCommande')
            .doc(userId)
            .collection('cartsUsers')
            .doc();
        final List<Map<String, dynamic>> itemsList = cartItems.map((cartItem) {
          return {
            'docId': cartItem['docId'],
            'item': cartItem['item'],
            //'desc': cartItem['desc'],
            'image': cartItem['image'],
            'price': cartItem['price'],
            'cat': cartItem['cat'],
            //'flav': cartItem['flav'],
            // 'createdAt': currentTime,
            //'user': cartItem['user'],
            'qty': cartItem['qty']
          };
        }).toList();

        final Map<String, dynamic> cartData = {
          'items': itemsList,
          'cartTotal': totalAmount,
          'createdAt': currentTime,
        };

        await userRef.set(cartData);

// Réinitialisez le panier après l'envoi des données à Firestore
        await dataProvider.clearCart();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.red,
            duration: Duration(seconds: 2),
            content: Text('Données du panier envoyées à Firestore.'),
          ),
        );
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MesAchatsPage()));
      } catch (e) {
        print('Erreur lors de l\'envoi des données du panier à Firestore: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erreur lors de l\'envoi des données du panier. Veuillez réessayer.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Données utilisateur non disponibles. Veuillez réessayer plus tard.'),
        ),
      );
    }
  }
}
