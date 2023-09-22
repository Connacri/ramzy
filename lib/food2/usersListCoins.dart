import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUsersListStream(),
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
              users.sort((a, b) {
                double coinsA = a['coins'] ?? 0.0;
                double coinsB = b['coins'] ?? 0.0;
                return coinsB.compareTo(coinsA); // Trie en ordre décroissant
              });
              return ListTile(
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
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['avatar'] ?? ''),
                ),
                title: Text(displayName),
                subtitle: Text(email),
                trailing: Text(coins.toStringAsFixed(2)),
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
