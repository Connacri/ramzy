import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food2/main.dart';
import 'package:intl/intl.dart' as intl;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionPage2 extends StatelessWidget {
  final String scannedUserId;

  TransactionPage2({required this.scannedUserId});

  final TextEditingController amountController =
      TextEditingController(); // Ajout de cette ligne
  final GlobalKey<FormState> _formCoinsMKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false).fetchCurrentUserData();
    Provider.of<DataProvider>(context, listen: false)
        .fetchScannedUserData(scannedUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: ListView(
        children: [
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              final userData = dataProvider.currentUserData;

              if (userData.isEmpty) {
                // Display a loading indicator while data is being fetched.
                return Center(
                    //child: CircularProgressIndicator(),
                    );
              } else {
                return Center(
                  child: Column(
                    children: [
                      ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userData['avatar']),
                        ),
                        title: Text(
                          'MON SOLDE EST DE : ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                        subtitle: PriceWidget(
                          price: userData['coins'],
                        ),
                        //trailing: Icon(Icons.add),
                      ),
                      IncrementCoinsRow(
                        userId: userData['id'],
                      ),
                      ScannedConsumer(scannedUserId),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
                        child: Text(
                          'Scanned User: $scannedUserId'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formCoinsMKey,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: amountController,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.black38),
                                    //fillColor: Colors.blue.shade50,
                                    hintText: 'Montant à envoyer',
                                    //border: InputBorder.none,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    filled: true,
                                    contentPadding: EdgeInsets.all(15),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Entrer Le Montant';
                                    }
                                    return null;
                                  },
                                ),

                                // TextFormField(
                                //   controller: amountController,
                                //   keyboardType: TextInputType.number,
                                //   decoration: InputDecoration(labelText: 'Montant à envoyer'),
                                // ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                            child: InkWell(
                                onTap: () async {
                                  if (_formCoinsMKey.currentState!.validate()) {
                                    // print(userData['id']);
                                    // print(scannedUserId);
                                    // Implémentez la logique d'envoi de coins ici
                                    // Utilisez une transaction Firestore pour effectuer la transaction
                                    try {
                                      // Récupérez le montant saisi par l'utilisateur depuis le champ de texte
                                      String amountStr = amountController.text;
                                      double amount =
                                          double.tryParse(amountStr) ?? 0.0;

                                      // Vérifiez que le montant est supérieur à zéro
                                      if (amount <= 0) {
                                        // Montant invalide, affichez un message d'erreur
                                        // Vous pouvez afficher un dialogue d'erreur ou un message d'erreur ici
                                        print('Montant invalide');
                                        return;
                                      }

                                      // Effectuez la transaction Firestore
                                      FirebaseFirestore.instance
                                          .runTransaction((transaction) async {
                                        // Récupérez les références des documents des deux utilisateurs
                                        DocumentReference senderRef =
                                            FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(userData['id']);

                                        DocumentReference receiverRef =
                                            FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(scannedUserId);

                                        // Récupérez les données actuelles des deux utilisateurs
                                        DocumentSnapshot senderSnapshot =
                                            await transaction.get(senderRef);
                                        DocumentSnapshot receiverSnapshot =
                                            await transaction.get(receiverRef);

                                        // Vérifiez si l'utilisateur a suffisamment de coins à envoyer
                                        double senderCoins =
                                            senderSnapshot['coins'] ?? 0.0;
                                        if (senderCoins < amount) {
                                          // L'utilisateur n'a pas suffisamment de coins, annulez la transaction
                                          print('Solde insuffisant');
                                          Fluttertoast.showToast(
                                            fontSize: 30,
                                            msg: 'Solde insuffisant',
                                            gravity: ToastGravity.TOP,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                          );
                                          showDialog(
                                            context:
                                                context, // Le contexte actuel
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.red,
                                                title: Text(
                                                  "ALERT",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: Text(
                                                  "Votre Solde est Insuffisant \nVeuillez Recharger Votre Compte",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                // actions: [
                                                //   // Les actions que vous souhaitez inclure (boutons, etc.)
                                                //   TextButton(
                                                //     child: Text("Fermer"),
                                                //     onPressed: () {
                                                //       // Fermez la boîte de dialogue en appelant Navigator.pop
                                                //       Navigator.of(context).pop();
                                                //     },
                                                //   ),
                                                // ],
                                              );
                                            },
                                          );

                                          return;
                                        }

                                        // Mettez à jour les soldes des deux utilisateurs
                                        transaction.set(
                                            senderRef,
                                            {'coins': senderCoins - amount},
                                            SetOptions(merge: true));
                                        double receiverCoins =
                                            receiverSnapshot['coins'] ?? 0.0;
                                        transaction.set(
                                            receiverRef,
                                            {'coins': receiverCoins + amount},
                                            SetOptions(merge: true));
                                      });

                                      // Une fois la transaction réussie, vous pouvez mettre à jour les soldes
                                      //Navigator.pop(context); // Revenir à la page précédente
                                      // Mettez à jour les soldes locaux si nécessaire
                                      // setState(() {
                                      //   // Mise à jour des soldes locaux
                                      // });
                                    } catch (e) {
                                      // Gestion des erreurs de transaction
                                      print(
                                          'Erreur lors de la transaction : $e');
                                      // Vous pouvez afficher un message d'erreur ici
                                    }
                                  }
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Color.fromARGB(255, 0, 127, 232),
                                  size: 25,
                                )),
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     if (_formCoinsMKey.currentState!.validate()) {
                      //       // print(userData['id']);
                      //       // print(scannedUserId);
                      //       // Implémentez la logique d'envoi de coins ici
                      //       // Utilisez une transaction Firestore pour effectuer la transaction
                      //       try {
                      //         // Récupérez le montant saisi par l'utilisateur depuis le champ de texte
                      //         String amountStr = amountController.text;
                      //         double amount = double.tryParse(amountStr) ?? 0.0;
                      //
                      //         // Vérifiez que le montant est supérieur à zéro
                      //         if (amount <= 0) {
                      //           // Montant invalide, affichez un message d'erreur
                      //           // Vous pouvez afficher un dialogue d'erreur ou un message d'erreur ici
                      //           print('Montant invalide');
                      //           return;
                      //         }
                      //
                      //         // Effectuez la transaction Firestore
                      //         FirebaseFirestore.instance
                      //             .runTransaction((transaction) async {
                      //           // Récupérez les références des documents des deux utilisateurs
                      //           DocumentReference senderRef = FirebaseFirestore
                      //               .instance
                      //               .collection('Users')
                      //               .doc(userData['id']);
                      //
                      //           DocumentReference receiverRef =
                      //               FirebaseFirestore.instance
                      //                   .collection('Users')
                      //                   .doc(scannedUserId);
                      //
                      //           // Récupérez les données actuelles des deux utilisateurs
                      //           DocumentSnapshot senderSnapshot =
                      //               await transaction.get(senderRef);
                      //           DocumentSnapshot receiverSnapshot =
                      //               await transaction.get(receiverRef);
                      //
                      //           // Vérifiez si l'utilisateur a suffisamment de coins à envoyer
                      //           double senderCoins =
                      //               senderSnapshot['coins'] ?? 0.0;
                      //           if (senderCoins < amount) {
                      //             // L'utilisateur n'a pas suffisamment de coins, annulez la transaction
                      //             print('Solde insuffisant');
                      //             Fluttertoast.showToast(
                      //               fontSize: 30,
                      //               msg: 'Solde insuffisant',
                      //               gravity: ToastGravity.TOP,
                      //               backgroundColor: Colors.red,
                      //               textColor: Colors.white,
                      //             );
                      //             showDialog(
                      //               context: context, // Le contexte actuel
                      //               builder: (BuildContext context) {
                      //                 return AlertDialog(
                      //                   backgroundColor: Colors.red,
                      //                   title: Text(
                      //                     "ALERT",
                      //                     style: TextStyle(color: Colors.white),
                      //                   ),
                      //                   content: Text(
                      //                     "Votre Solde est Insuffisant \nVeuillez Recharger Votre Compte",
                      //                     style: TextStyle(
                      //                         color: Colors.white,
                      //                         fontSize: 20),
                      //                   ),
                      //                   // actions: [
                      //                   //   // Les actions que vous souhaitez inclure (boutons, etc.)
                      //                   //   TextButton(
                      //                   //     child: Text("Fermer"),
                      //                   //     onPressed: () {
                      //                   //       // Fermez la boîte de dialogue en appelant Navigator.pop
                      //                   //       Navigator.of(context).pop();
                      //                   //     },
                      //                   //   ),
                      //                   // ],
                      //                 );
                      //               },
                      //             );
                      //
                      //             return;
                      //           }
                      //
                      //           // Mettez à jour les soldes des deux utilisateurs
                      //           transaction.set(
                      //               senderRef,
                      //               {'coins': senderCoins - amount},
                      //               SetOptions(merge: true));
                      //           double receiverCoins =
                      //               receiverSnapshot['coins'] ?? 0.0;
                      //           transaction.set(
                      //               receiverRef,
                      //               {'coins': receiverCoins + amount},
                      //               SetOptions(merge: true));
                      //         });
                      //
                      //         // Une fois la transaction réussie, vous pouvez mettre à jour les soldes
                      //         //Navigator.pop(context); // Revenir à la page précédente
                      //         // Mettez à jour les soldes locaux si nécessaire
                      //         // setState(() {
                      //         //   // Mise à jour des soldes locaux
                      //         // });
                      //       } catch (e) {
                      //         // Gestion des erreurs de transaction
                      //         print('Erreur lors de la transaction : $e');
                      //         // Vous pouvez afficher un message d'erreur ici
                      //       }
                      //     }
                      //   },
                      //   child: Text('Envoyer'),
                      // ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key,
    required this.price,
  });

  final price;

  @override
  Widget build(BuildContext context) {
    return Text(
      intl.NumberFormat.currency(
        symbol: 'DZD ',
        decimalDigits: 2,
      ).format(price),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class IncrementCoinsRow extends StatefulWidget {
  final String
      userId; // L'ID de l'utilisateur dont vous voulez incrémenter les coins

  IncrementCoinsRow({required this.userId});

  @override
  _IncrementCoinsRowState createState() => _IncrementCoinsRowState();
}

class _IncrementCoinsRowState extends State<IncrementCoinsRow> {
  TextEditingController _amountController = TextEditingController();
  double _amountToAdd = 0.0;
  final GlobalKey<FormState> _formCoinsLKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Form(
          key: _formCoinsLKey,
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black38),
                  //fillColor: Colors.blue.shade50,
                  hintText: 'Alimentation Personnel',
                  //border: InputBorder.none,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer Le Montant';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _amountToAdd = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: IconButton(
            onPressed: () {
              if (_formCoinsLKey.currentState!.validate()) {
                // Accédez au document de l'utilisateur dans la collection "Users"
                DocumentReference userRef = FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.userId);

                // Utilisez une transaction Firestore pour incrémenter les coins
                FirebaseFirestore.instance.runTransaction((transaction) async {
                  DocumentSnapshot userSnapshot =
                      await transaction.get(userRef);

                  if (userSnapshot.exists) {
                    // Récupérez les coins actuels de l'utilisateur
                    double currentCoins = userSnapshot['coins'] ?? 0.0;

                    // Incrémente les coins
                    double newCoins = currentCoins + _amountToAdd;

                    // Mettez à jour les coins dans le document de l'utilisateur
                    transaction.set(
                        userRef, {'coins': newCoins}, SetOptions(merge: true));
                  }
                });

                // Effacez le champ de texte après avoir effectué la transaction
                _amountController.clear();
                FocusScope.of(context).unfocus();
              }
            },
            icon: Icon(
              FontAwesomeIcons.moneyCheckDollar,
              color: Colors.brown,
            ),
          ),
        ),
      ],
    );
  }
}

class ScannedConsumer extends StatelessWidget {
  const ScannedConsumer(String scannedUserId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final userData = dataProvider.scannedUserData;

        if (userData.isEmpty) {
          // Display a loading indicator while data is being fetched.
          return Center(
              //child: CircularProgressIndicator(),
              );
        } else {
          final displayName = userData['displayName'];
          final email = userData['email'];
          final coins = userData['coins'];

          return Center(
            child: Card(
              child: ListTile(
                dense: true,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userData['avatar']),
                ),
                title: Text(
                  displayName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: isArabic(
                    displayName,
                  )
                      ? GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w700)
                      : TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                ),
                subtitle: FittedBox(
                  child: Text(
                    email,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                trailing: PriceWidget(
                  price: coins,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
