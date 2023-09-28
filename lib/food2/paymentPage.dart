import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food2/main.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food2/models.dart';
import 'package:ramzy/food2/usersListCoins.dart';

class TransactionPage2 extends StatefulWidget {
  final String scannedUserId;

  TransactionPage2({required this.scannedUserId});

  @override
  State<TransactionPage2> createState() => _TransactionPage2State();
}

class _TransactionPage2State extends State<TransactionPage2> {
  final TextEditingController amountController = TextEditingController();
  // Ajout de cette ligne
  final GlobalKey<FormState> _formCoinsMKey = GlobalKey<FormState>();
  bool _isSubmitting =
      false; // Variable pour suivre l'état de soumission du formulaire
  @override
  void dispose() {
    Provider.of<DataProvider>(context, listen: false).fetchCurrentUserData();
    Provider.of<DataProvider>(context, listen: false)
        .fetchScannedUserData(widget.scannedUserId);
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false).fetchCurrentUserData();
    Provider.of<DataProvider>(context, listen: false)
        .fetchScannedUserData(widget.scannedUserId);

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
                        subtitle: AnimatedFlipCounter(
                          value: userData[
                              'coins'], // Utilisez la partie entière de priceValue.
                          prefix: "DZD ",
                          textStyle: TextStyle(
                            fontFamily: 'OSWALD',
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        //     PriceWidget(
                        //   price: userData['coins'],
                        // ),
                        //trailing: Icon(Icons.add),
                      ),
                      IncrementCoinsRow(
                        userId: userData['id'],
                      ),
                      ScannedConsumer(
                        scannedUserId: widget.scannedUserId,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
                        child: Text(
                          'Scanned User: ${widget.scannedUserId}'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Form(
                      //         key: _formCoinsMKey,
                      //         child: Padding(
                      //           padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      //           child: TextFormField(
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //               fontSize: 18,
                      //             ),
                      //             keyboardType: TextInputType.number,
                      //             controller: amountController,
                      //             decoration: InputDecoration(
                      //               hintStyle: TextStyle(color: Colors.black38),
                      //               //fillColor: Colors.blue.shade50,
                      //               hintText: 'Montant à envoyer',
                      //               //border: InputBorder.none,
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(7.0),
                      //               ),
                      //               filled: true,
                      //               contentPadding: EdgeInsets.all(15),
                      //             ),
                      //             validator: (value) {
                      //               if (value == null || value.isEmpty) {
                      //                 return 'Entrer Le Montant';
                      //               }
                      //               return null;
                      //             },
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                      //       child: InkWell(
                      //           onTap: () async {
                      //             if (_formCoinsMKey.currentState!.validate()) {
                      //               // Implémentez la logique d'envoi de coins ici
                      //               // Utilisez une transaction Firestore pour effectuer la transaction
                      //               try {
                      //                 // Récupérez le montant saisi par l'utilisateur depuis le champ de texte
                      //                 String amountStr = amountController.text;
                      //                 double amount =
                      //                     double.tryParse(amountStr) ?? 0.0;
                      //
                      //                 // Vérifiez que le montant est supérieur à zéro
                      //                 if (amount <= 0) {
                      //                   // Montant invalide, affichez un message d'erreur
                      //                   // Vous pouvez afficher un dialogue d'erreur ou un message d'erreur ici
                      //                   print('Montant invalide');
                      //                   return;
                      //                 }
                      //
                      //                 // Effectuez la transaction Firestore
                      //                 FirebaseFirestore.instance
                      //                     .runTransaction((transaction) async {
                      //                   // Récupérez les références des documents des deux utilisateurs
                      //                   DocumentReference senderRef =
                      //                       FirebaseFirestore.instance
                      //                           .collection('Users')
                      //                           .doc(userData['id']);
                      //
                      //                   DocumentReference receiverRef =
                      //                       FirebaseFirestore.instance
                      //                           .collection('Users')
                      //                           .doc(widget.scannedUserId);
                      //
                      //                   // Récupérez les données actuelles des deux utilisateurs
                      //                   DocumentSnapshot senderSnapshot =
                      //                       await transaction.get(senderRef);
                      //                   DocumentSnapshot receiverSnapshot =
                      //                       await transaction.get(receiverRef);
                      //
                      //                   // Vérifiez si l'utilisateur a suffisamment de coins à envoyer
                      //                   double senderCoins =
                      //                       senderSnapshot['coins'] ?? 0.0;
                      //                   if (senderCoins < amount) {
                      //                     // L'utilisateur n'a pas suffisamment de coins, annulez la transaction
                      //                     print('Solde insuffisant');
                      //                     Fluttertoast.showToast(
                      //                       fontSize: 30,
                      //                       msg: 'Solde insuffisant',
                      //                       gravity: ToastGravity.TOP,
                      //                       backgroundColor: Colors.red,
                      //                       textColor: Colors.white,
                      //                     );
                      //                     showDialog(
                      //                       context:
                      //                           context, // Le contexte actuel
                      //                       builder: (BuildContext context) {
                      //                         return AlertDialog(
                      //                           backgroundColor: Colors.red,
                      //                           title: Text(
                      //                             "ALERT",
                      //                             style: TextStyle(
                      //                                 color: Colors.white),
                      //                           ),
                      //                           content: Text(
                      //                             "Votre Solde est Insuffisant \nVeuillez Recharger Votre Compte",
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 20),
                      //                           ),
                      //                           // actions: [
                      //                           //   // Les actions que vous souhaitez inclure (boutons, etc.)
                      //                           //   TextButton(
                      //                           //     child: Text("Fermer"),
                      //                           //     onPressed: () {
                      //                           //       // Fermez la boîte de dialogue en appelant Navigator.pop
                      //                           //       Navigator.of(context).pop();
                      //                           //     },
                      //                           //   ),
                      //                           // ],
                      //                         );
                      //                       },
                      //                     );
                      //
                      //                     return;
                      //                   }
                      //
                      //                   // Mettez à jour les soldes des deux utilisateurs
                      //                   transaction.set(
                      //                       senderRef,
                      //                       {'coins': senderCoins - amount},
                      //                       SetOptions(merge: true));
                      //                   double receiverCoins =
                      //                       receiverSnapshot['coins'] ?? 0.0;
                      //                   transaction.set(
                      //                       receiverRef,
                      //                       {'coins': receiverCoins + amount},
                      //                       SetOptions(merge: true));
                      //                 });
                      //
                      //                 // Une fois la transaction réussie, vous pouvez mettre à jour les soldes
                      //                 //Navigator.pop(context); // Revenir à la page précédente
                      //                 // Mettez à jour les soldes locaux si nécessaire
                      //                 // setState(() {
                      //                 //   // Mise à jour des soldes locaux
                      //                 // });
                      //               } catch (e) {
                      //                 // Gestion des erreurs de transaction
                      //                 print(
                      //                     'Erreur lors de la transaction : $e');
                      //                 // Vous pouvez afficher un message d'erreur ici
                      //               }
                      //             }
                      //           },
                      //           child: Icon(
                      //             Icons.send,
                      //             color: Color.fromARGB(255, 0, 127, 232),
                      //             size: 25,
                      //           )),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      // Expanded(
                      //   child:
                      TransactionSubmitButton(
                          userData: userData,
                          scannedUserId: widget.scannedUserId,
                          formKey: _formCoinsMKey,
                          amountController: amountController),

                      // Form(
                      //   key: _formCoinsMKey,
                      //   child: Padding(
                      //     padding: EdgeInsets.fromLTRB(15, 0, 015, 0),
                      //     child: TextFormField(
                      //       readOnly: _isSubmitting ? true : false,
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontSize: 18,
                      //       ),
                      //       keyboardType: TextInputType.number,
                      //       controller: amountController,
                      //       decoration: InputDecoration(
                      //         suffixIcon: _isSubmitting
                      //             ? Center(child: CircularProgressIndicator())
                      //             : InkWell(
                      //                 onTap: _isSubmitting
                      //                     ? null
                      //                     : () async {
                      //                         // Vérifiez si le formulaire est déjà en cours de soumission
                      //                         if (_isSubmitting) return;
                      //
                      //                         if (_formCoinsMKey.currentState!
                      //                             .validate()) {
                      //                           // Mettez à jour l'état pour indiquer que la soumission est en cours
                      //                           setState(() {
                      //                             _isSubmitting = true;
                      //                           });
                      //
                      //                           // Récupérez le montant saisi par l'utilisateur depuis le champ de texte
                      //                           String amountStr =
                      //                               amountController.text;
                      //                           double amount = double.tryParse(
                      //                                   amountStr) ??
                      //                               0.0;
                      //
                      //                           // Vérifiez que le montant est supérieur à zéro
                      //                           if (amount <= 0) {
                      //                             // Montant invalide, affichez un message d'erreur
                      //                             // Vous pouvez afficher un dialogue d'erreur ou un message d'erreur ici
                      //                             print('Montant invalide');
                      //
                      //                             // Réinitialisez l'état pour indiquer que la soumission est terminée
                      //                             setState(() {
                      //                               _isSubmitting = false;
                      //                             });
                      //
                      //                             return;
                      //                           }
                      //
                      //                           try {
                      //                             // Effectuez la transaction Firestore
                      //                             await FirebaseFirestore
                      //                                 .instance
                      //                                 .runTransaction(
                      //                                     (transaction) async {
                      //                               // Récupérez les références des documents des deux utilisateurs
                      //                               DocumentReference
                      //                                   senderRef =
                      //                                   FirebaseFirestore
                      //                                       .instance
                      //                                       .collection('Users')
                      //                                       .doc(
                      //                                           userData['id']);
                      //
                      //                               DocumentReference
                      //                                   receiverRef =
                      //                                   FirebaseFirestore
                      //                                       .instance
                      //                                       .collection('Users')
                      //                                       .doc(widget
                      //                                           .scannedUserId);
                      //
                      //                               // Récupérez les données actuelles des deux utilisateurs
                      //                               DocumentSnapshot
                      //                                   senderSnapshot =
                      //                                   await transaction
                      //                                       .get(senderRef);
                      //                               DocumentSnapshot
                      //                                   receiverSnapshot =
                      //                                   await transaction
                      //                                       .get(receiverRef);
                      //
                      //                               // Vérifiez si l'utilisateur a suffisamment de coins à envoyer
                      //                               double senderCoins =
                      //                                   senderSnapshot[
                      //                                           'coins'] ??
                      //                                       0.0;
                      //                               if (senderCoins < amount) {
                      //                                 // L'utilisateur n'a pas suffisamment de coins, annulez la transaction
                      //                                 print(
                      //                                     'Solde insuffisant');
                      //                                 // Fluttertoast.showToast(
                      //                                 //   fontSize: 20,
                      //                                 //   msg:
                      //                                 //       'Solde insuffisant',
                      //                                 //   gravity:
                      //                                 //       ToastGravity.TOP,
                      //                                 //   backgroundColor:
                      //                                 //       Colors.red,
                      //                                 //   textColor: Colors.white,
                      //                                 // );
                      //                                 showDialog(
                      //                                   context: context,
                      //                                   builder: (BuildContext
                      //                                       context) {
                      //                                     return AlertDialog(
                      //                                       backgroundColor:
                      //                                           Colors.red,
                      //                                       title: Text(
                      //                                         "ALERT",
                      //                                         style: TextStyle(
                      //                                             color: Colors
                      //                                                 .white),
                      //                                       ),
                      //                                       content: Text(
                      //                                         "Votre Solde est Insuffisant \nVeuillez Recharger Votre Compte",
                      //                                         style: TextStyle(
                      //                                             color: Colors
                      //                                                 .white,
                      //                                             fontSize: 20),
                      //                                       ),
                      //                                     );
                      //                                   },
                      //                                 );
                      //
                      //                                 // Réinitialisez l'état pour indiquer que la soumission est terminée
                      //                                 setState(() {
                      //                                   _isSubmitting = false;
                      //                                 });
                      //
                      //                                 return;
                      //                               }
                      //
                      //                               // Mettez à jour les soldes des deux utilisateurs
                      //                               transaction.set(
                      //                                   senderRef,
                      //                                   {
                      //                                     'coins': senderCoins -
                      //                                         amount
                      //                                   },
                      //                                   SetOptions(
                      //                                       merge: true));
                      //                               double receiverCoins =
                      //                                   receiverSnapshot[
                      //                                           'coins'] ??
                      //                                       0.0;
                      //                               transaction.set(
                      //                                   receiverRef,
                      //                                   {
                      //                                     'coins':
                      //                                         receiverCoins +
                      //                                             amount
                      //                                   },
                      //                                   SetOptions(
                      //                                       merge: true));
                      //                             });
                      //
                      //                             // Une fois la transaction réussie, vous pouvez mettre à jour les soldes
                      //                             // Vous pouvez également ajouter un message de réussite ici
                      //                           } catch (e) {
                      //                             // Gestion des erreurs de transaction
                      //                             print(
                      //                                 'Erreur lors de la transaction : $e');
                      //                             // Vous pouvez afficher un message d'erreur ici
                      //                           }
                      //
                      //                           // Réinitialisez l'état pour indiquer que la soumission est terminée
                      //                           setState(() {
                      //                             _isSubmitting = false;
                      //                           });
                      //                           amountController.clear();
                      //                           FocusScope.of(context)
                      //                               .unfocus();
                      //                         }
                      //                       },
                      //                 child: Icon(
                      //                   Icons.send,
                      //                   color: Color.fromARGB(255, 0, 127, 232),
                      //                   size: 25,
                      //                 ),
                      //               ),
                      //         filled:
                      //             _isSubmitting ? true : false, //<-- SEE HERE
                      //         fillColor:
                      //             _isSubmitting ? Colors.grey.shade200 : null,
                      //         hintStyle: TextStyle(
                      //           color: Colors.black38,
                      //         ),
                      //         hintText: 'Montant à envoyer',
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(7.0),
                      //         ),
                      //
                      //         contentPadding: EdgeInsets.all(15),
                      //       ),
                      //       validator: (value) {
                      //         if (value == null || value.isEmpty) {
                      //           return 'Entrer Le Montant';
                      //         }
                      //         return null;
                      //       },
                      //     ),
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserListPage()));
                            },
                            child: Text('Users')),
                      )
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
        locale: 'fr_FR',
        symbol: 'DZD',
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
  bool _isSubmitting = false;
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
              padding: EdgeInsets.fromLTRB(15, 15, 015, 15),
              child: TextFormField(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: _isSubmitting
                        ? null
                        : () async {
                            // Vérifiez si le formulaire est déjà en cours de soumission
                            if (_isSubmitting) return;

                            if (_formCoinsLKey.currentState!.validate()) {
                              // Mettez à jour l'état pour indiquer que la soumission est en cours
                              setState(() {
                                _isSubmitting = true;
                              });

                              DocumentReference userRef = FirebaseFirestore
                                  .instance
                                  .collection('Users')
                                  .doc(widget.userId);

                              try {
                                // Utilisez une transaction Firestore pour incrémenter les coins
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot userSnapshot =
                                      await transaction.get(userRef);

                                  if (userSnapshot.exists) {
                                    // Récupérez les coins actuels de l'utilisateur
                                    double currentCoins =
                                        userSnapshot['coins'] ?? 0.0;

                                    // Incrémente les coins
                                    double newCoins =
                                        currentCoins + _amountToAdd;

                                    // Mettez à jour les coins dans le document de l'utilisateur
                                    transaction.set(
                                        userRef,
                                        {'coins': newCoins},
                                        SetOptions(merge: true));
                                    // Réinitialisez l'état pour indiquer que la soumission est terminée
                                    setState(() {
                                      _isSubmitting = false;
                                    });
                                  }
                                });

                                // Effacez le champ de texte après avoir effectué la transaction
                                _amountController.clear();
                                FocusScope.of(context).unfocus();

                                // Effectuez d'autres actions après une transaction réussie ici
                              } catch (e) {
                                // Gestion des erreurs de transaction
                                print('Erreur lors de la transaction : $e');
                                // Vous pouvez afficher un message d'erreur ici
                              }
                            }
                          },
                    child: _isSubmitting
                        ? FittedBox(
                            child: Lottie.asset(
                              'assets/lotties/124102-loading-screen.json',
                              animate: true,
                              repeat: true,
                              width: 150,
                              height: 150,
                            ),
                          )
                        : Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 0, 127, 232),
                            size: 25,
                          ),
                  ),
                  filled: _isSubmitting ? true : false, //<-- SEE HERE
                  fillColor: _isSubmitting ? Colors.grey.shade200 : null,
                  hintStyle: TextStyle(color: Colors.black38),
                  hintText: 'Alimentation Personnel',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
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
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        //   child: IconButton(
        //     onPressed: () {
        //       if (_formCoinsLKey.currentState!.validate()) {
        //         // Accédez au document de l'utilisateur dans la collection "Users"
        //         DocumentReference userRef = FirebaseFirestore.instance
        //             .collection('Users')
        //             .doc(widget.userId);
        //
        //         // Utilisez une transaction Firestore pour incrémenter les coins
        //         FirebaseFirestore.instance.runTransaction((transaction) async {
        //           DocumentSnapshot userSnapshot =
        //               await transaction.get(userRef);
        //
        //           if (userSnapshot.exists) {
        //             // Récupérez les coins actuels de l'utilisateur
        //             double currentCoins = userSnapshot['coins'] ?? 0.0;
        //
        //             // Incrémente les coins
        //             double newCoins = currentCoins + _amountToAdd;
        //
        //             // Mettez à jour les coins dans le document de l'utilisateur
        //             transaction.set(
        //                 userRef, {'coins': newCoins}, SetOptions(merge: true));
        //           }
        //         });
        //
        //         // Effacez le champ de texte après avoir effectué la transaction
        //         _amountController.clear();
        //         FocusScope.of(context).unfocus();
        //       }
        //     },
        //     icon: Icon(
        //       FontAwesomeIcons.moneyCheckDollar,
        //       color: Colors.brown,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class ScannedConsumer extends StatelessWidget {
  const ScannedConsumer({
    super.key,
    required this.scannedUserId,
  });

  final String scannedUserId;

  @override
  Widget build(BuildContext context) {
    Provider.of<DataProvider>(context, listen: false)
        .fetchScannedUserData(scannedUserId);
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

class TransactionSubmitButton extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String scannedUserId;
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;

  TransactionSubmitButton({
    required this.userData,
    required this.scannedUserId,
    required this.formKey,
    required this.amountController,
  });

  @override
  _TransactionSubmitButtonState createState() =>
      _TransactionSubmitButtonState();
}

