import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:path/path.dart' as Path;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ramzy/2/Hotel/Book.dart';
import 'package:ramzy/pages/classes.dart';

import '../pages/Aperçu_Item.dart';

class stepper_widget extends StatefulWidget {
  stepper_widget({Key? key, required this.ccollection, required this.userDoc})
      : super(key: key);
  String ccollection;
  final userDoc;
  @override
  State<stepper_widget> createState() => _stepper_widgetState();
}

class _stepper_widgetState extends State<stepper_widget> {
  bool uploading = false;
  int currentStep = 0;

  // final List<XFile> _imagesList = [];
  final List<File> _imagesList = [];
  final multiPicker = ImagePicker();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phoneCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _likesController = TextEditingController();
  final TextEditingController _telContactController = TextEditingController();
  final TextEditingController _generaleController = TextEditingController();

  //final user = FirebaseAuth.instance.currentUser;
  String _typeSelected = '';
  String _locationventeSelected = '';
  late int selectedRadio;

  @override
  void initState() {
    super.initState();
    _typeSelected = '';
    _locationventeSelected = '';
    selectedRadio = 0;
    //imgRef = FirebaseFirestore.instance.collection(widget.ccollection);
    userRef = cloud.FirebaseFirestore.instance.collection('Users');
  }

  double val = 0;
  late firebase_storage.Reference ref;
  cloud.CollectionReference userRef =
      cloud.FirebaseFirestore.instance.collection('Users');

  //CollectionReference imgRef = FirebaseFirestore.instance.collection('Post');

  late bool isSelected = false;
  late bool isSwitched = false;

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
        locavente,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  int _currentTimeValue = 1;

  final _buttonOptions = [
    TimeValue(
      1,
      'Ses points forts',
    ),
    TimeValue(
      2,
      'Piscine extérieure',
    ),
    TimeValue(
      3,
      'Connexion Wi-Fi gratuite',
    ),
    TimeValue(
      4,
      'Navette aéroport (gratuite)',
    ),
    TimeValue(
      5,
      'Le Cliff',
    ),
    TimeValue(
      6,
      'Centre de remise en forme',
    ),
    TimeValue(
      7,
      'Chambres non-fumeurs',
    ),
    TimeValue(
      8,
      'Service d\'étage',
    ),
    TimeValue(
      9,
      'Plateau/bouilloire dans tous les hébergements',
    ),
    TimeValue(
      10,
      'Bar',
    ),
    TimeValue(
      11,
      'Petit-déjeuner',
    ),
  ];

  String dropdownValue = 'Dog';

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

