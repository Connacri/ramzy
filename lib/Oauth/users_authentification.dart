// import 'package:firebase_admin/firebase_admin.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// void main() async {
//   // Initialisez l'application Firebase Admin SDK avec votre clé privée
//   final app = FirebaseAdmin.instance.initializeApp(
//     AppOptions(
//       credential:
//           FirebaseAdmin.instance.certFromPath('path/to/serviceAccountKey.json'),
//       projectId: 'your-project-id',
//     ),
//   );
//
//   // Récupérer une liste d'utilisateurs
//   final auth = FirebaseAuth.instance(app: app);
//   final users = await auth.listUsers();
//
//   // Parcourir la liste des utilisateurs et imprimer leurs informations
//   for (final user in users.users) {
//     print('User: ${user.uid}, Email: ${user.email}');
//   }
//
//   // Terminer l'application Firebase Admin SDK
//   await app.delete();
// }