class _TransactionSubmitButtonState extends State<TransactionSubmitButton> {
  bool _isSubmitting = false;
  final TextEditingController _amountController = TextEditingController();

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Entrez un montant';
    }
    double? amount = double.tryParse(value);
    if (amount == null || amount <= 0 || amount > 5000) {
      return 'Montant invalide\nMontant doit etre entre 0 et 5000';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextFormField(
          readOnly: _isSubmitting ? true : false,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(4), // Limite à 4 caractères
          ],
          keyboardType: TextInputType.number,
          controller: widget.amountController,
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: _isSubmitting
                  ? null
                  : () async {
                      // Vérifiez si le formulaire est déjà en cours de soumission
                      if (_isSubmitting) return;

                      if (widget.formKey.currentState!.validate()) {
                        // Mettez à jour l'état pour indiquer que la soumission est en cours
                        setState(() {
                          _isSubmitting = true;
                        });

                        // Récupérez le montant saisi par l'utilisateur depuis le champ de texte
                        String amountStr = widget.amountController.text;
                        double amount = double.tryParse(amountStr) ?? 0.0;

                        // Vérifiez que le montant est supérieur à zéro
                        if (amount <= 0) {
                          // Montant invalide, affichez un message d'erreur
                          // Vous pouvez afficher un dialogue d'erreur ou un message d'erreur ici
                          print('Montant invalide');

                          // Réinitialisez l'état pour indiquer que la soumission est terminée
                          setState(() {
                            _isSubmitting = false;
                          });

                          return;
                        }

                        try {
                          // Effectuez la transaction Firestore
                          await FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                            // Récupérez les références des documents des deux utilisateurs
                            DocumentReference senderRef = FirebaseFirestore
                                .instance
                                .collection('Users')
                                .doc(widget.userData['id']);

                            DocumentReference receiverRef = FirebaseFirestore
                                .instance
                                .collection('Users')
                                .doc(widget.scannedUserId);

                            // Récupérez les données actuelles des deux utilisateurs
                            DocumentSnapshot senderSnapshot =
                                await transaction.get(senderRef);
                            DocumentSnapshot receiverSnapshot =
                                await transaction.get(receiverRef);

                            // Vérifiez si l'utilisateur a suffisamment de coins à envoyer
                            double senderCoins = senderSnapshot['coins'] ?? 0.0;
                            if (senderCoins < amount) {
                              // L'utilisateur n'a pas suffisamment de coins, annulez la transaction
                              print('Solde insuffisant');

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.red,
                                    title: Text(
                                      "ALERT",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                      "Votre Solde est Insuffisant \nVeuillez Recharger Votre Compte",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  );
                                },
                              );

                              // Réinitialisez l'état pour indiquer que la soumission est terminée
                              // setState(() {
                              //   _isSubmitting = false;
                              // });

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
                            showCongratulationsDialog(
                              context,
                              amount,
                              receiverCoins + amount,
                            );
                            addTransactionToFirestore(widget.userData['id'],
                                widget.scannedUserId, amount);
                          });

                          // Une fois la transaction réussie, vous pouvez mettre à jour les soldes
                          // Vous pouvez également ajouter un message de réussite ici
                          //Navigator.of(context).pushReplacement(newRoute)
                        } catch (e) {
                          // Gestion des erreurs de transaction
                          print('Erreur lors de la transaction : $e');
                          // Vous pouvez afficher un message d'erreur ici
                          // Affichez la boîte de dialogue d'erreur avec un message approprié
                          showTransactionErrorDialog(
                              context, "La transaction a échoué : $e");
                        }

                        // Réinitialisez l'état pour indiquer que la soumission est terminée
                        setState(() {
                          _isSubmitting = false;
                        });
                        widget.amountController.clear();
                        FocusScope.of(context).unfocus();
                        //Navigator.of(context).pushReplacement(newRoute)
                      }
                    },
              child: _isSubmitting
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        FittedBox(
                          child: Lottie.asset(
                            'assets/lotties/animation_lmtavzq3.json',
                            // repeat: false,
                          ),
                        ),
                        Text(
                          widget.amountController.text,
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    )
                  : Icon(
                      Icons.send,
                      color: Color.fromARGB(255, 0, 127, 232),
                      size: 25,
                    ),
            ),
            filled: _isSubmitting ? true : false, //<-- SEE HERE
            fillColor: _isSubmitting ? Colors.grey.shade200 : null,
            hintStyle: TextStyle(
              fontSize: 35,
              color: Colors.black38,
            ),
            hintText: 'Montant à Envoyer',
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),

            //contentPadding: EdgeInsets.all(25),
          ),
          validator: _validateAmount,
          //     (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'Entrer Le Montant';
          //   }
          //   return null;
          // },

          maxLength: 4,
        ),
      ),
    );
  }
}

