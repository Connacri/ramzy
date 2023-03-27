import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path/path.dart' as Path;

import 'package:fluttertoast/fluttertoast.dart';

import '../Oauth/verifi_auth.dart';
import '../pages/addPost_page_detail.dart';

class stepper2_widget extends StatefulWidget {
  stepper2_widget({Key? key, required this.ccollection, required this.userDoc})
      : super(key: key);
  String ccollection;
  final userDoc;

  @override
  State<stepper2_widget> createState() => _stepper2_widgetState();
}

class _stepper2_widgetState extends State<stepper2_widget> {
  bool uploading = false;
  int currentStep = 0;
  // final List<XFile> _imagesList = [];
  final List<File> _imagesList = [];
  final multiPicker = ImagePicker();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
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
  cloud.CollectionReference imgRef =
      cloud.FirebaseFirestore.instance.collection('Instalives');
  cloud.CollectionReference userRef =
      cloud.FirebaseFirestore.instance.collection('Users');

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

  final GlobalKey<FormState> _formStepperKey = GlobalKey<FormState>();
  ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(fontFamily: 'oswald', fontSize: 22),
                ),
              ),
              const Text(
                ' Va Publier Une Annonce',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'oswald', fontSize: 17),
              ),
            ],
          )),
      body: ListView(
        children: <Widget>[
          _imagesList.isEmpty
              ? Center(
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
                  itemCount: _imagesList.isEmpty ? 2 : _imagesList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          Form(
            key: _formStepperKey,
            child: Column(
              children: [
                TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black38),
                      fillColor: Colors.white,
                      hintText: 'Quoi De Neuf ?',
                      border: InputBorder.none,
                      filled: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    textInputAction: TextInputAction.next), // description
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ValueListenableBuilder<GeoPoint?>(
                  valueListenable: notifier,
                  builder: (ctx, p, child) {
                    return Center(
                      child: Text(
                        "${p?.toString() ?? ""}",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () async {
                    var p = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SearchPage()));
                    if (p != null) {
                      notifier.value = p as GeoPoint;
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
                      if (uploading) return;
                      setState(() => uploading = true);

                      uploadFile2().whenComplete(() => Navigator.push(context,
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

  Future uploadFile2() async {
    int i = 1;

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
      'userID': FirebaseAuth.instance.currentUser!.uid,
      'themb': imageFiles.first,
      'imageUrls': imageFiles,
      'createdAt': cloud.Timestamp.now(),
      'Description': description,
      'likes': 213,
      'usersLike': usersLike,
    });
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
