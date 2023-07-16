import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateButton extends StatelessWidget {
  Future<void> updateDocuments() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String documentId = documentSnapshot.id;

        int currentLikes = documentSnapshot['like'];
        int currentViews = documentSnapshot['views'];

        // Mise à jour des attributs
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(documentId)
            .update({
          'like': currentLikes + 1,
          'views': currentViews + 1,
        });
      }

      print('Documents updated successfully!');
    } catch (e) {
      print('Error updating documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: updateDocuments,
      child: Text('Update Documents'),
    );
  }
}
