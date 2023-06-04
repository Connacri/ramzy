import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ramzy/pages/addAnnonce2.dart';
import '../pages/classes.dart';

class uploading_functions extends StatefulWidget {
  const uploading_functions({Key? key, required this.userDoc})
      : super(key: key);
  final userDoc;
  @override
  State<uploading_functions> createState() => _uploading_functionsState();
}

class _uploading_functionsState extends State<uploading_functions> {
  final TextEditingController _ItemsNumController = TextEditingController();
  String collection = 'Products';
  late int itemsNum;
  //String dropdownValue = 'Products';
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String collectionAlert = 'Alert';
  //String collectionPubArea = 'pubArea';

  CollectionReference _alertCollection =
      FirebaseFirestore.instance.collection('Alert');
  CollectionReference _alertCollectionArab =
      FirebaseFirestore.instance.collection('AlertArabic');

  bool _isUpdating = false;
  late String _alertId;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Managing'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     DropdownButton<String>(
              //       // Step 3.
              //       value: collection, //dropdownValue,
              //       // Step 4.
              //       items: <String>[
              //         'Products',
              //         'Instalives',
              //         'Caroussel',
              //         'PubArea'
              //       ].map<DropdownMenuItem<String>>((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(
              //             value,
              //             style: TextStyle(fontSize: 30),
              //           ),
              //         );
              //       }).toList(),
              //       // Step 5.
              //       onChanged: (String? newValue) {
              //         setState(() {
              //           //dropdownValue
              //           collection = newValue!;
              //         });
              //       },
              //     ),
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.25,
              //       child: TextFormField(
              //         textAlign: TextAlign.center,
              //         style: const TextStyle(
              //           fontSize: 25,
              //         ),
              //         keyboardType: TextInputType.number,
              //         controller: _ItemsNumController,
              //         decoration: const InputDecoration(
              //           hintStyle: TextStyle(color: Colors.black26),
              //           fillColor: Colors.white,
              //           hintText: '00',
              //           border: InputBorder.none,
              //           filled: true,
              //           contentPadding: EdgeInsets.all(15),
              //         ),
              //       ),
              //     ),
              //     IconButton(
              //       onPressed: () {
              //         _ItemsNumController.text.isEmpty
              //             ? itemsNum = 1
              //             : itemsNum = int.parse(_ItemsNumController.text);
              //         uploadRandom(itemsNum, collection);
              //       },
              //       icon: const Icon(FontAwesomeIcons.add),
              //     ),
              //   ],
              // ),

