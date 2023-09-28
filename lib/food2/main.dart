import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food2/home.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ramzy/food2/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodHome extends StatelessWidget {
  const FoodHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: MyApp(),
    );
  }
}

class DataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('Foods');
  late SharedPreferences _prefs;
// Add a boolean flag to track whether _prefs has been initialized.
  bool _prefsInitialized = false;

  DataProvider() {
    _initSharedPreferences();
    if (!_prefsInitialized) {
      _initSharedPreferences();
    }
    fetchCategories();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _prefsInitialized = true; // Set the flag to true after initialization.
  }

  Future<void> clearCart() async {
    // Effacez les données de panier en mémoire
    List<Map<String, dynamic>> emptyCart = [];
    saveCart(emptyCart);

    // Effacez les données de panier dans SharedPreferences
    if (_prefsInitialized) {
      await _prefs.remove('cart');
    }

    // Notifiez les auditeurs (les widgets qui écoutent ce fournisseur)
    notifyListeners();
  }

  // Méthode pour récupérer les catégories depuis Firestore (mise en cache)
  List<String> categories = [];

// Méthode pour récupérer les catégories depuis Firestore (mise en cache)
  Future<void> fetchCategories() async {
    if (categories.isNotEmpty) {
      // Si les catégories sont déjà en cache, ne pas effectuer de nouvelle lecture Firestore.
      return;
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _collectionReference.get() as QuerySnapshot<Map<String, dynamic>>;

    final Set<String> uniqueCategories = Set<String>();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      final cat = doc.data()!['cat'] as String;
      if (cat != null && cat.isNotEmpty) {
        uniqueCategories.add(cat);
      }
    }

    categories = uniqueCategories.toList();
    notifyListeners();
    print('//////////////////////////////////////////////////////////////////');
    print(categories);
  }

  Future<List<ListFood2>> getFilteredAndSortedData(String? filter) async {
    Query query = _collectionReference;

    if (filter != null && filter.isNotEmpty) {
      query = query.where('cat', isEqualTo: filter);
    }

    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await query.get() as QuerySnapshot<Map<String, dynamic>>;
    final List<ListFood2> data =
        querySnapshot.docs.map((doc) => ListFood2.fromSnapshot(doc)).toList();

    return data;
  }

  Future<void> addToCart(Map<String, dynamic> item) async {
    if (!_prefsInitialized) {
      await _initSharedPreferences();
    }

    List<String> cart = _prefs.getStringList('cart') ?? [];

    // Serialize the item to JSON and add it as a string to the cart list
    final itemJson = jsonEncode(item); // Sérialisez l'élément en JSON
    cart.add(itemJson);

    await _prefs.setStringList('cart', cart);
    notifyListeners();
  }

  // Future<void> addToFavorites(Map<String, dynamic> item) async {
  //   List<Object> favorites = _prefs.getStringList('favorites') ?? [];
  //
  //   favorites.add(item);
  //   await _prefs.setStringList(
  //       'favorites', favorites.map((e) => e.toString()).toList());
  //   notifyListeners();
  // }

  List<Map<String, dynamic>> getCart() {
    if (!_prefsInitialized) {
      // Wait for initialization to complete.
      // You can choose to return an empty list or handle it differently based on your use case.
      return [];
    }

    List<String> cartStrings = _prefs.getStringList('cart') ?? [];
    List<Map<String, dynamic>> cartItems = [];

    for (String cartString in cartStrings) {
      final Map<String, dynamic> cartItem = jsonDecode(cartString);
      cartItems.add(cartItem);
    }

    return cartItems;
  }

  Future<void> saveCart(List<Map<String, dynamic>> cartItems) async {
    final List<String> cartStrings = cartItems.map((item) {
      return jsonEncode(item); // Convertir chaque article en JSON
    }).toList();

    await _prefs.setStringList('cart', cartStrings);
    notifyListeners();
  }

  List<Map<String, dynamic>> getFavorites() {
    List<String> favoritesStrings = _prefs.getStringList('favorites') ?? [];
    return favoritesStrings
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

// Nouvelle méthode pour obtenir les éléments d'une catégorie spécifique (utilisation du cache Firestore)
  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoryItems(
      String category) {
    return _collectionReference.where('cat', isEqualTo: category).snapshots()
        as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  Future<Map<String, dynamic>> getCurrentUserDocument() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('Users').doc(user.uid).get();

      if (userSnapshot.exists) {
        return userSnapshot.data()!;
      }
    }

    return {};
  }

  Map<String, dynamic> _currentUserData = {};
  Map<String, dynamic> get currentUserData => _currentUserData;

  Future<Map<String, dynamic>> fetchCurrentUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String currentUserId = user.uid;
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('Users').doc(user.uid).get();

      if (userSnapshot.exists) {
        _currentUserData = userSnapshot.data()!;

        notifyListeners();
        return _currentUserData; // Ajoutez cette ligne pour renvoyer les données
      }
    }

    return {}; // Ajoutez cette ligne pour renvoyer un objet vide si les données ne sont pas trouvées
  }

  Stream<QuerySnapshot> getTransactionStream() {
    return FirebaseFirestore.instance.collection('transactions').snapshots();
  }

  ///////////////////////////2///////////////////////////////////////////
  Map<String, dynamic> _scannedUserData = {};
  Map<String, dynamic> get scannedUserData => _scannedUserData;

  Future<Map<String, dynamic>> fetchScannedUserData(String scannedUser) async {
    if (scannedUser != null) {
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('Users').doc(scannedUser).get();

      if (userSnapshot.exists) {
        _scannedUserData = userSnapshot.data()!;

        notifyListeners();
        return _scannedUserData; // Ajoutez cette ligne pour renvoyer les données
      }
    }

    return {}; // Ajoutez cette ligne pour renvoyer un objet vide si les données ne sont pas trouvées
  }

  ///////////////////////////2///////////////////////////////////////////
  // Méthode pour augmenter la quantité d'un article
  void increaseQuantity(int index) {
    List<Map<String, dynamic>> cartItems = getCart();
    if (index >= 0 && index < cartItems.length) {
      cartItems[index]['qty']++;
      saveCart(cartItems);
      notifyListeners();
    }
  }

  // Méthode pour diminuer la quantité d'un article
  void decreaseQuantity(int index) {
    List<Map<String, dynamic>> cartItems = getCart();
    if (index >= 0 && index < cartItems.length) {
      if (cartItems[index]['qty'] > 1) {
        cartItems[index]['qty']--;
        saveCart(cartItems);
        notifyListeners();
      } else {
        // Si la quantité est de 1, supprimez l'article
        removeItemFromCart(index);
      }
    }
  }

  // Méthode pour supprimer complètement un article du panier
  void removeItemFromCart(int index) {
    List<Map<String, dynamic>> cartItems = getCart();
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      saveCart(cartItems);
      notifyListeners();
    }
  }

  // Méthode pour récupérer tous les documents de commande
  Future<List<DocumentSnapshot<Map<String, dynamic>>>>
      getAllCommandeDocuments() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('usersCommande')
              .doc(user.uid)
              .collection('cartsUsers')
              .get();

      return querySnapshot.docs;
    }

    return [];
  }

  // Méthode pour calculer le total de tous les achats
  Future<double> calculateTotalOfAllAchats() async {
    final List<DocumentSnapshot<Map<String, dynamic>>> commandeDocuments =
        await getAllCommandeDocuments();
    double total = 0.0;

    for (final document in commandeDocuments) {
      final Map<String, dynamic> data = document.data()!;
      final double cartTotal = data['cartTotal'] as double;
      total += cartTotal;
    }

    return total;
  }

  Future<void> passerCommande(
      List<Map<String, dynamic>> items, double cartTotal) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Créez un document pour la commande dans la collection "commande"
      final DocumentReference<Map<String, dynamic>> commandeRef =
          FirebaseFirestore.instance.collection('commande').doc();

      // Créez un objet pour représenter la commande
      final Map<String, dynamic> commandeData = {
        'userId': user.uid,
        'items': items,
        'cartTotal': cartTotal,
        'statut': 'En attente', // Vous pouvez définir le statut initial ici
        'timestamp': FieldValue
            .serverTimestamp(), // Pour enregistrer la date et l'heure actuelles du serveur
      };

      // Ajoutez la commande à la collection "commande"
      await commandeRef.set(commandeData);

      // Effacez le panier après avoir passé la commande
      clearCart();

      // Vous pouvez également mettre à jour d'autres informations ou effectuer des actions supplémentaires ici si nécessaire.
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('fr', 'CA'),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Oswald",
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.lightBlue, backgroundColor: Colors.white),
      ),
      home: MonWidget(),
    );
  }
}
