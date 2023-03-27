import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

import 'global_rooms.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1)));
  //DateTimeRange(start: DateTime(2022, 01, 01), end: DateTime(2050, 12, 30));
  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  // TextEditingController _dateDebutController = new TextEditingController();
  // TextEditingController _dateFinController = new TextEditingController();
  TextEditingController date_debut = TextEditingController();
  TextEditingController date_fin = TextEditingController();

  CollectionReference imgRef = FirebaseFirestore.instance.collection('Booking');

  final List<File> _image = [];

  final picker = ImagePicker();
  // DateTime _dateinit = DateTime.now();
  // late DateTime _dateDebut;
  // late DateTime _dateFin;

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reserver'),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  uploadRandom();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: ListView(children: [
          Container(
            height: 300, // zedtha 10h34**************
            padding: const EdgeInsets.all(44),
            child: GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // zedtha 10h34***************
                shrinkWrap: true, // zedtha 10h34***************
                itemCount: _image.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //mainAxisExtent: 2
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () =>
                                  !uploading ? chooseImage() : null),
                        )
                      : Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_image[index - 1]),
                                  fit: BoxFit.cover)),
                        );
                }),
          ),
          uploading
              ? Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: const Text(
                        'uploading...',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(
                      value: val,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                  ],
                ))
              : Container(),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter Name',
              prefixIcon: Icon(
                Icons.account_circle,
                size: 30,
              ),
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(15),
            ),
          ),
          TextFormField(
            controller: _roomController,
            decoration: const InputDecoration(
              hintText: 'Room',
              prefixIcon: Icon(
                Icons.account_circle,
                size: 30,
              ),
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(15),
            ),
          ),
          const SizedBox(height: 15),
          // Center(child: Text('${_dateinit.day}/${_dateinit.month}/${_dateinit.year}')),
          //Center(child: Text(_dateinit.toString())),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //child: Center(child: Text(date_debut.text)),
                  child: Center(
                    child: Text('${start.day}/${start.month}/${start.year}'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //child: Center(child: Text(date_fin.text)),
                  child: Center(child: Text(end.toString())),
                  // child: Center(child: Text('${end.year}/${end.month}/${end.day}'),),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          date_debut.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    child: const Text('Date Début'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          date_fin.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    child: const Text('Date Fin'),
                  ),
                ),
              ),
            ],
          ),
          Center(
              child: ElevatedButton(
            child: const Text('Range Booking'),
            onPressed: () {
              pickDateRange();
            },
          )),

          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  uploading = true;
                  const global_rooms();
                });
                uploadFile().whenComplete(() => Navigator.of(context).pop());
              },
              child: const Text(
                'Ajouter',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ]));
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      //locale: Locale('fr'),
      context: context,
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
      initialDateRange: dateRange,
      currentDate: DateTime.now(),
    );
    if (newDateRange == null) return;
    setState(() {
      dateRange = newDateRange;
    });
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxHeight: 1080,
        maxWidth: 1920);

    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;
    String Name = _nameController.text;
    String Room = _roomController.text;
    String DateD = date_debut.text;
    String DateF = date_fin.text;
    //var now = DateTime.now().millisecondsSinceEpoch;
    List<String> imageFiles = []; //****************

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
      "Name": Name,
      'Room': Room,
      'Date_D': DateD,
      'Date_F': DateF, // + '.00 dzd ',
      'createdAt': Timestamp.now(), //now.toString(),
      'themb': imageFiles.first,
      'urls': imageFiles,
    });
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('Booking');
    // _dateDebut = DateTime.now(); //set the initial value of text field
    // _dateFin = DateTime.now(); //set the initial value of text field
    date_debut.text = ""; //set the initial value of text field
    date_fin.text = ""; //set the initial value of text field
  }

  void uploadRandom() async {
    final postCollection =
        FirebaseFirestore.instance.collection('Booking').withConverter<Post>(
              fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
              toFirestore: (post, _) => post.toJson(),
            );
    final numbers = List.generate(100, (index) => index + 1);
    for (final number in numbers) {
      List<String> listCat = [
        'Hotel',
        'Residence',
        'Agence',
        'Autres',
        'Sponsors',
      ];
      List<int> listnum = [1, 2, 3, 4, 5];
      List<String> listItem = [
        'Adams',
        'Bakerti',
        'Clark',
        'Davisco',
        'Evanessance',
        'Frank',
        'Ghoshock',
        'Hills',
        'Irwintaro',
        'Jones',
        'Kleinez',
        'Lopez',
        'Mufasa',
        'Sarabi',
        'Simba',
        'Nala',
        'Kiara',
        'Kov',
        'Timon',
        'Pumbaama',
        'Rafora',
        'Shenzi',
        'Masoulna',
        'Naltyp',
        'Ochoa',
        'Patelroota',
        'Quinncom',
        'Reilyse',
        'Smith',
        'Trott',
        'Usman',
        'Valdorcomité',
        'White',
        'Xiangshemzhen',
        'Yakub',
        'Zafarta',
      ];

      var randomCat = (listCat..shuffle()).first;
      var randomItem = (listItem..shuffle()).first;
      var randomNum = (listnum..shuffle()).first;

      var prix = Random().nextInt(5000);
      var catego = listCat[0];
      var items = listItem[0];
      DateTime datenow = DateTime.now();
      int numran = number + randomNum;

      final post = Post(
          Name: randomItem,
          // code: 'invoice$number',
          // category: '$randomCat',
          // price: '$prix',
          Room: '$number', //Random().nextInt(1000),
          DateD: datenow.add(Duration(days: number)).toString(),
          DateF: datenow.add(Duration(days: numran)).toString(),
          createdAt: DateTime.now().add(Duration(days: randomNum)),
          imageUrl: 'https://source.unsplash.com/random?sig=$number',
          themb: 'https://source.unsplash.com/random?sig=$numran');
      postCollection.add(post);
    }
  }
}

class Post {
  final String Name;
  final String Room;
  final String DateD;
  final String DateF;
  final DateTime createdAt;
  final String imageUrl;
  final String themb;

  const Post({
    required this.Name,
    required this.Room,
    required this.DateD,
    required this.DateF,
    required this.createdAt,
    required this.imageUrl,
    required this.themb,
  });
  Post.fromJson(Map<String, Object?> json)
      : this(
          Name: json['Name']! as String,
          Room: json['Room']! as String,
          DateD: json['Date_D']! as String,
          DateF: json['Date_F']! as String,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          imageUrl: json['imageUrl']! as String,
          themb: json['themb']! as String,
        );
  Map<String, Object?> toJson() => {
        "Name": Name,
        'Room': Room,
        'Date_D': DateD,
        'Date_F': DateF, // + '.00 dzd ',
        'createdAt': createdAt,
        'imageUrl': imageUrl,
        'themb': themb,
      };
}
