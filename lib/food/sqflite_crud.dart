import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ramzy/food/list_food_Models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<void> openDb() async {
    if (_database != null && _database!.isOpen) {
      return;
    }
    _database = await openDatabase(
      join(await getDatabasesPath(), 'food_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
        CREATE TABLE foods(
          docId TEXT PRIMARY KEY,
          item TEXT,
          desc TEXT,
          image TEXT,
          price INTEGER,
          cat TEXT,
          flav TEXT,
          createdAt TEXT,
          user TEXT
        )
        ''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertFood(ListFoodSqF food) async {
    await openDb(); // Make sure the database is opened
    await _database!.insert(
      'foods',
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ListFoodSqF>> getFoods() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.query('foods');
    return List.generate(maps.length, (i) {
      return ListFoodSqF.fromMap(maps[i]);
    });
  }

  Stream<List<ListFoodSqF>> getFoodsStream() async* {
    await openDb();
    final streamController = StreamController<List<ListFoodSqF>>();
    final List<Map<String, dynamic>> maps = await _database!.query('foods');
    final foodsList = List.generate(maps.length, (i) {
      return ListFoodSqF.fromMap(maps[i]);
    });

    // Emit the list of foods to the stream
    streamController.sink.add(foodsList);

    yield* streamController.stream;
  }

  Future<void> updateFood(ListFoodSqF food) async {
    await openDb();
    await _database!.update(
      'foods',
      food.toMap(),
      where: 'docId = ?',
      whereArgs: [food.docId],
    );
  }

  Future<void> deleteFood(String docId) async {
    await openDb();
    await _database!.delete(
      'foods',
      where: 'docId = ?',
      whereArgs: [docId],
    );
  }
}

class sqflite_crud extends StatefulWidget {
  @override
  State<sqflite_crud> createState() => _sqflite_crudState();
}

class _sqflite_crudState extends State<sqflite_crud> {
  final dbHelper = DatabaseHelper();

  final _itemController = TextEditingController();

  final _descController = TextEditingController();

  final _imageController = TextEditingController();

  final _priceController = TextEditingController();

  final _catController = TextEditingController();

  final _flavController = TextEditingController();
  List<ListFoodSqF> _foodList = []; // Liste pour stocker les éléments
  @override
  void initState() {
    super.initState();
    dbHelper.getFoodsStream().listen((foods) {
      setState(() {
        _foodList = foods;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Sqflite CRUD Example')),
        body: StreamBuilder<List<ListFoodSqF>>(
          stream: dbHelper.getFoodsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final foods = snapshot.data!;
            return ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return ListTile(
                  title: Text(food.item),
                  subtitle: Text(food.desc),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      dbHelper.deleteFood(food.docId);
                      setState(() {});
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddOrUpdateBottomSheet(context, null);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddOrUpdateBottomSheet(BuildContext context, ListFoodSqF? food) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Item'),
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _catController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _flavController,
                decoration: InputDecoration(labelText: 'Flavor'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (food == null) {
                    final newFood = ListFoodSqF(
                      docId: 'newDocId${_priceController.text}',
                      item: _itemController.text,
                      desc: _descController.text,
                      image: _imageController.text,
                      price: int.parse(_priceController.text),
                      cat: _catController.text,
                      flav: _flavController.text,
                      createdAt: Timestamp.now().toDate().toString(),
                      user: FirebaseAuth.instance.currentUser!.uid,
                    );
                    await dbHelper.insertFood(newFood);
                  } else {
                    food.item = _itemController.text;
                    food.desc = _descController.text;
                    food.image = _imageController.text;
                    food.price = int.parse(_priceController.text);
                    food.cat = _catController.text;
                    food.flav = _flavController.text;
                    await dbHelper.updateFood(food);
                  }
                  Navigator.pop(context);
                  // Mettre à jour la liste après l'ajout ou la mise à jour
                  setState(() {});
                },
                child: Text(food == null ? 'Add' : 'Update'),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// void _showAddOrUpdateBottomSheet(BuildContext context, ListFoodSqF? food) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (BuildContext context) {
//       return SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               food == null ? 'Add Food' : 'Update Food',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             // Build your form fields here
//             // You can use TextFields, Dropdowns, etc.
//             // Use the TextEditingController to manage user input
//             // Example: TextField(controller: _itemController),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 if (food == null) {
//                   // Add new food
//                   // Read values from your TextEditingControllers and create a ListFoodSqF object
//                   // Call dbHelper.insertFood(newFood);
//                 } else {
//                   // Update existing food
//                   // Update values in the existing ListFoodSqF object
//                   // Call dbHelper.updateFood(updatedFood);
//                 }
//                 Navigator.pop(context); // Close bottom sheet
//               },
//               child: Text(food == null ? 'Add' : 'Update'),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
