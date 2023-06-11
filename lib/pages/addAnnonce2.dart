import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:path/path.dart' as Path;

import 'package:fluttertoast/fluttertoast.dart';

import '../Oauth/verifi_auth.dart';
import '../pages/Aperçu_Item.dart';

class addAnnonce2 extends StatefulWidget {
  addAnnonce2({Key? key, required this.ccollection, required this.userDoc})
      : super(key: key);
  String ccollection;
  final userDoc;

  @override
  State<addAnnonce2> createState() => _addAnnonce2State();
}

class _addAnnonce2State extends State<addAnnonce2> {
  bool uploading = false;
  int currentStep = 0;

  // final List<XFile> _imagesList = [];
  final List<File> _imagesList = [];
  final multiPicker = ImagePicker();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _phoneCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _likesController = TextEditingController();
  final TextEditingController _telContactController = TextEditingController();
  final TextEditingController _generaleController = TextEditingController();

  //final user = FirebaseAuth.instance.currentUser;
  String _typeSelected = '';
  String _locationventeSelected = '';
  late int selectedRadio;

  double val = 0;
  late firebase_storage.Reference ref;
  final user = FirebaseAuth.instance.currentUser;

  cloud.CollectionReference userRef =
      cloud.FirebaseFirestore.instance.collection('Users');
  // cloud.CollectionReference imgRef =
  // cloud.FirebaseFirestore.instance.collection(widget.ccollection);

  @override
  void initState() {
    super.initState();
    _typeSelected = '';
    _locationventeSelected = '';
    selectedRadio = 0;
    //imgRef = FirebaseFirestore.instance.collection(widget.ccollection);
    userRef = cloud.FirebaseFirestore.instance.collection('Users');
  }

  late bool isSelected = false;
  late bool isSwitched = false;
  String dropdownValue = 'mois';