void showCongratulationsDialog(
    BuildContext context, double Coins, double total) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Félicitations !"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarGlow(
              glowColor: Colors.blue,
              endRadius: 90.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                // Replace this child with your own
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Lottie.asset(
                    'assets/lotties/animation_lmqwfkzg.json',
                    height: 60,
                    width: 60,
                    repeat: true,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            FittedBox(
              child: Text(
                'Envoyer : ' +
                    intl.NumberFormat.currency(
                      locale: 'fr_FR',
                      symbol: 'DZD',
                      decimalDigits: 2,
                    ).format(Coins),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Lottie.asset(
              'assets/lotties/animation_lmqwf1by.json', // Chemin vers votre animation Lottie
              width: 150,
              height: 150,
              repeat: true,
              animate: true,
            ),
            SizedBox(height: 20),
            Text(
              'Beneficier Solde : '.toString().capitalize(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              intl.NumberFormat.currency(
                locale: 'fr_FR',
                symbol: 'DZD',
                decimalDigits: 2,
              ).format(total),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text("La transaction a réussi !".toString().capitalize()),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermez la boîte de dialogue
              },
              child: Text("Fermer"),
            ),
          ),
        ],
      );
    },
  );
}

void showTransactionErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Erreur de transaction"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
            ),
            AvatarGlow(
              glowColor: Colors.blue,
              endRadius: 90.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              child: Material(
                // Replace this child with your own
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Lottie.asset(
                    'assets/lotties/animation_lmqwfkzg.json',
                    height: 60,
                    width: 60,
                  ),
                  radius: 40.0,
                ),
              ),
            ),
            Lottie.asset(
              'assets/lotties/animation_lmqwf1by.json', // Chemin vers votre animation Lottie
              width: 150,
              height: 150,
              repeat: false,
              animate: true,
            ),
            SizedBox(height: 20),
            Text("Erreur de la transaction!".toString().capitalize()),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermez la boîte de dialogue
              },
              child: Text("Fermer"),
            ),
          ),
        ],
      );
    },
  );
}

void addTransactionToFirestore(
    String senderUserId, String receiverUserId, double amount) async {
  try {
    final Timestamp timestamp = Timestamp.now();
    final TransactionModel transaction = TransactionModel(
      senderUserId: senderUserId,
      receiverUserId: receiverUserId,
      amount: amount,
      timestamp: timestamp,
    );

    final DocumentReference transactionRef =
        FirebaseFirestore.instance.collection('transactions').doc();

    await transactionRef.set(transaction.toMap());
    print('Transaction réussie et ajoutée à la collection Firestore.');
  } catch (e) {
    print('Erreur lors de l\'ajout de la transaction à Firestore : $e');
  }
}
