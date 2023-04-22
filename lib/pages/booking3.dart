import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:intl/intl.dart';

class HotelManagementPage extends StatefulWidget {
  @override
  _HotelManagementPageState createState() => _HotelManagementPageState();
}

class _HotelManagementPageState extends State<HotelManagementPage> {
  final ScrollController scrollController = ScrollController();
  CollectionReference _hotelCollection =
      FirebaseFirestore.instance.collection('Products');

  CollectionReference get hotelCollection => _hotelCollection;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des réservations d\'hôtel'),
      ),
      body: PaginateFirestore(
        query: hotelCollection.orderBy('dateDebut'),
        isLive: true,
        // header: Container(
        //   height: 60.0,
        //   child: _buildHeader(),
        // ),
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (BuildContext, DocumentSnapshot, int) {
          var data = DocumentSnapshot[int].data() as Map?;
          final chambre = data!['likes'].toString() ?? '';
          final visiteur = data['item'] ?? 'non';
          final dateDebut = data['dateDebut'] as Timestamp?;
          final dateFin = data['dateFin'] as Timestamp?;

          return _buildRow(chambre, visiteur, dateDebut, dateFin);
        },
        // footer: Container(
        //   height: 60.0,
        // ),
        onError: (error) {
          return Center(
            child: Text('Une erreur s\'est produite'),
          );
        },
        itemsPerPage: 10,
        initialLoader: Center(
          child: CircularProgressIndicator(),
        ),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollController: scrollController,
      ),
    );
  }

  // Construire l'en-tête de la table
  Widget _buildHeader() {
    // Créer une liste de widgets pour les mois à afficher dans l'en-tête
    final now = DateTime.now();
    final months = List.generate(
      12,
      (index) => Text(
        '${_getMonthName(now.month + index)} ${now.year}',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Ajouter un conteneur vide pour l'emplacement de la chambre
    months.insert(
      0,
      Text(''),
    );

    // Ajouter un conteneur vide pour l'emplacement de la date de début
    months.insert(
      1,
      Text(''),
    );

    // Ajouter un conteneur vide pour l'emplacement de la date de fin
    months.add(
      Text(''),
    );

    // Retourner une ligne avec tous les widgets de l'en-tête
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: months,
      ),
    );
  }

  // Construire une ligne pour chaque réservation
  Widget _buildRow(String chambre, String visiteur, Timestamp? dateDebut,
      Timestamp? dateFin) {
    // Créer une liste de widgets pour les cellules de la ligne
    final cells = <Widget>[
      Container(
        width: 40.0,
        child: Text(
          chambre,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
        width: 40.0,
        child: Text(
          visiteur,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

// Ajouter une cellule pour chaque mois, avec une barre colorée pour les dates de réservation
    final now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      final firstDayOfMonth = DateTime(now.year, now.month + i, 1);
      final lastDayOfMonth = DateTime(now.year, now.month + i + 1, 0);
      final reservations = <Widget>[];

      // Vérifier si la réservation est dans le mois en cours
      if (dateDebut != null && dateFin != null) {
        final reservationStart = DateTime.fromMillisecondsSinceEpoch(
            dateDebut.millisecondsSinceEpoch);
        final reservationEnd =
            DateTime.fromMillisecondsSinceEpoch(dateFin.millisecondsSinceEpoch);

        if (reservationStart.isBefore(lastDayOfMonth) &&
            reservationEnd.isAfter(firstDayOfMonth)) {
          final start = reservationStart.isAfter(firstDayOfMonth)
              ? reservationStart
              : firstDayOfMonth;
          final end = reservationEnd.isBefore(lastDayOfMonth)
              ? reservationEnd
              : lastDayOfMonth;

          final duration = end.difference(start).inDays;
          final startOffset = start.difference(firstDayOfMonth).inDays;
          final endOffset = end.difference(firstDayOfMonth).inDays;
          final color = _getColorForChambre(chambre);

          reservations.add(
            Container(
              width: 40.0,
              height: duration * 20.0,
              margin: EdgeInsets.only(top: startOffset * 20.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          );
        }
      }

      // Ajouter la liste de réservations pour le mois en cours à la liste de cellules
      cells.add(
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: reservations,
          ),
        ),
      );
    }

// Retourner une ligne avec toutes les cellules
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: cells,
      ),
    );
  }

// Obtenir le nom du mois correspondant au numéro de mois
  String _getMonthName(int month) {
    switch (month % 12) {
      case 0:
        return 'Décembre';
      case 1:
        return 'Janvier';
      case 2:
        return 'Février';
      case 3:
        return 'Mars';
      case 4:
        return 'Avril';
      case 5:
        return 'Mai';
      case 6:
        return 'Juin';
      case 7:
        return 'Juillet';
      case 8:
        return 'Août';
      case 9:
        return 'Septembre';
      case 10:
        return 'Octobre';
      case 11:
        return 'Novembre';
      default:
        return '';
    }
  }

// Obtenir la couleur correspondant à la chambre
  Color _getColorForChambre(String chambre) {
    switch (chambre) {
      case 'Chambre 1':
        return Colors.red;
      case 'Chambre2':
        return Colors.green;
      case 'Chambre3':
        return Colors.blue;
      case 'Chambre4':
        return Colors.orange;
      case 'Chambre5':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

// Écran principal de l'application
class HomePage extends StatelessWidget {
  final _query = FirebaseFirestore.instance
      .collection('Products')
      .orderBy('dateDebut', descending: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des chambres d\'hôtel'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Calendrier des réservations',
            //       style: TextStyle(
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => AjouterReservationPage(),
            //           ),
            //         );
            //       },
            //       child: Text('Ajouter une réservation'),
            //     ),
            //   ],
            // ),
            SizedBox(height: 16.0),
            Expanded(
              child: PaginateFirestore(
                query: _query,
                itemBuilder: (BuildContext, DocumentSnapshot, int) {
                  var data = DocumentSnapshot[int].data() as Map?;
                  return ReservationRow(
                    reservation: DocumentSnapshot[int],
                  );
                },
                onError: (error) {
                  return Center(
                    child: Text('Erreur de chargement des réservations'),
                  );
                },
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemsPerPage: 10,
                itemBuilderType: PaginateBuilderType.listView,
                initialLoader: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Écran pour ajouter une nouvelle réservation
// class AjouterReservationPage extends StatefulWidget {
//   @override
//   _AjouterReservationPageState createState() => _AjouterReservationPageState();
// }

// class _AjouterReservationPageState extends State<AjouterReservationPage> {
//   final _chambreController = TextEditingController();
//   final _visiteurController = TextEditingController();
//   DateTime? _dateDebut;
//   DateTime? _dateFin;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ajouter une réservation'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _chambreController,
//                 decoration: InputDecoration(labelText: 'Chambre'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Veuillez entrer le nom de la chambre';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _visiteurController,
//                 decoration: InputDecoration(labelText: 'Visiteur'),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Veuillez entrer le nom du visiteur';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Date de début : ${_dateDebut != null ? DateFormat('dd/MM/yyyy').format(_dateDebut!) : 'Choisir une date'}',
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       showDatePicker(
//                         context: context,
//                         initialDate: _dateDebut ?? DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime.now().add(Duration(days: 365)),
//                       ).then((value) {
//                         setState(() {
//                           _dateDebut = value;
//                         });
//                       });
//                     },
//                     child: Text('Choisir'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Date de fin : ${_dateFin != null ? DateFormat('dd/MM/yyyy').format(_dateFin!) : 'Choisir une date'}',
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       showDatePicker(
//                         context: context,
//                         initialDate: _dateFin ?? DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime.now().add(Duration(days: 365)),
//                       ).then((value) {
//                         setState(() {
//                           _dateFin = value;
//                         });
//                       });
//                     },
//                     child: Text('Choisir'),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate() &&
//                       _dateDebut != null &&
//                       _dateFin != null) {
//                     FirebaseFirestore.instance.collection('Products').add({
//                       'chambre': _chambreController.text,
//                       'visiteur': _visiteurController.text,
//                       'dateDebut': _dateDebut!.millisecondsSinceEpoch,
//                       'dateFin': _dateFin!.millisecondsSinceEpoch,
//                     }).then((value) {
//                       Navigator.of(context).pop();
//                     });
//                   }
//                 },
//                 child: Text('Enregistrer'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ReservationRow extends StatelessWidget {
  final DocumentSnapshot reservation;

  ReservationRow({required this.reservation});
  @override
  Widget build(BuildContext context) {
    final chambre = reservation['likes'];
    final visiteur = reservation['item'];
    final dateDebut = reservation['dateDebut'] != null
        ? DateTime.fromMillisecondsSinceEpoch(reservation['dateDebut'])
        : null;
    final dateFin = reservation['dateFin'] != null
        ? DateTime.fromMillisecondsSinceEpoch(reservation['dateFin'])
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Affichage de la chambre
          Expanded(
            flex: 1,
            child: Text(
              'Chambre $chambre',
              style: TextStyle(fontSize: 18),
            ),
          ),

          // Affichage des dates de début et de fin
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dateDebut != null
                      ? DateFormat('dd/MM/yyyy').format(dateDebut)
                      : '',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  dateFin != null
                      ? DateFormat('dd/MM/yyyy').format(dateFin)
                      : '',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Affichage du visiteur
          Expanded(
            flex: 1,
            child: Text(
              visiteur ?? '',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
