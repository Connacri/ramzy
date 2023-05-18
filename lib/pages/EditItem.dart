import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ramzy/map/LocationAppExample.dart';
import 'package:ramzy/pages/classes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ramzy/pages/itemDetails.dart';

class EditItem extends StatefulWidget {
  EditItem({required this.itemId, required this.itemData});

  final String itemId;
  final Map itemData;

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController =
      TextEditingController(text: widget.itemData['Description']);
  late TextEditingController _itemController =
      TextEditingController(text: widget.itemData['item']);
  late TextEditingController _priceController =
      TextEditingController(text: widget.itemData['price'].toString());
  late TextEditingController _phoneController =
      TextEditingController(text: widget.itemData['phone'].toString());

  bool _isLoading = false;
  String _typeSelected = '';
  String _categoSelected = '';
  late int selectedRadio;

  @override
  void initState() {
    super.initState();
    //  _getItemsA();
    _itemController.text = widget.itemData['item'];
    _priceController.text = widget.itemData['price'].toString();
    _descriptionController.text = widget.itemData['Description'];
    _phoneController.text = widget.itemData['phone'].toString();
    selectedRadio = 0;
    _typeSelected = widget.itemData['type'];
    _categoSelected = widget.itemData['category'].toString();
    print(_typeSelected);
    print(_categoSelected);
    getAddressFromLatLng(widget.itemData['position'].latitude,
        widget.itemData['position'].longitude);
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

  Future<void> _updateItem(geoPoint) async {
    cloud.GeoPoint geoPoint =
        cloud.GeoPoint(notifier.value!.latitude, notifier.value!.longitude);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final itemMap = {
        'category': _categoSelected,
        'type': _typeSelected,
        'Description': _descriptionController.text,
        'item': _itemController.text,
        'price': double.parse(_priceController.text),
        'phone': int.parse(_phoneController.text),
        'position': geoPoint,
      };
      await cloud.FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.itemId)
          .update(itemMap);
      //Navigator.of(context).pop();
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
      await cloud.FirebaseFirestore.instance
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
  late bool isSelectedCatego = false;
  late bool isSwitched = false;

  // @override
  // // Widget _buildLocationVente(String locavente, _typeSelected) {
  // //   _typeSelected == 'vente' ? isSelected = true : isSelected = false;
  // //   return ElevatedButton.icon(
  // //     onPressed: () {
  // //       setState(() {
  // //         _locationventeSelected = locavente;
  // //         print(locavente.toString());
  // //       });
  // //     },
  // //
  // //     style: ButtonStyle(
  // //         animationDuration: const Duration(milliseconds: 500),
  // //         backgroundColor: _locationventeSelected == locavente
  // //             ? MaterialStateProperty.all(Colors.green)
  // //             : null, //MaterialStateProperty.all(Colors.greenAccent),
  // //         foregroundColor: _locationventeSelected == locavente
  // //             ? MaterialStateProperty.all(Colors.white)
  // //             : null),
  // //     icon: _locationventeSelected == locavente
  // //         ? const Icon(Icons.check)
  // //         : Container(), //Icon(Icons.check_box_outline_blank),
  // //     label: Text(
  // //       locavente.toUpperCase(), // == false ? 'vente' : 'location',
  // //       style: const TextStyle(
  // //         fontSize: 18,
  // //       ),
  // //     ),
  // //   );
  // // }
  // Widget _buildLocationVente(String locavente, _typeSelected) {
  //   return ElevatedButton.icon(
  //     onPressed: () {
  //       isSelected = true;
  //       setState(() {
  //         _locationventeSelected = locavente;
  //         print(locavente.toString());
  //         print(_locationventeSelected.toString());
  //       });
  //     },
  //     style: ButtonStyle(
  //         animationDuration: const Duration(milliseconds: 500),
  //         backgroundColor: _locationventeSelected == locavente
  //             ? MaterialStateProperty.all(Colors.green)
  //             : null, //MaterialStateProperty.all(Colors.greenAccent),
  //         foregroundColor: _locationventeSelected == locavente
  //             ? MaterialStateProperty.all(Colors.white)
  //             : null),
  //     icon: _locationventeSelected == locavente
  //         ? const Icon(Icons.check)
  //         : Container(),
  //     label: Text(
  //       locavente.toUpperCase(),
  //       style: const TextStyle(
  //         fontSize: 15,
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget _buildType(String catego) {
    return InkWell(
      child: Container(
        //height: 45,
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          color: _categoSelected == catego ? Colors.green : Colors.orangeAccent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: _categoSelected == catego
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      catego,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  catego,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
      onTap: () {
        isSelectedCatego = true;
        setState(() {
          _categoSelected = catego;
          print(_categoSelected);
        });
      },
    );
  }

  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks.first;
      return "${place.locality}, ${place.country}"; //${place.street}, ${place.postalCode},
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Item'),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PhotoEditor(
                          documentId: widget.itemId,
                        ))),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                          child: SizedBox(
                            height: 35,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildType('Hotel'),
                                const SizedBox(width: 5),
                                _buildType('Residence'),
                                const SizedBox(width: 5),
                                _buildType('Agence'),
                                const SizedBox(width: 5),
                                _buildType('Autres'),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                isSelected = true;
                                setState(() {
                                  _typeSelected = 'vente';
                                  print(_typeSelected);
                                });
                              },
                              style: ButtonStyle(
                                  animationDuration:
                                      const Duration(milliseconds: 500),
                                  backgroundColor: _typeSelected == 'vente'
                                      ? MaterialStateProperty.all(Colors.green)
                                      : null, //MaterialStateProperty.all(Colors.greenAccent),
                                  foregroundColor: _typeSelected == 'vente'
                                      ? MaterialStateProperty.all(Colors.white)
                                      : null),
                              icon: _typeSelected == 'vente'
                                  ? const Icon(Icons.check)
                                  : Container(),
                              label: Text(
                                'vente'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                isSelected = true;
                                setState(() {
                                  _typeSelected = 'location';
                                  print(_typeSelected);
                                });
                              },
                              style: ButtonStyle(
                                  animationDuration:
                                      const Duration(milliseconds: 500),
                                  backgroundColor: _typeSelected == 'location'
                                      ? MaterialStateProperty.all(Colors.green)
                                      : null, //MaterialStateProperty.all(Colors.greenAccent),
                                  foregroundColor: _typeSelected == 'location'
                                      ? MaterialStateProperty.all(Colors.white)
                                      : null),
                              icon: _typeSelected == 'location'
                                  ? const Icon(Icons.check)
                                  : Container(),
                              label: Text(
                                'location'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(child: Text('Modifier La Localisation')),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ValueListenableBuilder<GeoPoint?>(
                                  valueListenable: notifier,
                                  builder: (ctx, px, child) {
                                    return FutureBuilder<String>(
                                      future: notifier.value == null
                                          ? getAddressFromLatLng(
                                              widget.itemData['position']
                                                  .latitude,
                                              widget.itemData['position']
                                                  .longitude)
                                          : getAddressFromLatLng(
                                              px!.latitude, px.longitude),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(snapshot.data!);
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Erreur: ${snapshot.error}');
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var p = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (ctx) => SearchPage()));
                                  if (p != null) {
                                    setState(
                                      () => notifier.value = p as GeoPoint,
                                    );
                                  }
                                  print(notifier.value);
                                },
                                icon: Icon(FontAwesomeIcons.location),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Item',
                            hintStyle: TextStyle(color: Colors.black26),
                            fillColor: Colors.blue.shade50,
                            hintText: 'Item',
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.all(15),
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
                          decoration: InputDecoration(
                            labelText: 'Price',
                            hintStyle: TextStyle(color: Colors.black26),
                            fillColor: Colors.blue.shade50,
                            hintText: 'Price',
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.all(15),
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
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            hintStyle: TextStyle(color: Colors.black26),
                            fillColor: Colors.blue.shade50,
                            hintText: 'Phone',
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.all(15),
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
                          decoration: InputDecoration(
                            //label: Text('Description'),
                            labelText: 'Description',

                            hintStyle: TextStyle(color: Colors.black26),
                            fillColor: Colors.blue.shade50,
                            hintText: 'Titre',
                            border: InputBorder.none,
                            filled: true,
                            contentPadding: EdgeInsets.all(15),
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
                          onPressed: _isLoading
                              ? null
                              : () => _updateItem(notifier)
                                  .whenComplete(
                                      () => Navigator.of(context).pop())
                                  .then((value) => Navigator.of(context).pop()),
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Publier'),
                        ),
                        // ElevatedButton(
                        //   onPressed:
                        //       _isLoading ? null : () => _updateItem(notifier),
                        //   child: _isLoading //Text('Save Changes'),
                        //       ? Center(
                        //           child: CircularProgressIndicator(),
                        //         )
                        //       : const Text('Publier'),
                        // ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _deleteItem,
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: Text('Delete Item'),
                        ),
                        Container(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}

class PhotoEditor extends StatefulWidget {
  final String documentId;

  PhotoEditor({required this.documentId});

  @override
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {
  late Stream<List<String>> photosStream;

  @override
  void initState() {
    super.initState();
    photosStream = getPhotosStream();
  }

  Stream<List<String>> getPhotosStream() {
    return cloud.FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.documentId)
        .snapshots()
        .map((snapshot) {
      return List<String>.from(snapshot.data()!['imageUrls']);
    });
  }

  void addPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    );

    if (pickedFile != null) {
      // Téléchargement de l'image dans Firebase Storage
      String imageName = DateTime.now().toString() + '.jpg';
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child(imageName);
      firebase_storage.UploadTask uploadTask =
          ref.putFile(File(pickedFile.path));
      firebase_storage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Mise à jour de la liste des photos dans Firestore
      cloud.FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.documentId)
          .update({
        'imageUrls': cloud.FieldValue.arrayUnion([imageUrl])
      });
    }
  }

  void removePhoto(int index, String photoUrl) {
    // Suppression de l'image dans Firebase Storage
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.refFromURL(photoUrl);
    ref.delete();

    // Mise à jour de la liste des photos dans Firestore
    cloud.FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.documentId)
        .update({
      'imageUrls': cloud.FieldValue.arrayRemove([photoUrl])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Éditeur de photos'),
      ),
      body: StreamBuilder<List<String>>(
        stream: photosStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> photos = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 1 / 1,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0),
                      itemCount: photos.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: CachedNetworkImage(
                                    imageUrl: photos[index],
                                    fit: BoxFit.cover,
                                  )),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  removePhoto(index, photos[index]);
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                photos.length >= 4
                    ? Container()
                    : ElevatedButton(
                        child: Text('Ajouter une photo'),
                        onPressed: () {
                          addPhoto();
                        },
                      ),
                Container(
                  height: 100,
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Une erreur s\'est produite : ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
