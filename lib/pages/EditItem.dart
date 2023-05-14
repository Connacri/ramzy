import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ramzy/pages/classes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditItem extends StatefulWidget {
  EditItem({required this.itemId, required this.itemData});

  final String itemId;
  final Map itemData;

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _itemController;
  late TextEditingController _priceController;
  late TextEditingController _phoneController;

  bool _isLoading = false;
  String _typeSelected = '';
  String _locationventeSelected = '';
  late int selectedRadio;

  @override
  void initState() {
    super.initState();
    //  _getItemsA();

    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    _itemController = TextEditingController();
    _priceController = TextEditingController();
    _phoneController = TextEditingController();
    _typeSelected = '';
    _locationventeSelected = widget.itemData['category'];
    selectedRadio = 0;
  }

  // Future<void> _getItemsA() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('Products')
  //         .doc(widget.itemId)
  //         .get();
  //     final data = snapshot.data() as Map;
  //     final item = ItemsA.fromJson(data);
  //     //  _categoryController = TextEditingController(text: item.category);
  //     _codeController = TextEditingController(text: item.code);
  //     _codebarController = TextEditingController(text: item.codebar);
  //     _descriptionController = TextEditingController(text: item.description);
  //     _modelController = TextEditingController(text: item.model);
  //     _oldStockController =
  //         TextEditingController(text: item.oldStock.toString());
  //     _origineController = TextEditingController(text: item.origine);
  //     _prixAchatController =
  //         TextEditingController(text: item.prixAchat.toString());
  //     _prixVenteController =
  //         TextEditingController(text: item.prixVente.toString());
  //     _sizeController = TextEditingController(text: item.size);
  //     _stockController = TextEditingController(text: item.stock.toString());
  //     _userController = TextEditingController(text: item.user);
  //   } catch (error) {
  //     print('Error getting item data: $error');
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final itemMap = {
        'category': _categoryController.text,
        'Description': _descriptionController.text,
        'item': _itemController.text,
        'price': double.parse(_priceController.text),
        'phone': _phoneController.text,
      };
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.itemId)
          .update(itemMap);
      Navigator.of(context).pop();
    } catch (error) {
      print('Error updating item data: $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update item data')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.itemId)
          .delete();
      Navigator.of(context).pop();
    } catch (error) {
      print('Error deleting item data: $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete item data')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late bool isSelected = false;
  late bool isSwitched = false;

  @override
  Widget _buildLocationVente(String locavente) {
    return ElevatedButton.icon(
      onPressed: () {
        _locationventeSelected == 'vente'
            ? isSelected = true
            : isSelected = false;
        setState(() {
          _locationventeSelected = locavente;
          print(locavente.toString());
        });
      },

      style: ButtonStyle(
          animationDuration: const Duration(milliseconds: 500),
          backgroundColor: _locationventeSelected == locavente
              ? MaterialStateProperty.all(Colors.green)
              : null, //MaterialStateProperty.all(Colors.greenAccent),
          foregroundColor: _locationventeSelected == locavente
              ? MaterialStateProperty.all(Colors.white)
              : null),
      icon: _locationventeSelected == locavente
          ? const Icon(Icons.check)
          : Container(), //Icon(Icons.check_box_outline_blank),
      label: Text(
        locavente.toUpperCase(), // == false ? 'vente' : 'location',
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _categoryController.text = widget.itemData['category'];
    _itemController.text = widget.itemData['item'];
    _priceController.text = widget.itemData['price'].toString();
    _descriptionController.text = widget.itemData['Description'];
    _phoneController.text = widget.itemData['phone'].toString();
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Item'),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PhotoList(widget.itemData['imageUrls']),
                    )),
                icon: Icon(Icons.photo)),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Category', filled: false),
                          controller: _categoryController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a category';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildLocationVente('vente'),
                            )),
                            // const SizedBox(width: 10),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildLocationVente('location'),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black26),
                            fillColor: Colors.white,
                            hintText: 'Titre',
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.all(5),
                          ),
                          controller: _itemController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Item';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black26),
                            fillColor: Colors.white,
                            hintText: 'Prix',
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.all(5),
                          ),
                          controller: _priceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black26),
                            fillColor: Colors.white,
                            hintText: 'Phone',
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.all(5),
                          ),
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the Phone';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black26),
                            fillColor: Colors.white,
                            hintText: 'Description',
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.all(5),
                          ),
                          maxLines: 5,
                          controller: _descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _updateItem,
                          child: Text('Save Changes'),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _deleteItem,
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: Text('Delete Item'),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}

class PhotoList extends StatelessWidget {
  final List<String> photoUrls;

  PhotoList(this.photoUrls);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photoUrls.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(photoUrls[index]),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deletePhoto(context, photoUrls[index]);
            },
          ),
        );
      },
    );
  }

  void _deletePhoto(BuildContext context, String photoUrl) async {
    // Supprime la photo de Firebase Storage
    await FirebaseStorage.instance.refFromURL(photoUrl).delete();

    // Supprime l'URL de la photo de Firestore
    await FirebaseFirestore.instance
        .collection('photos')
        .doc('document_id')
        .update({
      'photoUrls': FieldValue.arrayRemove([photoUrl])
    });

    // Rafraîchit l'interface utilisateur
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La photo a été supprimée avec succès')));
  }
}

class AddPhoto extends StatefulWidget {
  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  File? _imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_imageFile != null) ...[
          Image.file(_imageFile!),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _uploadPhoto(context);
                },
                child: Text('Télécharger'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                  });
                },
                child: Text('Annuler'),
              ),
            ],
          ),
        ] else ...[
          ElevatedButton(
            onPressed: () {
              _selectPhoto(context);
            },
            child: Text('Ajouter une photo'),
          ),
        ],
      ],
    );
  }

  Future<void> _selectPhoto(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Aucune image sélectionnée')));
      }
    });
  }

  Future<void> _uploadPhoto(BuildContext context) async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Aucune image sélectionnée')));
      return;
    }
    final taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child('photos')
        .child(DateTime.now().toString())
        .putFile(_imageFile!);

    final photoUrl = await taskSnapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('photos')
        .doc('document_id')
        .update({
      'photoUrls': FieldValue.arrayUnion([photoUrl])
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('La photo a été téléchargée')));
    setState(() {
      _imageFile = null;
    });
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestion de photos')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('photos')
            .doc('document_id')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final photoUrls =
              List<String>.from(snapshot.data!.get('photoUrls') ?? []);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PhotoList(photoUrls),
              ),
              AddPhoto(),
            ],
          );
        },
      ),
    );
  }
}
