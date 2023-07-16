import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('Voulez-vous vraiment supprimer votre compte ?'),
              actions: [
                TextButton(
                  child: Text('Annuler'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Supprimer'),
                  onPressed: () {
                    deleteUserAccount(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(
        'Supprimer mon compte',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Future<void> deleteUserAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Check if documents exist in the 'Products' collection
        final querySnapshotProducts = await FirebaseFirestore.instance
            .collection('Products')
            .where('userID', isEqualTo: userId)
            .get();

        if (querySnapshotProducts.docs.isNotEmpty) {
          for (final doc in querySnapshotProducts.docs) {
            try {
              transaction.delete(doc.reference);
            } catch (e) {
              print('Failed to delete document in "Products" collection: $e');
            }
          }
        }

        // Check if documents exist in the 'Instalives' collection
        final querySnapshotInsta = await FirebaseFirestore.instance
            .collection('Instalives')
            .where('userID', isEqualTo: userId)
            .get();

        if (querySnapshotInsta.docs.isNotEmpty) {
          for (final doc in querySnapshotInsta.docs) {
            try {
              transaction.delete(doc.reference);
            } catch (e) {
              print('Failed to delete document in "Instalives" collection: $e');
            }
          }
        }

        // Delete Firestore document in the 'Users' collection
        final documentRef =
            FirebaseFirestore.instance.collection('Users').doc(userId);
        transaction.delete(documentRef);

        // Delete user account
        await user.delete();

        // Sign out user and navigate back to the first page
        await FirebaseAuth.instance.signOut();
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });

      print(
          'User account, Firestore documents, and collection documents deleted successfully');
    } catch (e) {
      print('Failed to delete user account and Firestore documents: $e');
    }
  }
}