  final GlobalKey<FormState> _formStepperKey = GlobalKey<FormState>();
  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);

  @override
  Widget _buildLocationVente(String locavente) {
    return ElevatedButton.icon(
      onPressed: () {
        isSelected = true;
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
          fontSize: 15,
        ),
      ),
    );
  }

  @override
  Widget _buildType(String catego) {
    return InkWell(
      child: Container(
        //height: 45,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: _typeSelected == catego
              ? Colors.green
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            catego,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _typeSelected = catego;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    cloud.CollectionReference imgRef =
        cloud.FirebaseFirestore.instance.collection(widget.ccollection);
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: widget.userDoc['avatar'],
                  fit: BoxFit.cover,
                  height: 30,
                  width: 30,
                )),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.userDoc['displayName'].toString().toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const Text(
                ' Va Publier Une Annonce',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17),
              ),
            ],
          )),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: _imagesList.length < 4
                ? Column(
                    children: [
                      Center(
                          child: Container(
                        height: 50,
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            getMultiImagesGallery();
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _getFromCamera();
                                  },
                                  icon: Icon(Icons.camera_alt_rounded),
                                  color: Colors.black38,
                                ),
                                IconButton(
                                  onPressed: () {
                                    getMultiImagesGallery();
                                  },
                                  icon: Icon(Icons.image),
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                      _imagesList.isEmpty
                          ? Container()
                          : GridView.builder(
                              key: UniqueKey(),
                              shrinkWrap: true,
                              itemCount:
                                  _imagesList.isEmpty ? 2 : _imagesList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemBuilder: (context, index) => Card(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(_imagesList[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                        right: -10,
                                        top: -10,
                                        child: Container(
                                          // color: const Colors.,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 20,
                                            ),
                                            color: Colors.red,
                                            onPressed: () {
                                              _imagesList.removeAt(index);
                                              setState(() {});
                                            },
                                          ),
                                        ))
                                  ],
                                ),
                              ),

                              // )
                            ),
                    ],
                  )
                : GridView.builder(
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: _imagesList.isEmpty ? 2 : _imagesList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (context, index) => Card(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(_imagesList[index].path),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                              right: -10,
                              top: -10,
                              child: Container(
                                // color: const Colors.,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                  ),
                                  color: Colors.red,
                                  onPressed: () {
                                    _imagesList.removeAt(index);
                                    setState(() {});
                                  },
                                ),
                              ))
                        ],
                      ),
                    ),

                    // )
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formStepperKey,
              child: Column(
                children: [
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
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
                    controller: _itemController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black38),
                      //fillColor: Colors.blue.shade50,
                      hintText: 'Titre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      //border: InputBorder.none,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    validator: (value) => value != null && value.length < 3
                        ? 'Entrer min 3 characteres.'
                        : null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        keyboardType: TextInputType.number,
                        controller: _priceController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black38),
                          //fillColor: Colors.blue.shade50,
                          hintText: 'Prix En Dinar Sans Virgule',
                          //border: InputBorder.none,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.all(15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Prix Réel du Jour';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _locationventeSelected == 'vente'
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Paiement Par ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black38),
                                ),
                                Container(
                                  //width: MediaQuery.of(context).size.width / 3,
                                  child: DropdownButton<String>(
                                    iconSize: 35,

                                    underline: Container(),
                                    // Step 3.
                                    value: dropdownValue,
                                    // Step 4.
                                    isDense: false,
                                    items: <String>[
                                      'nuitée',
                                      'mois',
                                      '06 mois',
                                      'an'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    // Step 5.
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                      //Text(dropdownValue),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  IntlPhoneField(
                    controller: _telContactController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black38),
                      //fillColor: Colors.blue.shade50,
                      hintText: '770 00 00 00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      // border: InputBorder.none,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    invalidNumberMessage: 'Corriger Votre Numéro de Tel',
                    // disableLengthCheck: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Entrer Ton Numero de Tel';
                      } else {
                        // validate against your regex pattern
                        RegExp regex = new RegExp(r'^[567][0-9]{8}$');
                        if (!regex.hasMatch(value.toString())) {
                          return 'Entrer Que Ooreddo ou Djezzy ou Mobilis';
                        }
                        return null;
                      }
                    },
                    // style: const TextStyle(
                    //   fontSize: 18,
                    // ),

                    showDropdownIcon: false,
                    initialCountryCode: 'DZ',

                    onSaved: (PhoneNumber? phone) {
                      if (phone != null) {
                        _telContactController.text = phone.completeNumber;
                        _phoneCodeController.text = phone.countryCode;
                      }
                      print('/////////////');
                      print(_telContactController.text);
                      print(_phoneCodeController.text);
                    },
                    flagsButtonMargin: EdgeInsets.zero,
                    flagsButtonPadding: const EdgeInsets.only(left: 15),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black38),
                      hintText: 'Ecrire Une Déscription',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vous Devez Ecrire Une Description';
                      } else if (isSelected == false) {
                        return 'Vous Devez Choisir Location ou Vente';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Lieu'),
                notifier.value == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ValueListenableBuilder<GeoPoint?>(
                          valueListenable: notifier,
                          builder: (ctx, px, child) {
                            return FutureBuilder<String>(
                              future: getAddressFromLatLng(
                                  px!.latitude, px.longitude),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data!);
                                } else if (snapshot.hasError) {
                                  return Text('Erreur: ${snapshot.error}');
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            );

                            //   Center(
                            //   child: Text(
                            //     "${px?.latitude.toString()} - ${px?.longitude.toString()}" ??
                            //         '',
                            //     textAlign: TextAlign.center,
                            //   ),
                            // );
                          },
                        ),
                      ),
                // ValueListenableBuilder<GeoPoint?>(
                //   valueListenable: notifier,
                //   builder: (ctx, p, child) {
                //     return Center(
                //       child: Text(
                //         "${p?.toString() ?? ""}",
                //         textAlign: TextAlign.center,
                //       ),
                //     );
                //   },
                // ),
                IconButton(
                  onPressed: () async {
                    var p = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SearchPage()));
                    if (p != null) {
                      setState(
                        () => notifier.value = p as GeoPoint,
                      );
                    }
                  },
                  icon: Icon(FontAwesomeIcons.location),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 20, 60, 60),
            child: uploading == false
                ? ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 40)),
                    ),
                    onPressed: () async {
                      if (_imagesList.isEmpty ||
                          _descriptionController.text == null ||
                          _descriptionController.text == '' ||
                          notifier.value == null) {
                        return showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            scrollable: true,
                            title: Center(
                              child: Text(
                                'Attention!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            content: Center(
                              child: Text(
                                'Completez\nToute\nLa Publication',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                          ),
                        );
                      }
                      if (notifier.value == null) {
                        () => showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                scrollable: true,
                                title: Center(
                                  child: Text(
                                    'Attention!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                content: Center(
                                  child: Text(
                                    'Vous Devez Choisir\nLa Localisation de Votre Annonce\nSur La Carte',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  IconButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      var p = await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) => SearchPage()));
                                      if (p != null) {
                                        notifier.value = p as GeoPoint;
                                      }
                                    },
                                    icon: Icon(FontAwesomeIcons.location),
                                  ),
                                  CloseButtonIcon()
                                ],
                              ),
                            );
                      }

                      if (uploading) return;
                      setState(() => uploading = true);

                      uploadFilePost(
                              imgRef,
                              _typeSelected,
                              _locationventeSelected,
                              _itemController.text,
                              _priceController.text,
                              _telContactController.text,
                              _phoneCodeController.text,
                              dropdownValue)
                          .whenComplete(() => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return verifi_auth();
                              })));
                    },
                    child: uploading == false
                        ? const Text('Publier')
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }

  Future getMultiImagesGallery() async {
    final List<XFile>? selectedImages = (await multiPicker.pickMultiImage(
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    ));

    setState(() {
      if (_imagesList.length <= 4) {
        if (selectedImages!.length <= (4 - _imagesList.length)) {
          // _imagesList.addAll(selectedImages);
          _imagesList.addAll(
              selectedImages.map<File>((XFile) => File(XFile.path)).toList());
          return print('PLUS QUE 4');
        } else {
          print('No Images Selected ');
          Fluttertoast.showToast(
              msg: (4 - _imagesList.length) == 1
                  ? 'Selectionner 1 Photo'
                  : 'Selectionner ${4 - _imagesList.length} Photo(s) ou Moins',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Pas De 4 Photos',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 14.0);
        return print('PAS PLUS QUE 4');
      }
    });
  }

  Future _getFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
    }

    setState(() {
      List<XFile> selectedImages = [];
      selectedImages.add(pickedFile!);

      if (_imagesList.length <= 4) {
        if (selectedImages.length <= (4 - _imagesList.length)) {
          // _imagesList.addAll(selectedImages);
          _imagesList.addAll(
              selectedImages.map<File>((XFile) => File(XFile.path)).toList());
          return print('PLUS QUE 4');
        } else {
          print('No Images Selected ');
          Fluttertoast.showToast(
              msg: (4 - _imagesList.length) == 1
                  ? 'Selectionner 1 Photo'
                  : 'Selectionner ${4 - _imagesList.length} Photo(s) ou Moins',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Pas De 4 Photos',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 14.0);
        return print('PAS PLUS QUE 4');
      }
    });
  }

  Future uploadFile2(cloud.CollectionReference<Object?> imgRef) async {
    int i = 1;
    cloud.GeoPoint geoPoint =
        cloud.GeoPoint(notifier.value!.latitude, notifier.value!.longitude);
    String description = _descriptionController.text;

    List usersLike = ['sans'];

    List<String> imageFiles = []; //****************

    var _image = _imagesList;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        //*****************************************
        await ref.getDownloadURL().then((value) {
          imageFiles.add(value);
          i++;
        });
      });
    }

    imgRef.add({
      // 'userID': FirebaseAuth.instance.currentUser!.uid,
      // 'themb': imageFiles.first,
      // 'imageUrls': imageFiles,
      // 'createdAt': cloud.Timestamp.now(),
      // 'Description': description,
      // 'likes': 0,
      // 'usersLike': usersLike,
      // 'views': 0.0,
      // 'viewed_by': [],

      'userID': FirebaseAuth.instance.currentUser!.uid,
      'themb': imageFiles.first,
      'imageUrls': imageFiles,
      'createdAt': cloud.Timestamp.now(), //now.toString(),
      'Description': description,
      'likes': 0, //likes,
      'usersLike': usersLike,
      'dateDebut': DateTime.now().add(const Duration(days: 3)),
      'dateFin': DateTime.now().add(const Duration(days: 11)),
      'levelItem': 'free',
      'position': geoPoint,
      'viewed_by': [],
      'views': 0,
    });
  }

  Future uploadFilePost(
      cloud.CollectionReference<Object?> imgRef,
      String typeSelected,
      String locationventeSelected,
      String itemController,
      String priceController,
      String phoneController,
      String phoneCodeController,
      String modePayment) async {
    int i = 1;
    cloud.GeoPoint geoPoint =
        cloud.GeoPoint(notifier.value!.latitude, notifier.value!.longitude);
    String description = _descriptionController.text;

    //String typeSelected = typeSelected;
    String locationvente = locationventeSelected;
    String item = itemController;
    int price = int.parse(priceController);
    String phone = phoneController.toString(); //0687451524;
    String phoneCode = phoneCodeController.toString();
    // String modePayment =  modePayment.toString();

    List usersLike = ['sans'];
    List<String> imageFiles = []; //****************

    var _image = _imagesList;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        //*****************************************
        await ref.getDownloadURL().then((value) {
          imageFiles.add(value);
          i++;
        });
      });
    }
    print(geoPoint);
    imgRef.add({
      'userID': FirebaseAuth.instance.currentUser!.uid,
      'themb': imageFiles.first,
      'imageUrls': imageFiles,
      'createdAt': cloud.Timestamp.now(), //now.toString(),
      'Description': description,
      'likes': 0, //likes,
      'usersLike': usersLike,
      'dateDebut': DateTime.now().add(const Duration(days: 3)),
      'dateFin': DateTime.now().add(const Duration(days: 11)),
      'levelItem': 'free',
      'position': geoPoint,
      'viewed_by': [],
      'views': 0,
      'type': locationvente,
      "item": item,
      'price': price, // + '.00 dzd ',
      'modePayment': modePayment,
      'category': typeSelected,
      'phone': phone,
      'phoneCode': phoneCode,
    });
    userRef.doc(user!.uid).update(
      {
        'userItemsNbr': cloud.FieldValue.increment(1),
      },
    );
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks.first;
      return "${place.locality}, ${place.country}"; //${place.street}, ${place.postalCode},
    }

    return "";
  }
}

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController textEditingController = TextEditingController();
  late PickerMapController controller = PickerMapController(
    initMapWithUserPosition: true,
  );

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(textOnChanged);
  }

  void textOnChanged() {
    controller.setSearchableText(textEditingController.text);
  }

  @override
  void dispose() {
    textEditingController.removeListener(textOnChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPickerLocation(
        controller: controller,
        topWidgetPicker: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
          child: Column(
            children: [
              Row(
                children: [
                  // TextButton(
                  //   style: TextButton.styleFrom(),
                  //   onPressed: () => Navigator.of(context).pop(),
                  //   child: Icon(
                  //     Icons.arrow_back_ios,
                  //   ),
                  // ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onEditingComplete: () async {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        suffix: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: textEditingController,
                          builder: (ctx, text, child) {
                            if (text.text.isNotEmpty) {
                              return child!;
                            }
                            return SizedBox.shrink();
                          },
                          child: InkWell(
                            focusNode: FocusNode(),
                            onTap: () {
                              textEditingController.clear();
                              controller.setSearchableText("");
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        focusColor: Colors.black,
                        filled: true,
                        hintText: "Rechercher Adresse",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: Colors.grey[300],
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TopSearchWidget()
            ],
          ),
        ),
        bottomWidgetPicker: Positioned(
          bottom: 70,
          right: 18,
          child: FloatingActionButton(
            onPressed: () async {
              GeoPoint p = await controller.selectAdvancedPositionPicker();
              Navigator.pop(context, p);
            },
            child: Icon(FontAwesomeIcons.telegram),
          ),
        ),
        pickerConfig: CustomPickerLocationConfig(
          advancedMarkerPicker: MarkerIcon(
            icon: Icon(
              FontAwesomeIcons.locationDot,
              size: 100,
              color: Colors.red,
            ),
          ),
          initZoom: 17,
        ),
      ),
    );
  }
}

class TopSearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopSearchWidgetState();
}

class _TopSearchWidgetState extends State<TopSearchWidget> {
  late PickerMapController controller;
  ValueNotifier<GeoPoint?> notifierGeoPoint = ValueNotifier(null);
  ValueNotifier<bool> notifierAutoCompletion = ValueNotifier(false);

  late StreamController<List<SearchInfo>> streamSuggestion = StreamController();
  late Future<List<SearchInfo>> _futureSuggestionAddress;
  String oldText = "";
  Timer? _timerToStartSuggestionReq;
  final Key streamKey = Key("streamAddressSug");

  @override
  void initState() {
    super.initState();
    controller = CustomPickerLocation.of(context);
    controller.searchableText.addListener(onSearchableTextChanged);
  }

  void onSearchableTextChanged() async {
    final v = controller.searchableText.value;
    if (v.length > 3 && oldText != v) {
      oldText = v;
      if (_timerToStartSuggestionReq != null &&
          _timerToStartSuggestionReq!.isActive) {
        _timerToStartSuggestionReq!.cancel();
      }
      _timerToStartSuggestionReq =
          Timer.periodic(Duration(seconds: 3), (timer) async {
        await suggestionProcessing(v);
        timer.cancel();
      });
    }
    if (v.isEmpty) {
      await reInitStream();
    }
  }

  Future reInitStream() async {
    notifierAutoCompletion.value = false;
    await streamSuggestion.close();
    setState(() {
      streamSuggestion = StreamController();
    });
  }

  Future<void> suggestionProcessing(String addr) async {
    notifierAutoCompletion.value = true;
    _futureSuggestionAddress = addressSuggestion(
      addr,
      limitInformation: 5,
    );
    _futureSuggestionAddress.then((value) {
      streamSuggestion.sink.add(value);
    });
  }

  @override
  void dispose() {
    controller.searchableText.removeListener(onSearchableTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifierAutoCompletion,
      builder: (ctx, isVisible, child) {
        return AnimatedContainer(
          duration: Duration(
            milliseconds: 500,
          ),
          height: isVisible ? MediaQuery.of(context).size.height / 4 : 0,
          child: Card(
            child: child!,
          ),
        );
      },
      child: StreamBuilder<List<SearchInfo>>(
        stream: streamSuggestion.stream,
        key: streamKey,
        builder: (ctx, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemExtent: 50.0,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(
                    snap.data![index].address.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  onTap: () async {
                    /// go to location selected by address
                    controller.goToLocation(
                      snap.data![index].point!,
                    );

                    /// hide suggestion card
                    notifierAutoCompletion.value = false;
                    await reInitStream();
                    FocusScope.of(context).requestFocus(
                      new FocusNode(),
                    );
                  },
                );
              },
              itemCount: snap.data!.length,
            );
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return Card(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
