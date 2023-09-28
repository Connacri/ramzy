// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ramzy/food2/main.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:ramzy/food2/paymentPage.dart';
//
// class QrScanner2 extends StatefulWidget {
//   @override
//   _QrScanner2State createState() => _QrScanner2State();
// }
//
// class _QrScanner2State extends State<QrScanner2> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//
//   final TextEditingController amountController =
//       TextEditingController(); // Ajout de cette ligne
//
//   @override
//   Widget build(BuildContext context) {
//     if (result != null) {
//       // Utilisez Future.delayed pour retarder la navigation légèrement
//       Future.delayed(Duration(milliseconds: 100), () {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) =>
//                 TransactionPage2(scannedUserId: result!.code.toString()),
//           ),
//         );
//       });
//     }
//
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: _buildQrView(context),
//           ),
//           Expanded(
//             child: Center(
//               child: Lottie.asset(
//                 "assets/lotties/8998-scanning.json",
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQrView(BuildContext context) {
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 250.0
//         : 300.0;
//
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         borderColor: Colors.red,
//         borderRadius: 5,
//         borderLength: 30,
//         borderWidth: 5,
//         cutOutSize: scanArea,
//       ),
//       formatsAllowed: const <BarcodeFormat>[
//         BarcodeFormat.aztec,
//         BarcodeFormat.codabar,
//         BarcodeFormat.code39,
//         BarcodeFormat.code93,
//         BarcodeFormat.code128,
//         BarcodeFormat.dataMatrix,
//         BarcodeFormat.ean8,
//         BarcodeFormat.ean13,
//         BarcodeFormat.itf,
//         BarcodeFormat.maxicode,
//         BarcodeFormat.pdf417,
//         BarcodeFormat.qrcode,
//         BarcodeFormat.rss14,
//         BarcodeFormat.rssExpanded,
//         BarcodeFormat.upcA,
//         BarcodeFormat.upcE,
//         BarcodeFormat.upcEanExtension
//       ],
//     );
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//       result = null; // Réinitialisez la variable result à null.
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
// //
// // class TransactionPage extends StatelessWidget {
// //   final String scannedUserId;
// //
// //   TransactionPage({required this.scannedUserId});
// //
// //   final TextEditingController amountController =
// //       TextEditingController(); // Ajout de cette ligne
// //   final GlobalKey<FormState> _formCoinsMKey = GlobalKey<FormState>();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final dataProvider = Provider.of<DataProvider>(context);
// //     final userData = dataProvider.currentUserData;
// //     Provider.of<DataProvider>(context, listen: false).fetchCurrentUserData();
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Envoyer des coins'),
// //       ),
// //       body: ListView(
// //         children: [
// //           Column(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
// //                 child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
// //                   future: FirebaseFirestore.instance
// //                       .collection('Users')
// //                       .doc(userData[
// //                           'id']) // Remplacez 'votre_uid' par l'UID du document que vous voulez récupérer
// //                       .get(),
// //                   builder: (context, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return Center(
// //                         child: LinearProgressIndicator(),
// //                       );
// //                     } else if (snapshot.hasError) {
// //                       return Text('Error: ${snapshot.error}');
// //                     } else {
// //                       final userData =
// //                           snapshot.data!.data() as Map<String, dynamic>;
// //
// //                       return ListTile(
// //                         dense: true,
// //                         leading: CircleAvatar(
// //                           backgroundImage: NetworkImage(userData['avatar']),
// //                         ),
// //                         title: Text(
// //                           'MON SOLDE EST DE : ',
// //                           style: TextStyle(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.w500,
// //                               color: Colors.black54),
// //                         ),
// //                         subtitle: PriceWidget(
// //                           price: userData['coins'],
// //                         ),
// //                         //trailing: Icon(Icons.add),
// //                       );
// //                     }
// //                   },
// //                 ),
// //               ),
// //               IncrementCoinsRow(
// //                 userId: userData['id'],
// //               ),
// //               SizedBox(
// //                 height: 50,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
// //                 child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
// //                   future: FirebaseFirestore.instance
// //                       .collection('Users')
// //                       .doc(
// //                           scannedUserId) // Remplacez 'votre_uid' par l'UID du document que vous voulez récupérer
// //                       .get(),
// //                   builder: (context, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return Center(
// //                         child: LinearProgressIndicator(),
// //                       );
// //                     } else if (snapshot.hasError) {
// //                       return Text('Error: ${snapshot.error}');
// //                     } else {
// //                       final userData =
// //                           snapshot.data!.data() as Map<String, dynamic>;
// //                       final userImageUrl = userData['avatar'];
// //                       final userName = userData['displayName'];
// //
// //                       return Card(
// //                         child: ListTile(
// //                           dense: true,
// //                           leading: CircleAvatar(
// //                             backgroundImage: NetworkImage(userImageUrl),
// //                           ),
// //                           title: Text(
// //                             userName.toUpperCase(),
// //                             style: TextStyle(
// //                                 fontSize: 17,
// //                                 fontWeight: FontWeight.w500,
// //                                 color: Colors.black54),
// //                           ),
// //                           subtitle: FittedBox(
// //                             child: Text(
// //                               userData['email'],
// //                               style: TextStyle(color: Colors.black54),
// //                             ),
// //                           ),
// //                           trailing: PriceWidget(
// //                             price: userData['coins'],
// //                           ),
// //                         ),
// //                       );
// //                     }
// //                   },
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
// //                 child: Text(
// //                   'Scanned User: $scannedUserId'.toUpperCase(),
// //                   style: TextStyle(
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.w300,
// //                       color: Colors.black),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Form(
// //             key: _formCoinsMKey,
// //             child: Padding(
// //               padding: EdgeInsets.all(16.0),
// //               child: TextFormField(
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                 ),
// //                 keyboardType: TextInputType.number,
// //                 controller: amountController,
// //                 decoration: InputDecoration(
// //                   hintStyle: TextStyle(color: Colors.black38),
// //                   //fillColor: Colors.blue.shade50,
// //                   hintText: 'Montant à envoyer',
// //                   //border: InputBorder.none,
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(7.0),
// //                   ),
// //                   filled: true,
// //                   contentPadding: EdgeInsets.all(15),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Entrer Le Montant';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //
// //               // TextFormField(
// //               //   controller: amountController,
// //               //   keyboardType: TextInputType.number,
// //               //   decoration: InputDecoration(labelText: 'Montant à envoyer'),
// //               // ),
// //             ),
// //           ),
// //           ElevatedButton(
// //             onPressed: () async {
// //               if (_formCoinsMKey.currentState!.validate()) {
// //                 // print(userData['id']);
// //                 // print(scannedUserId);
// //                 // Implémentez la logique d'envoi de coins ici
// //                 // Utilisez une transaction Firestore pour effectuer la transaction
// //                 try {
// //                   // Récupérez le montant saisi par l'utilisateur depuis le champ de texte
// //                   String amountStr = amountController.text;
// //                   double amount = double.tryParse(amountStr) ?? 0.0;
// //
// //                   // Vérifiez que le montant est supérieur à zéro
// //                   if (amount <= 0) {
// //                     // Montant invalide, affichez un message d'erreur
// //                     // Vous pouvez afficher un dialogue d'erreur ou un message d'erreur ici
// //                     print('Montant invalide');
// //                     return;
// //                   }
// //
// //                   // Effectuez la transaction Firestore
// //                   FirebaseFirestore.instance
// //                       .runTransaction((transaction) async {
// //                     // Récupérez les références des documents des deux utilisateurs
// //                     DocumentReference senderRef = FirebaseFirestore.instance
// //                         .collection('Users')
// //                         .doc(userData['id']);
// //
// //                     DocumentReference receiverRef = FirebaseFirestore.instance
// //                         .collection('Users')
// //                         .doc(scannedUserId);
// //
// //                     // Récupérez les données actuelles des deux utilisateurs
// //                     DocumentSnapshot senderSnapshot =
// //                         await transaction.get(senderRef);
// //                     DocumentSnapshot receiverSnapshot =
// //                         await transaction.get(receiverRef);
// //
// //                     // Vérifiez si l'utilisateur a suffisamment de coins à envoyer
// //                     double senderCoins = senderSnapshot['coins'] ?? 0.0;
// //                     if (senderCoins < amount) {
// //                       // L'utilisateur n'a pas suffisamment de coins, annulez la transaction
// //                       print('Solde insuffisant');
// //                       Fluttertoast.showToast(
// //                         fontSize: 30,
// //                         msg: 'Solde insuffisant',
// //                         gravity: ToastGravity.TOP,
// //                         backgroundColor: Colors.red,
// //                         textColor: Colors.white,
// //                       );
// //                       showDialog(
// //                         context: context, // Le contexte actuel
// //                         builder: (BuildContext context) {
// //                           return AlertDialog(
// //                             backgroundColor: Colors.red,
// //                             title: Text(
// //                               "ALERT",
// //                               style: TextStyle(color: Colors.white),
// //                             ),
// //                             content: Text(
// //                               "Votre Solde est Insuffisant \nVeuillez Recharger Votre Compte",
// //                               style:
// //                                   TextStyle(color: Colors.white, fontSize: 20),
// //                             ),
// //                             // actions: [
// //                             //   // Les actions que vous souhaitez inclure (boutons, etc.)
// //                             //   TextButton(
// //                             //     child: Text("Fermer"),
// //                             //     onPressed: () {
// //                             //       // Fermez la boîte de dialogue en appelant Navigator.pop
// //                             //       Navigator.of(context).pop();
// //                             //     },
// //                             //   ),
// //                             // ],
// //                           );
// //                         },
// //                       );
// //
// //                       return;
// //                     }
// //
// //                     // Mettez à jour les soldes des deux utilisateurs
// //                     transaction.set(senderRef, {'coins': senderCoins - amount},
// //                         SetOptions(merge: true));
// //                     double receiverCoins = receiverSnapshot['coins'] ?? 0.0;
// //                     transaction.set(
// //                         receiverRef,
// //                         {'coins': receiverCoins + amount},
// //                         SetOptions(merge: true));
// //                   });
// //
// //                   // Une fois la transaction réussie, vous pouvez mettre à jour les soldes
// //                   //Navigator.pop(context); // Revenir à la page précédente
// //                   // Mettez à jour les soldes locaux si nécessaire
// //                   // setState(() {
// //                   //   // Mise à jour des soldes locaux
// //                   // });
// //                 } catch (e) {
// //                   // Gestion des erreurs de transaction
// //                   print('Erreur lors de la transaction : $e');
// //                   // Vous pouvez afficher un message d'erreur ici
// //                 }
// //               }
// //             },
// //             child: Text('Envoyer'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class PriceWidget extends StatelessWidget {
// //   const PriceWidget({
// //     super.key,
// //     required this.price,
// //   });
// //
// //   final price;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Text(
// //       intl.NumberFormat.currency( locale:
// //                                                 'fr_FR',
// //         symbol: 'DZD ',
// //         decimalDigits: 2,
// //       ).format(price),
// //       overflow: TextOverflow.ellipsis,
// //       style: TextStyle(
// //         color: Colors.blue,
// //         fontSize: 20,
// //         fontWeight: FontWeight.w400,
// //       ),
// //     );
// //   }
// // }
// //
// // class IncrementCoinsRow extends StatefulWidget {
// //   final String
// //       userId; // L'ID de l'utilisateur dont vous voulez incrémenter les coins
// //
// //   IncrementCoinsRow({required this.userId});
// //
// //   @override
// //   _IncrementCoinsRowState createState() => _IncrementCoinsRowState();
// // }
// //
// // class _IncrementCoinsRowState extends State<IncrementCoinsRow> {
// //   TextEditingController _amountController = TextEditingController();
// //   double _amountToAdd = 0.0;
// //   final GlobalKey<FormState> _formCoinsLKey = GlobalKey<FormState>();
// //
// //   @override
// //   void dispose() {
// //     _amountController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       crossAxisAlignment: CrossAxisAlignment.center,
// //       children: [
// //         Form(
// //           key: _formCoinsLKey,
// //           child: Expanded(
// //             child: Padding(
// //               padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
// //               child: TextFormField(
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                 ),
// //                 keyboardType: TextInputType.number,
// //                 controller: _amountController,
// //                 decoration: InputDecoration(
// //                   hintStyle: TextStyle(color: Colors.black38),
// //                   //fillColor: Colors.blue.shade50,
// //                   hintText: 'Alimentation Personnel',
// //                   //border: InputBorder.none,
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(7.0),
// //                   ),
// //                   filled: true,
// //                   contentPadding: EdgeInsets.all(15),
// //                 ),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Entrer Le Montant';
// //                   }
// //                   return null;
// //                 },
// //                 onChanged: (value) {
// //                   setState(() {
// //                     _amountToAdd = double.tryParse(value) ?? 0.0;
// //                   });
// //                 },
// //               ),
// //             ),
// //           ),
// //         ),
// //         Padding(
// //           padding: const EdgeInsets.all(18.0),
// //           child: IconButton(
// //             onPressed: () {
// //               if (_formCoinsLKey.currentState!.validate()) {
// //                 // Accédez au document de l'utilisateur dans la collection "Users"
// //                 DocumentReference userRef = FirebaseFirestore.instance
// //                     .collection('Users')
// //                     .doc(widget.userId);
// //
// //                 // Utilisez une transaction Firestore pour incrémenter les coins
// //                 FirebaseFirestore.instance.runTransaction((transaction) async {
// //                   DocumentSnapshot userSnapshot =
// //                       await transaction.get(userRef);
// //
// //                   if (userSnapshot.exists) {
// //                     // Récupérez les coins actuels de l'utilisateur
// //                     double currentCoins = userSnapshot['coins'] ?? 0.0;
// //
// //                     // Incrémente les coins
// //                     double newCoins = currentCoins + _amountToAdd;
// //
// //                     // Mettez à jour les coins dans le document de l'utilisateur
// //                     transaction.set(
// //                         userRef, {'coins': newCoins}, SetOptions(merge: true));
// //                   }
// //                 });
// //
// //                 // Effacez le champ de texte après avoir effectué la transaction
// //                 _amountController.clear();
// //                 FocusScope.of(context).unfocus();
// //               }
// //             },
// //             icon: Icon(FontAwesomeIcons.moneyCheckDollar),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
