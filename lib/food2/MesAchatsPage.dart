import 'dart:math';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food2/main.dart';

class MesAchatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Achats'),
      ),
      body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: dataProvider.getAllCommandeDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun achat trouvé.'));
          }

          final List<DocumentSnapshot<Map<String, dynamic>>> commandeDocuments =
              snapshot.data!;

          return MesAchatsList(commandeDocuments, dataProvider);
        },
      ),
    );
  }
}

class MesAchatsList extends StatelessWidget {
  final List<DocumentSnapshot<Map<String, dynamic>>> commandeDocuments;
  final DataProvider dataProvider;

  MesAchatsList(this.commandeDocuments, this.dataProvider);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: commandeDocuments.length,
            itemBuilder: (context, index) {
              commandeDocuments.sort((a, b) {
                final DateTime createdAtA = a['createdAt'].toDate() as DateTime;
                final DateTime createdAtB = b['createdAt'].toDate() as DateTime;
                return createdAtB
                    .compareTo(createdAtA); // Trie en ordre décroissant
              });

              final Map<String, dynamic> data =
                  commandeDocuments[index].data()!;
              final double cartTotal = data['cartTotal'] as double;
              final DateTime createdAt = data['createdAt'].toDate() as DateTime;
              final List<Map<String, dynamic>> items =
                  List<Map<String, dynamic>>.from(data['items'] ?? []);

              // Le reste du code reste inchangé...
              Random random = Random();
              int randomIndex = random.nextInt(data['items'].length);
              final DateFormat dateFormatter = DateFormat(
                'EEEE dd/MM/yyyy à HH:mm',
                'fr_FR', // Utilisez 'fr_FR' pour la locale française.
              ); // Format de date souhaité
              final String formattedDate = dateFormatter.format(createdAt);
              final NumberFormat cartTotalFormatter = NumberFormat.currency(
                symbol:
                    'DZD ', // Vous pouvez définir le symbole de la devise ici s'il est nécessaire.
                decimalDigits:
                    2, // Le nombre de chiffres après la virgule que vous voulez afficher.
              );

              final String formattedCartTotal =
                  cartTotalFormatter.format(cartTotal);
              return ListTile(
                leading: CircleAvatar(
                    child: Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                )),
                // Container(
                //   width: 50,
                //   height: 50,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     image: DecorationImage(
                //       fit: BoxFit.cover,
                //       image: data['items'][randomIndex]['image'] == null
                //           ? CachedNetworkImageProvider(
                //               "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg")
                //           : CachedNetworkImageProvider(
                //               data['items'][randomIndex]['image']),
                //     ),
                //   ),
                // ),
                title: Text(
                  'Total Achat : $formattedCartTotal',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Le ' + formattedDate.toString().capitalize(),
                ),
                onTap: () {
                  // Handle the tap on a specific purchase to show the items.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Text('List des Commandes'),
                            Text(
                              'Total Achat : $formattedCartTotal',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Le ' + formattedDate.toString().capitalize(),
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 13),
                            ),
                            Divider()
                          ],
                        ),
                        content: CustomScrollView(
                          // physics: ,
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                                delegate: SliverChildListDelegate([
                              ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final cartItem = items[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: cartItem['image'] == null
                                                  ? CachedNetworkImageProvider(
                                                      "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg")
                                                  : CachedNetworkImageProvider(
                                                      cartItem['image']),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          cartItem['qty'] > 99
                                              ? 'nd'
                                              : cartItem['qty']
                                                  .toString()
                                                  .padLeft(2, '0'),
                                          style: TextStyle(fontSize: 35),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartItem['item'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'DZD ${cartItem['price'].toStringAsFixed(2)}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ])),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        FutureBuilder<double>(
          future: dataProvider.calculateTotalOfAllAchats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }

            final double totalAchats = snapshot.data ?? 0.0;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Total de tous les achats : $totalAchats DZD',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ],
    );
  }
}
