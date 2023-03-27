// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class FirebaseService {
//   final CollectionReference docProducts =
//       FirebaseFirestore.instance.collection("users");
//   final Reference storageReference = FirebaseStorage.instance.ref();
//
//   Future<void> deleteUserData(String idDoc) async {
//     // Delete the document from Firestore
//     try {
//       await docProducts.doc(idDoc).delete();
//       print("Document with user ID $idDoc deleted from Firestore.");
//     } catch (e) {
//       print("Error deleting document from Firestore: $e");
//     }
//
//     // Delete the picture from Firebase Storage
//     try {
//       await storageReference.child("users/$idDoc/picture.jpg").delete();
//       print("Picture with user ID $idDoc deleted from Firebase Storage.");
//     } catch (e) {
//       print("Error deleting picture from Firebase Storage: $e");
//     }
//   }
// }