              Row(
                children: [
                  DropdownButton<String>(
                    // Step 3.
                    value: collection, //dropdownValue,
                    // Step 4.
                    items: <String>[
                      'Products',
                      'Instalives',
                      'Caroussel',
                      'CarousselInsta',
                      'PubArea'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    }).toList(),
                    // Step 5.
                    onChanged: (String? newValue) {
                      setState(() {
                        //dropdownValue
                        collection = newValue!;
                      });
                    },
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => addAnnonce2(
                          ccollection: collection,
                          userDoc: widget.userDoc,
                        ),
                      ),
                    ),
                    icon: const Icon(FontAwesomeIcons.add),
                  ),
                ],
              ),
              Divider(),
              DropdownButton<String>(
                // Step 3.
                value: collectionAlert, //dropdownValue,
                // Step 4.
                items: <String>[
                  'Alert',
                  'AlertArabic',
                ].map<DropdownMenuItem<String>>((String valu) {
                  return DropdownMenuItem<String>(
                    value: valu,
                    child: Text(
                      valu,
                      style: TextStyle(fontSize: 30),
                    ),
                  );
                }).toList(),
                // Step 5.
                onChanged: (String? newValu) {
                  setState(() {
                    //dropdownValue
                    collectionAlert = newValu!;
                    print(collectionAlert);
                  });
                },
              ),
              TextFormField(
                controller: _textController,
                style: const TextStyle(
                  fontSize: 25,
                ),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black26),
                  fillColor: Colors.white,
                  hintText: collectionAlert == 'AlertArabic'
                      ? ' entre en arab '
                      : 'Ajouter Un Text d\'Alert',
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              collectionAlert == 'AlertArabic'
                  ? ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_isUpdating) {
                            await _alertCollectionArab
                                .doc(_alertId)
                                .update({'text': _textController.text});
                            setState(() {
                              _isUpdating = false;
                            });
                          } else {
                            await _alertCollectionArab
                                .add({'text': _textController.text});
                          }
                          _textController.clear();
                        }
                      },
                      child: Text(_isUpdating ? 'Update' : 'Save'),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_isUpdating) {
                            await _alertCollection
                                .doc(_alertId)
                                .update({'text': _textController.text});
                            setState(() {
                              _isUpdating = false;
                            });
                          } else {
                            await _alertCollection
                                .add({'text': _textController.text});
                          }
                          _textController.clear();
                        }
                      },
                      child: Text(_isUpdating ? 'Update' : 'Save'),
                    ),
              SizedBox(height: 16.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: collectionAlert == 'AlertArabic'
                      ? _alertCollectionArab.snapshots()
                      : _alertCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(document['text']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    _isUpdating = true;
                                    _alertId = document.id;
                                  });
                                  _textController.text = document['text'];
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await collectionAlert == 'AlertArabic'
                                      ? _alertCollectionArab
                                          .doc(document.id)
                                          .delete()
                                          .then((value) {
                                          setState(() {
                                            _textController.clear();
                                            _isUpdating = false;
                                          });
                                        })
                                      : _alertCollection
                                          .doc(document.id)
                                          .delete()
                                          .then((value) {
                                          setState(() {
                                            _textController.clear();
                                            _isUpdating = false;
                                          });
                                        });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void uploadRandom(int itemsNum, String collection) async {
  final postCollection =
      FirebaseFirestore.instance.collection(collection).withConverter<Post>(
            fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
            toFirestore: (post, _) => post.toJson(),
          );
  final userCollection = FirebaseFirestore.instance
      .collection('Users')
      .withConverter<UserClass>(
        fromFirestore: (snapshot, _) => UserClass.fromJson(snapshot.data()!),
        toFirestore: (post, _) => post.toJson(),
      );
  // final bool boolType = true;
  // bool type = !boolType;

  final numbers = List.generate(itemsNum, (index) => index + 1);

  print('*****************************************************************');
  print(itemsNum.toString());

  for (final number in numbers) {
    List<String> listCat = [
      'Hotel',
      'Residence',
      'Agence',
      'Autres',
    ];
    List<String> listItem = [
      "Hôtel de luxe.",
      "Hôtel boutique.",
      "Maison de vacances en bord de mer.",
      "Maison de campagne.",
      "Appartement en centre-ville.",
      "Hôtel de montagne.",
      "Villa de luxe.",
      "Appartement de plage.",
      "Maison de ville historique.",
      "Lodge de safari.",
      'كراء شقة 2 غرف',
      'بيع شقة 3 غرف الجزائر',
    ];

    List<String> listDesc = [
      'تبحثون عن شقق في إقامة مغلقة و محروسة و محاطة بفيلات ؟ تبحثون عن الراحة و الهدوء؟       تريدون العيش في شقق مع اقل عدد ممكن من الجيران ؟      شركة نور الافاق للعمران المختصة في الترقية العقارية توفر لكم شقق جاهزة في اقامة هادئة و مغلقة على مستوى بابا علي - الجزائر العاصمة. _____تتوفر الإقامة على___  - شقق متنوعة F3,F4, Duplex. -تتمييز الشقق بإطلالتين و مكانين توقف السيارات لكل شقة.  -تدفئة مركزية.  - اقامة مغلقة و مزودة بكاميرات مراقبة.  - رخصة البناء / عقود فردية / شهادة مطابقة.  ___الاسعار (حسب النوع)__  # F3 (82 m²) + 2 places de parking.  _ 1 milliard 680 millions centimes.',
      'شقق للكراء اف2 نظيفة جميلة في مكان هادئ وامن       تحتوي على جميع الضروريات مكيف هوائي.ثلاجة.طباخة.الويفي.تلفاز بلازما.اغطية.افرشة.ڨاراج ركن السيارة....   الحجوزات   الشقة رقم 1 محجوزة من تاريخ 25 جويلية الى غاية 4 اوث  الشقة رقم 2 محجوزة من 21 جويلية إلى غاية 10 اوت  الشقة رقم 3 محجوزة من 21الى غاية 10 اوت  للحجز اتصل بالرقم وشكرا ',
      "Hôtel de luxe : Cet hôtel cinq étoiles propose des chambres spacieuses avec vue sur l'océan et une décoration élégante.",
      "Hôtel boutique : Cet hôtel de charme se trouve dans un bâtiment historique rénové et propose des chambres élégantes avec des touches artistiques uniques.",
      "Maison de vacances en bord de mer : Cette maison de vacances spacieuse est située à quelques pas de la plage et offre une vue imprenable sur l'océan depuis ses grandes baies vitrées.",
      "Maison de campagne : Cette maison de campagne traditionnelle est nichée dans un environnement paisible et verdoyant, avec un grand jardin, une piscine privée et une vue imprenable sur les montagnes environnantes.",
      "Appartement en centre-ville : Cet appartement élégant se trouve au cœur de la ville, à proximité des principales attractions touristiques, des restaurants et des boutiques.",
      "Hôtel de montagne : Cet hôtel de charme est situé dans les montagnes et offre des vues panoramiques sur les sommets enneigés.",
      "Villa de luxe : Cette villa de luxe est située dans un quartier chic et offre une vue imprenable sur l'océan.",
      "Appartement de plage : Cet appartement de plage moderne est situé à quelques pas de la plage et offre une vue imprenable sur la mer.",
      "Maison de ville historique : Cette maison de ville historique a été restaurée avec soin pour conserver son charme d'origine, tout en offrant des équipements modernes.",
      "Lodge de safari : Ce lodge de safari offre une expérience unique de vie en pleine nature. Les hébergements sont des tentes luxueuses équipées de tout le confort moderne, avec une vue imprenable sur la savane."
    ];
    List<String> listnames = [
      'Liam',
      'Noah',
      'Oliver',
      'Elijah',
      'James',
      'William',
      'Benjamin',
      'Lucas',
      'Henry',
      'Theodore',
      'Olivia',
      'Emma',
      'Charlotte',
      'Amelia',
      'Ava',
      'Sophia',
      'Isabella',
      'Mia',
      'Evelyn',
      'Harper',
    ];
    List<String> listLevel = [
      'gold',
      'silver',
      'platinium',
      'diamond',
      'standard',
      'black',
    ];
    List<String> listPlan = [
      'free',
      'premium',
    ];
    List<String> listuserId = [
      'thGB7qmmapdrUW12DDM5TKjOGBv1',
      'oZknAZY63gT13DUTUvnx5NAz83B2',
      'GbrwkfGl0Zg6BO0YewKTBN7H0U02',
      'DA0uLaRQNnhebV6pJmX2ThsYmQe2',
      'lqkshlkqshflkshf',
      '12354687976554654',
      '98764543121',
    ];
    List<int> listPhones = [
      0770852896,
      0668142852,
      0555987412,
      0789654123,
      0674258741,
      0550412365,
    ];
    List<String> lisTypes = ['vente', 'location'];

    // type = !type;

    String randomCat = (listCat..shuffle()).first;
    String randomLevel = (listLevel..shuffle()).first;
    String randomDesc = (listDesc..shuffle()).first;
    String randomItem = (listItem..shuffle()).first;
    String randomUserId = (listuserId..shuffle()).first;
    String randomNames = (listnames..shuffle()).first;
    String randomPlan = (listPlan..shuffle()).first;
    int randomPhone = (listPhones..shuffle()).first;
    int number2 = Random().nextInt(numbers.length);
    String randomType = (lisTypes..shuffle()).first;

    int prix = Random().nextInt(5000);
    String catego = listCat[0];
    String items = listItem[0];
    String desc = listDesc[0];
    double lat = 34 * Random().nextDouble(); //-90,90
    double long = -1 * Random().nextDouble(); //-180,180
    GeoPoint ramdomPosition = GeoPoint(lat, long);
    double randomStars = 34 * Random().nextDouble();
    int userItemsNbr = 0;

    final userA = UserClass(
      id: randomUserId,
      email: '$randomNames$number@gmail.DZ',
      phone: 0770548452,
      createdAt: DateTime.now(),
      avatar:
          'https://firebasestorage.googleapis.com/v0/b/oran-894b7.appspot.com/o/hotel_pics%2Fhotel%20($number2).jpg?alt=media&token=8d36274c-b1da-468e-b0c1-605ffd4a8b52', //''https://source.unsplash.com/random?sig=$number*3+1',
      timeline:
          'https://firebasestorage.googleapis.com/v0/b/oran-894b7.appspot.com/o/hotel_pics%2Fhotel%20($number).jpg?alt=media&token=8d36274c-b1da-468e-b0c1-605ffd4a8b52',
      displayName: randomNames,
      lastActive: DateTime.now().addYears(-37),
      role: 'public',
      state: true,
      plan: randomPlan,
      coins: 0.0,
      levelUser: '',
      stars: randomStars,
      userItemsNbr: userItemsNbr,
      views: 99,
      viewed_by: listuserId,
    );

    //userCollection.add(user_a);
    userCollection.doc(randomUserId).set(userA);

    final post = Post(
      userID: randomUserId,
      //'user$number' + randomItem,
      item: randomItem,
      //code: 'invoice$number',
      category: randomCat,
      price: prix,
      //'$prix'
      likes: Random().nextInt(1456),
      // '$number',//number,
      position: ramdomPosition,
      createdAt: DateTime.now(),
      decription: randomDesc,
      imageUrls: [
        'https://firebasestorage.googleapis.com/v0/b/oran-894b7.appspot.com/o/hotel_pics%2Fhotel%20($number2).jpg?alt=media&token=8d36274c-b1da-468e-b0c1-605ffd4a8b52'
      ],
      usersLike: ['sans'],
      themb:
          'https://firebasestorage.googleapis.com/v0/b/oran-894b7.appspot.com/o/hotel_pics%2Fhotel%20($number).jpg?alt=media&token=8d36274c-b1da-468e-b0c1-605ffd4a8b52',
      dateDebut: DateTime.now().add(const Duration(days: 4)),
      dateFin: DateTime.now().add(const Duration(days: 12)),
      levelItem: randomLevel,
      phone: randomPhone,
      views: 99,
      viewed_by: listuserId, type: randomType,
    );

    postCollection.add(post);
  }
}