  final GlobalKey<FormState> _formStepperKey = GlobalKey<FormState>();
  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    // late final GeoPoint p;

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
            crossAxisAlignment: CrossAxisAlignment.end,
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
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue,
          ),
        ),
        child: Center(
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepTapped: (index) {
              if (_imagesList.isEmpty) {
                return;
              } else {
                setState(() => currentStep = index);
              }
            },
            onStepContinue: () {
              // if (currentStep == 0) {
              //   setState(() => currentStep++);
              // }
              // if (currentStep == 1) {
              //   //  if (_formStepperKey.currentState!.validate()) {
              //   setState(() => currentStep++);
              //   //}
              // }
              if (currentStep != 2) {
                if (currentStep != 1) {
                  setState(() => currentStep++);
                } else {
                  if (_formStepperKey.currentState!.validate()) {
                    setState(() => currentStep++);
                  }
                }
              }
            },
            onStepCancel:
                currentStep == 0 ? null : () => setState(() => currentStep--),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              final isLastStep = currentStep == 2;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    if (currentStep != 0)
                      Expanded(
                          child: ElevatedButton(
                        onPressed: details.onStepCancel,
                        child: const Text(
                          'Precédant',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'oswald',
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                    _imagesList.isEmpty
                        ? Container()
                        :
                        // widget.ccollection == 'Products'
                        //         ?
                        Expanded(
                            child: ElevatedButton(
                              onPressed: isLastStep
                                  ? () async {
                                      await Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return page_detail(
                                          geoLocation: notifier,
                                          imagesList: _imagesList,
                                          locationventeSelected:
                                              _locationventeSelected,
                                          user: widget.userDoc,
                                          typeSelected: _typeSelected,
                                          itemController: _itemController.text,
                                          priceController:
                                              _priceController.text,
                                          phoneCodeController:
                                              _phoneCodeController.text,
                                          descriptionController:
                                              _descriptionController.text,
                                          phoneController:
                                              _telContactController.text,
                                        );
                                      }));
                                    }
                                  : details.onStepContinue,
                              child: Text(
                                isLastStep ? 'Aperçu' : 'Suivant',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'oswald',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                  ],
                ),
              );
            },
            steps: [
              Step(
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 0,
                title: const Text(
                  'Photo(s)',
                  style: TextStyle(fontSize: 14),
                ),
                content: Column(
                  children: [
                    _imagesList.length < 4
                        ? Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {});
                                  //getMultiImagesGallery();
                                  _getFromCamera();
                                },
                                clipBehavior: Clip.none,
                                child: Text(
                                  'Ajouter Moins de ${4 - _imagesList.length} Photos',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              _imagesList.length == 0
                                  ? Container()
                                  : Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _getFromCamera();
                                            },
                                            icon:
                                                Icon(Icons.camera_alt_rounded),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              getMultiImagesGallery();
                                            },
                                            icon: Icon(Icons.image),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          )
                        : TextButton(
                            onPressed: () {
                              Fluttertoast.showToast(
                                msg: 'Devenir Premium',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );
                            },
                            child: const Text(
                              'Limite d\'Ajout des Photos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'oswald',
                                  fontSize: 14,
                                  color: Colors.deepOrange),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    _imagesList.isEmpty
                        ? Center(
                            child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            )),
                            height: 300,
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
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        getMultiImagesGallery();
                                      },
                                      icon: Icon(Icons.image),
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                        : GridView.builder(
                            key: UniqueKey(),
                            shrinkWrap: true,
                            itemCount:
                                _imagesList.isEmpty ? 2 : _imagesList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.5))),
                                  child:
                                      // _imagesList.isEmpty
                                      //     ? InkWell(
                                      //         onTap: () {
                                      //           getMultiImages();
                                      //         },
                                      //         child: Icon(
                                      //           CupertinoIcons.camera,
                                      //           color: Colors.grey.withOpacity(0.5),
                                      //         ),
                                      //       )
                                      //     :
                                      Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        File(_imagesList[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                          right: -4,
                                          top: -4,
                                          child: Container(
                                            // color: const Colors.,
                                            child: IconButton(
                                              icon: const Icon(Icons.delete),
                                              color: Colors.red,
                                              onPressed: () {
                                                _imagesList.removeAt(index);
                                                setState(() {});
                                              },
                                            ),
                                          ))
                                    ],
                                  ),
                                  // )
                                )),
                  ],
                ),
              ),
              Step(
                state: currentStep > 1 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 1,
                title: const Text(
                  'Details',
                  style: TextStyle(fontSize: 14),
                ),
                content: buildStep2(),
              ),
              Step(
                state: currentStep > 2 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 2,
                title: const Text(
                  'Localisation',
                  style: TextStyle(fontSize: 14),
                ),
                content: Center(
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
                            return Center(
                              child: Text(
                                "${px?.toString() ?? ""}",
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: IconButton(
                          onPressed: () async {
                            var p = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => SearchPage()));
                            if (p != null) {
                              notifier.value = p as GeoPoint;
                            }
                          },
                          icon: Icon(FontAwesomeIcons.location),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Disable the next button if p is null
            ],
          ),
        ),
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

  /// Get from camera
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

  Future getMultiImagesCamera() async {
    final List<XFile>? selectedImages = await multiPicker.pickMultiImage(
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    );

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

  Widget buildStep2() {
    return Column(
      children: <Widget>[
        Form(
          key: _formStepperKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildLocationVente('Location'),
                  )),
                  // const SizedBox(width: 10),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildLocationVente('Vente'),
                  )),
                ],
              ),

              // DropdownButton<String>(
              //   // Step 3.
              //   value: dropdownValue,
              //   // Step 4.
              //   items: <String>['Dog', 'Cat', 'Tiger', 'Lion']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(
              //         value,
              //         style: TextStyle(fontSize: 30),
              //       ),
              //     );
              //   }).toList(),
              //   // Step 5.
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       dropdownValue = newValue!;
              //     });
              //   },
              // ),
              // Text(dropdownValue),
              // Container(
              //   height: 200,
              //   child: ListView.builder(
              //     // shrinkWrap: true,
              //     // physics: NeverScrollableScrollPhysics(),
              //     scrollDirection: Axis.vertical,
              //     padding: EdgeInsets.all(8.0),
              //     itemCount: _buttonOptions.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       final timeValue = _buttonOptions[index];
              //       return RadioListTile<int>(
              //         groupValue: _currentTimeValue,
              //         title: Text(timeValue._value.toString()),
              //         value: timeValue._key,
              //         dense: true,
              //         onChanged: (val) {
              //           setState(() {
              //             debugPrint('VAL = $val');
              //             _currentTimeValue = val!;
              //           });
              //         },
              //       );
              //     },
              //   ),
              // ),
              SizedBox(height: 20),
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
                  fontSize: 25,
                ),
                keyboardType: TextInputType.text,
                controller: _itemController,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black26),
                  fillColor: Colors.white,
                  hintText: 'Titre',
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) => value != null && value.length < 3
                    ? 'Entrer min 3 characteres.'
                    : null,
              ), // titre du produit
              SizedBox(
                height: 10,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                keyboardType: TextInputType.number,
                controller: _priceController,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black26),
                  fillColor: Colors.white,
                  hintText: 'Prix En Dinar Sans Virgule',
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prix Réel du Jour';
                  }
                  return null;
                },
              ), // prix
              SizedBox(
                height: 10,
              ),
              // IntlPhoneField(
              //   controller: _telContactController,
              //   decoration: const InputDecoration(
              //     hintStyle: TextStyle(color: Colors.black26),
              //     fillColor: Colors.white,
              //     hintText: '660 00 00 00',
              //     border: InputBorder.none,
              //     filled: true,
              //     contentPadding: EdgeInsets.all(15),
              //   ),
              //   // invalidNumberMessage:
              //   //     'Entrer Que Ooreddo ou Djezzy ou Mobilis',
              //   disableLengthCheck: true,
              //   validator: (value) {
              //     if (value == null) {
              //       return 'Entrer Ton Numero de Tel';
              //     } else {
              //       // validate against your regex pattern
              //       RegExp regex = new RegExp(r'^[567][0-9]{8}$');
              //       if (!regex.hasMatch(value.toString())) {
              //         return 'Entrer Que Ooreddo ou Djezzy ou Mobilis';
              //       }
              //       return null;
              //     }
              //   },
              //   showDropdownIcon: false,
              //   initialCountryCode: 'DZ',
              //   // onChanged: (phone) {
              //   //   setState(() {
              //   //     _telContactController.text =
              //   //         phone.completeNumber;
              //   //     print(_telContactController.text);
              //   //   });
              //   // },
              //   flagsButtonMargin: EdgeInsets.zero,
              //   flagsButtonPadding: const EdgeInsets.only(left: 15),
              //   onSaved: (phoneNumber) async {
              //     setState(() {
              //       _phoneCodeController.text = phoneNumber!.countryCode;
              //       //print(_telContactController.text);
              //     });
              //   },
              // ),
              IntlPhoneField(
                controller: _telContactController,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black26),
                  fillColor: Colors.white,
                  hintText: '660 00 00 00',
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                invalidNumberMessage: 'Entrer Que Ooreddo ou Djezzy ou Mobilis',
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
                style: const TextStyle(
                  fontSize: 25,
                ),

                showDropdownIcon: false,
                initialCountryCode: 'DZ',

                onSaved: (PhoneNumber? phone) {
                  if (phone != null) {
                    _telContactController.text = phone.completeNumber;
                  }
                  print('/////////////');
                  print(_telContactController.text);
                },
                flagsButtonMargin: EdgeInsets.zero,
                flagsButtonPadding: const EdgeInsets.only(left: 15),
              ), // mobil
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black26),
                  fillColor: Colors.white,
                  hintText: 'Ecrire Une Description',
                  border: InputBorder.none,
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
              ), // description
            ],
          ),
        ),
        //CATEGORIES**********************************************************
      ],
    );
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

class LocationResult {
  final double latitude;
  final double longitude;
  final double? bearing;
  final double? zoom;

  LocationResult({
    required this.latitude,
    required this.longitude,
    this.bearing,
    this.zoom,
  });
}

class TimeValue {
  final int _key;
  final String _value;
  TimeValue(this._key, this._value);
}
