import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food2/main.dart';
import 'package:ramzy/food2/models.dart';
import 'package:ramzy/food2/paymentPage.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart' as intl;

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<QuerySnapshot>(
          stream: getUsersListStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator()));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            }

            // Affichez la liste des utilisateurs en temps réel dans une ListView.builder
            List<DocumentSnapshot> users = snapshot.data!.docs;
            int nombre = snapshot.data!.size;
            return Text('${nombre} Users');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: StreamBuilder<double>(
              stream: getTotalCoinsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                }

                // Affichez le total des coins en temps réel dans la barre de navigation
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Total des Coins : ${snapshot.data!.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          IconButton.filledTonal(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Historique()));
              },
              icon: Icon(FontAwesomeIcons.moneyBillTrendUp))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .orderBy('coins', descending: true) // Utilisez `descending: true`
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
                    height: 20, width: 20, child: CircularProgressIndicator()));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          // Affichez la liste des utilisateurs en temps réel dans une ListView.builder
          List<DocumentSnapshot> users = snapshot.data!.docs;
          int nombre = snapshot.data!.size;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              String displayName = user['displayName'] ?? 'Utilisateur';
              String email = user['email'] ?? 'N/A';
              double coins = user['coins'] ?? 0.0;
              // users.sort((a, b) {
              //   double coinsA = a['coins'] ?? 0.0;
              //   double coinsB = b['coins'] ?? 0.0;
              //   return coinsB.compareTo(coinsA); // Trie en ordre décroissant
              // });
              return ListTile(
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TransactionPage2(scannedUserId: users[index].id)));
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatar'] ?? ''),
                  ),
                ),
                title: Text(displayName),
                subtitle: Text(email),
                trailing: InkWell(
                    onTap: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(user.id)
                            .update({'coins': 0.0});
                      } catch (e) {
                        print('Erreur lors de la mise à jour des coins : $e');
                        // Gestion de l'erreur ici
                      }
                    },
                    child: Text(coins.toStringAsFixed(2))),
              );
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> getUsersListStream() {
    return FirebaseFirestore.instance.collection('Users').snapshots();
  }

  Stream<double> getTotalCoinsStream() {
    return getUsersListStream().map((querySnapshot) {
      double totalCoins = 0.0;
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        double coins = doc['coins'] ?? 0.0;
        totalCoins += coins;
      }
      return totalCoins;
    });
  }
}

class Historique extends StatelessWidget {
  const Historique({Key? key}) : super(key: key);

