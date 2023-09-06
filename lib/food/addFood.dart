import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ramzy/food/list_food_Models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Adder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PizzaForm(),
    );
  }
}

class PizzaForm extends StatefulWidget {
  @override
  _PizzaFormState createState() => _PizzaFormState();
}

class _PizzaFormState extends State<PizzaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _flavController = TextEditingController();
  final TextEditingController _catController = TextEditingController();
  XFile? _imageFile;
  User? currentUser = FirebaseAuth.instance.currentUser;
  // void _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     final ListFood pizza = ListFood(
  //       item: _itemController.text,
  //       desc: _descriptionController.text,
  //       price: int.parse(_priceController.text),
  //       image: '',
  //       flav: _flavController.text,
  //       cat: _catController.text,
  //       createdAt: Timestamp.now(),
  //       user: currentUser!.uid,
  //       docId: '',
  //     );
  //
  //     if (_imageFile != null) {
  //       Reference storageReference = FirebaseStorage.instance
  //           .ref()
  //           .child('pizza_images/${DateTime.now()}.png');
  //       UploadTask uploadTask =
  //           storageReference.putFile(File(_imageFile!.path));
  //       TaskSnapshot storageTaskSnapshot = await uploadTask;
  //       String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
  //
  //       pizza.image = imageUrl;
  //     }
  //
  //     await FirebaseFirestore.instance.collection('Foods').add({
  //       'item': pizza.item,
  //       'desc': pizza.desc,
  //       'price': pizza.price,
  //       'image': pizza.image,
  //       'flav': pizza.flav,
  //       'cat': pizza.cat,
  //       'createdAt': pizza.createdAt,
  //       'user': pizza.user,
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Pizza added successfully')),
  //     );
  //     _formKey.currentState!.reset();
  //     setState(() {
  //       _imageFile = null;
  //     });
  //   }
  // }
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final ListFood pizza = ListFood(
        item: _itemController.text,
        desc: _descriptionController.text,
        price: int.parse(_priceController.text),
        image: '',
        flav: _flavController.text,
        cat: _catController.text,
        createdAt: Timestamp.now(),
        user: currentUser!.uid,
        docId: '',
      );

      if (_imageFile != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('pizza_images/${DateTime.now()}.png');
        UploadTask uploadTask =
            storageReference.putFile(File(_imageFile!.path));
        TaskSnapshot storageTaskSnapshot = await uploadTask;
        String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

        pizza.image = imageUrl;
      }

      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('Foods').add({
        'item': pizza.item,
        'desc': pizza.desc,
        'price': pizza.price,
        'image': pizza.image,
        'flav': pizza.flav,
        'cat': pizza.cat,
        'createdAt': pizza.createdAt,
        'user': pizza.user,
        'docId': '',
      });

      // Mise à jour de l'objet ListFood avec l'ID du document Firestore
      //pizza.docId = docRef.id;
      await docRef.update({'docId': docRef.id});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pizza added successfully')),
      );
      _formKey.currentState!.reset();
      setState(() {
        _imageFile = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Pizza')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _catController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _flavController,
                decoration: InputDecoration(labelText: 'Flavor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a flavor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage, // Open image picker
                child: Text('Pick an Image'),
              ),
              SizedBox(height: 16.0),
              if (_imageFile != null)
                Image.file(
                  File(_imageFile!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Pizza'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