  get _color => Colors.white;

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final User? user = FirebaseAuth.instance.currentUser;
    Provider.of<DataProvider>(context, listen: false).fetchCurrentUserData();
    Provider.of<DataProvider>(context, listen: false)
        .fetchScannedUserData(user!.uid);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Une erreur s\'est produite : ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Lottie.asset('assets/lotties/animation_lmqwf1by.json'));
          }

          final transactions = snapshot.data!.docs;

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                actions: [],
                expandedHeight: 220.0,
                floating: true,
                pinned: true,
                snap: true,
                elevation: 50,
                backgroundColor: Colors.black38,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.symmetric(vertical: 0),
                  centerTitle: true,
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mon Solde',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Consumer<DataProvider>(
                          builder: (context, dataProvider, child) {
                            final userData = dataProvider.currentUserData;

                            if (userData.isEmpty) {
                              return Center();
                            } else {
                              return Text(
                                intl.NumberFormat.currency(
                                  symbol: 'DZD ',
                                  locale: 'fr_FR',
                                  decimalDigits: 2,
                                ).format(userData['coins']),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  background: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        colors: [Colors.transparent, Colors.black],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.darken,
                    child: Consumer<DataProvider>(
                      builder: (context, dataProvider, child) {
                        final userData = dataProvider.currentUserData;

                        if (userData.isEmpty) {
                          return Center();
                        } else {
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: userData['timeline'] ??
                                'https://source.unsplash.com/random?sig=20*3+1',
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.black45,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height / 9,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Current Account',
                                style: TextStyle(
                                  color: _color,
                                ),
                              ),
                              Consumer<DataProvider>(
                                builder: (context, dataProvider, child) {
                                  final userData = dataProvider.currentUserData;

                                  if (userData.isEmpty) {
                                    return Center();
                                  } else {
                                    return Text(
                                      NumberFormat.currency(
                                        symbol: 'DZD',
                                        decimalDigits: 2,
                                        locale:
                                            'fr_FR', // Utilisez la locale appropriée pour votre format
                                      ).format(userData['coins']),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: _color,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Lottie.asset(
                  'assets/lotties/animation_lmtavzq3.json',
                  // repeat: false,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text('Mes Transactions',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      )),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final transactionData =
                        transactions[index].data() as Map<String, dynamic>;
                    final receiverUserId = transactionData['receiverUserId'];
                    final senderUserId = transactionData['senderUserId'];

                    final isCurrentUserTransaction =
                        senderUserId == user.uid || receiverUserId == user.uid;

                    if (!isCurrentUserTransaction) {
                      return SizedBox.shrink();
                    }

                    return FutureBuilder(
                      future: dataProvider.fetchScannedUserData(
                          receiverUserId == user.uid
                              ? senderUserId
                              : receiverUserId),
                      builder: (context, userDataSnapshot) {
                        if (userDataSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            child: ListTile(
                              title: Text(
                                  'Transaction #${transactions[index].id}'),
                              subtitle: Text('Transaction #$receiverUserId'),
                              trailing: PriceWidget(
                                price: transactionData['amount'],
                              ),
                            ),
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                          );
                        }

                        if (userDataSnapshot.hasError) {
                          return ListTile(
                            title:
                                Text('Transaction #${transactions[index].id}'),
                            subtitle: Text('Transaction #$receiverUserId'),
                            trailing: PriceWidget(
                              price: transactionData['amount'],
                            ),
                          );
                        }

                        final userData =
                            userDataSnapshot.data as Map<String, dynamic>;
                        final displayName = userData['displayName'];
                        final email = userData['email'];
                        final coins = userData['coins'];

                        return ListTile(
                          dense: true,
                          leading: Container(
                            width: 70,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userData['avatar']),
                                ),
                                receiverUserId == user.uid
                                    ? Icon(Icons.arrow_upward,
                                        color: Colors.green)
                                    : senderUserId == user.uid
                                        ? Icon(Icons.arrow_downward,
                                            color: Colors.red)
                                        : Icon(Icons.arrow_circle_left,
                                            color: Colors.grey),
                              ],
                            ),
                          ),
                          subtitle: Text(
                            dateText(transactionData['timestamp']),
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 13,
                            ),
                          ),
                          title: Text(
                            userData['displayName'].toString().toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            intl.NumberFormat.currency(
                              locale: 'fr_FR',
                              symbol: 'DZD ',
                              decimalDigits: 2,
                            ).format(transactionData['amount']),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: receiverUserId == user.uid
                                  ? Colors.green
                                  : senderUserId == user.uid
                                      ? Colors.red
                                      : Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: transactions.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String dateText(Timestamp? timestamp) {
    if (timestamp != null) {
      final dateTime = timestamp.toDate();
      final dateFormatter = DateFormat('dd MMM yyyy HH:mm');
      return dateFormatter.format(dateTime);
    } else {
      return '';
    }
  }
}

// class Historique extends StatelessWidget {
//   const Historique({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<DataProvider>(context, listen: false);
//     final User? user = FirebaseAuth.instance.currentUser;
//     // final userData = dataProvider.currentUserData;
//     // final coins =
//     //     userData['coins'] as num; // Assurez-vous que 'coins' est un nombre
//     Provider.of<DataProvider>(context, listen: false).fetchCurrentUserData();
//     Provider.of<DataProvider>(context, listen: false)
//         .fetchScannedUserData(user!.uid);
//     return Scaffold(
//       appBar: AppBar(
//         title: Consumer<DataProvider>(
//           builder: (context, dataProvider, child) {
//             final userData = dataProvider.currentUserData;
//
//             if (userData.isEmpty) {
//               // Display a loading indicator while data is being fetched.
//               return Center(
//                   //child: CircularProgressIndicator(),
//                   );
//             } else {
//               return AnimatedFlipCounter(
//                 value: userData[
//                     'coins'], // Utilisez la partie entière de priceValue.
//                 prefix: "DZD ",
//                 textStyle: TextStyle(
//                   fontFamily: 'OSWALD',
//                   color: Colors.green,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverList(
//               delegate: SliverChildListDelegate([
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('transactions')
//                   //.where('senderUserId', isEqualTo: user?.uid)
//                   .orderBy('timestamp',
//                       descending: true) // Tri par timestamp décroissant
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//
//                 if (snapshot.hasError) {
//                   return Center(
//                     child:
//                         Text('Une erreur s\'est produite : ${snapshot.error}'),
//                   );
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child:
//                         Lottie.asset('assets/lotties/animation_lmqwf1by.json'),
//                   );
//                   //Center(child: Text('Aucune transaction trouvée.'));
//                 }
//
//                 final transactions = snapshot.data!.docs;
// // Tri des transactions par date (timestamp)
// //           transactions.sort((a, b) {
// //             final timestampA = a['timestamp'] as Timestamp;
// //             final timestampB = b['timestamp'] as Timestamp;
// //             return timestampB.compareTo(
// //                 timestampA); // Tri décroissant (le plus récent en premier)
// //           });
//                 return ListView.builder(
//                   itemCount: transactions.length,
//                   itemBuilder: (context, index) {
//                     final transactionData =
//                         transactions[index].data() as Map<String, dynamic>;
//
//                     final receiverUserId = transactionData['receiverUserId'];
//
//                     final senderUserId = transactionData['senderUserId'];
//
//                     // Vérifiez si le current user est soit le senderUserId ou le receiverUserId
//                     final isCurrentUserTransaction =
//                         senderUserId == user?.uid ||
//                             receiverUserId == user?.uid;
//
//                     if (!isCurrentUserTransaction) {
//                       // Si ce n'est pas la transaction de l'utilisateur actuel, sautez-la
//                       return SizedBox.shrink();
//                     }
//                     return FutureBuilder(
//                       future: dataProvider.fetchScannedUserData(receiverUserId),
//                       builder: (context, userDataSnapshot) {
//                         if (userDataSnapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Shimmer.fromColors(
//                             child: ListTile(
//                                 title: Text(
//                                     'Transaction #${transactions[index].id}'),
//                                 subtitle: Text('Transaction #$receiverUserId'),
//                                 trailing: PriceWidget(
//                                   price: transactionData['amount'],
//                                 )
//                                 // Text('Montant: ${transactionData['amount']}'),
//                                 ),
//                             baseColor: Colors.grey[300]!,
//                             highlightColor: Colors.grey[100]!,
//                           );
//                         }
//
//                         if (userDataSnapshot.hasError) {
//                           return ListTile(
//                               title: Text(
//                                   'Transaction #${transactions[index].id}'),
//                               subtitle: Text('Transaction #$receiverUserId'),
//                               trailing: PriceWidget(
//                                 price: transactionData['amount'],
//                               )
//                               // Text('Montant: ${transactionData['amount']}'),
//                               );
//                         }
//
//                         final userData =
//                             userDataSnapshot.data as Map<String, dynamic>;
//                         final displayName = userData['displayName'];
//                         final email = userData['email'];
//                         final coins = userData['coins'];
//
//                         return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: NetworkImage(userData['avatar']),
//                             ),
//                             subtitle:
//                                 // Column(
//                                 //   children: [
//                                 Text(
//                               dateText(transactionData['timestamp']),
//                               //'Transaction #${transactions[index].id}'.toUpperCase(),
//                               style: TextStyle(
//                                   color: Colors.black45, fontSize: 13),
//                             ),
//                             // Text('Transaction #$receiverUserId'),
//                             //   ],
//                             // ),
//                             title: Text(
//                               userData['displayName'].toString().toUpperCase(),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             trailing: Text(
//                               intl.NumberFormat.currency( locale:
//                                                 'fr_FR',
//                                 symbol: 'DZD ',
//                                 decimalDigits: 2,
//                               ).format(transactionData['amount']),
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             )
//
//                             //Text('Montant: ${transactionData['amount']}'),
//                             );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ])),
//         ],
//       ),
//     );
//   }
//
//   String dateText(Timestamp? timestamp) {
//     if (timestamp != null) {
//       final dateTime = timestamp.toDate(); // Convertir Timestamp en DateTime
//       final dateFormatter =
//           DateFormat('dd MMM yyyy HH:mm'); // Format de date souhaité
//       return dateFormatter.format(dateTime);
//     } else {
//       return ''; // Retourne une chaîne vide si le timestamp est null
//     }
//   }
// }
