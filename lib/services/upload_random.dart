import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class upload_random extends StatefulWidget {
  const upload_random({Key? key}) : super(key: key);

  @override
  State<upload_random> createState() => _upload_randomState();
}

class _upload_randomState extends State<upload_random> {
  final TextEditingController _ItemsNumController = TextEditingController();

  //int itemNum = 1;

  @override
  Widget build(BuildContext context) {
    int itemsNum = 50; //int.parse(_ItemsNumController.text);
    _ItemsNumController.text.isEmpty ? 1 : int.parse(_ItemsNumController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Une Annonce'),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                uploadRandom(itemsNum);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _ItemsNumController,
              decoration: const InputDecoration(
                hintText: 'Enter likes',
                prefixIcon: Icon(
                  Icons.add_circle_outline,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
              child: ElevatedButton.icon(
            onPressed: () {
              uploadRandom(itemsNum);
            },
            icon: const Icon(Icons.add_chart),
            label: const Text(
              'ADD',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          )),
          const SizedBox(height: 15),
          Center(
              child: ElevatedButton.icon(
            onPressed: () {
              uploadRandomPub(itemsNum);
            },
            icon: const Icon(Icons.public),
            label: const Text(
              'ADDPub',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          )),
          const SizedBox(height: 15),
          Center(
              child: ElevatedButton.icon(
            onPressed: () {
              uploadRandomInstalives(itemsNum);
            },
            icon: const Icon(Icons.face),
            label: const Text(
              'InstaLives',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          )),
        ],
      ),
    );
  }

  // void uploadRandom() async {
  //   final postCollection =
  //       FirebaseFirestore.instance.collection('Products').withConverter<Post>(
  //             fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
  //             toFirestore: (post, _) => post.toJson(),
  //           );
  //   final numbers = List.generate(900, (index) => index + 1);
  //   for (final number in numbers) {
  //     List<String> listCat = [
  //       'Hotel',
  //       'Residence',
  //       'Agence',
  //       'Autres',
  //       'Sponsors',
  //     ];
  //     List<String> listItem = [
  //       'Adams',
  //       'Bakerti',
  //       'Clark',
  //       'Davisco',
  //       'Evanessance',
  //       'Frank',
  //       'Ghoshock',
  //       'Hills',
  //       'Irwintaro',
  //       'Jones',
  //       'Kleinez',
  //       'Lopez',
  //       'Mufasa',
  //       'Sarabi',
  //       'Simba',
  //       'Nala',
  //       'Kiara',
  //       'Kov',
  //       'Timon',
  //       'Pumbaama',
  //       'Rafora',
  //       'Shenzi',
  //       'Masoulna',
  //       'Naltyp',
  //       'Ochoa',
  //       'Patelroota',
  //       'Quinncom',
  //       'Reilyse',
  //       'Smith',
  //       'Trott',
  //       'Usman',
  //       'Valdorcomité',
  //       'White',
  //       'Xiangshemzhen',
  //       'Yakub',
  //       'Zafarta',
  //     ];
  //
  //     List<String> listDesc = [
  //       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  //       "Le président français Emmanuel Macron a assuré mardi avoir «obtenu» lors de ses discussions avec Vladimir Poutine «qu'il n'y ait pas de dégradation ni d'escalade» dans la crise russo-occidentale liée à l'Ukraine.",
  //       "L'organisation du Traité de l'Atlantique Nord (OTAN) est une alliance politique et militaire créée en 1949 dans le contexte de la guerre froide. Elle continue à jouer un rôle de premier plan dans le système de sécurité en Europe, même depuis la chute de l'URSS en 1991 et le délitement du Pacte de Varsovie (la contre-alliance du bloc soviétique). Ses extensions et sa relation privilégiée avec l'Ukraine sont au cœur des tensions actuelles avec la Russie. Explications en cartes.",
  //       "Quentin Fillon-Maillet : «Avec deux fautes au tir, je n'imaginais pas pouvoir jouer la victoire»",
  //       "ENQUÊTE - Faute d’avoir pu s’acquitter d’une traite faramineuse, le promoteur immobilier le plus fantasque de Los Angeles a perdu le contrôle de la gigantesque villa qu’il avait fait construire et dont il espérait tirer 500 millions de dollars. Son concepteur, ruiné, s’est exilé à Zurich.",
  //     ];
  //
  //     var randomCat = (listCat..shuffle()).first;
  //     var randomDesc = (listDesc..shuffle()).first;
  //     var randomItem = (listItem..shuffle()).first;
  //
  //     var prix = Random().nextInt(5000);
  //     var catego = listCat[0];
  //     var items = listItem[0];
  //     var desc = listDesc[0];
  //
  //     final post = Post(
  //         userID: 'user$number' + randomItem,
  //         item: randomItem,
  //         code: 'invoice$number',
  //         category: randomCat,
  //         price: '$prix',
  //         likes: '$number', //Random().nextInt(1000),
  //         createdAt: DateTime.now(),
  //         decription: randomDesc,
  //         imageUrl: 'https://source.unsplash.com/random?sig=$number',
  //         themb: 'https://source.unsplash.com/random?sig=$number');
  //     postCollection.add(post);
  //   }
  // }
  void uploadRandom(int itemsNum) async {
    final postCollection =
        FirebaseFirestore.instance.collection('Products').withConverter<Post>(
              fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
              toFirestore: (post, _) => post.toJson(),
            );
    final userCollection = FirebaseFirestore.instance
        .collection('Users')
        .withConverter<UserClass>(
          fromFirestore: (snapshot, _) => UserClass.fromJson(snapshot.data()!),
          toFirestore: (post, _) => post.toJson(),
        );

    final numbers = List.generate(itemsNum, (index) => index + 1);
    print('*****************************************************************');
    print(itemsNum.toString());

    for (final number in numbers) {
      List<String> listCat = [
        'Hotel',
        'Residence',
        'Agence',
        'Autres',
        'Sponsors',
      ];
      List<String> listItem = [
        "Laptop Lenovo IP3-15ITL6  / i5-1135G7 (2.4GHz)/ DDR4 8Go/SSD M,2 512 Gb/15.6 pouces FHD/ Intel Iris Xe + NVIDIA MX350 02Go/",
        "Laptop Lenovo ThinkBook i7-11th  (2.80 GHz) / DDR4 16Go / SSD M,2 256 Gb/ Ecran 15.6 pouces/ Intel Iris Xe Graphic + NVDIA GeForce  MX450",
        "Laptop Lenovo ThinkBook i7-11th  (2.80 GHz) / DDR4 16Go / SSD  1Tr/ Ecran 15.6 pouces/ Intel Iris Xe Graphic + NVDIA GeForce  MX451",
        "Micro All in One ENGIMA  EN238F i5_8Go_HDD500  Avec Batterie",
        "Micro All in One HP 200 G4 Silver/ J5040 / 4Gb / 1Tb / WiFi / Webcam / DVD-RW / ECRAN 21.5 pouces FHD",
        "Micro All in One Lenovo V30A / i3-10110U (2.10 GHz)/ DDR4 4 Go / HDD1TB / WIFI+WEBCAM / DVD.RW / Ecran 21.5 pouces",
        "Micro All in One Lenovo V30A / i3-10110U (2.10 GHz)/ DDR4 8 Go / SSD M,2 256 Gb / WIFI+WEBCAM / DVD.RW / Ecran 21.5 pouces",
        "Imprimante HP 7110 Wifi A3 Couleur (HP932_HP933)",
        "Imprimante Laser-jet CANON LBP226DW WiFi+ Recto et verso (057)",
        "Multifonction Laser-jet CANON MF237W Avec FAX+WiFi+Carouche 737 Org",
        "Imprimante EPSON Matricielle LX 300+",
        "Imprimante EPSON Matricielle LQ2090",
        "Photocopieur  Kyocera Ecosys FS-1025 MFP Réseau",
        "Ecran TACTIL 17 pouces",
        "Lecteur Cartes Chifa gemalto",
        "Imprimante Code Barre IT-POS Ref IT-2120",
        "Souris HAVIT Wireless HV-MS 624 GT  Rechrgable",
        "Souris ZELOTES Wireless Orthopédique F-17",
        "Casque Microphone  TWINS TW-809",
        "Casque Microphone  CAPSYS HD-808",
        "Cable USB LDNIO LS411 Type C",
        "Cable USB LDNIO LS411 Micro USB",
        "Batterie HP Probook RO04 430 G3_4430 G3_ 440 G3_HSTNN-PB6P",
        "Batterie HP ProBook G2-VI04 / 440_450_Q140_Pavilion 14-V / 15-P / 17",
        "Batterie SAMSUNG NP-N148_N150 ( C.Noir )",
        "Film De Four CANON 2900_1010_6030",
        "Kit Tambour CANON IR2016_2318_2020_2420",
        "Kit Tambour CANON IR2520",
        "Kit Tambour HP1025_LBP 7010_7018",
        "Tambour Brother DR1000_TN1050_HL1110 Goodhal",
        "Tambour Brother TN350 HL2035",
        "Tambour CANON IR2520",
        "Tambour KYOCERA FS-1016_1030_2030",
        "Ventilo Laptop 15 pouces N133",
        "Ventilo Laptop 15 pouces-17 pouces - S18",
        "Ventilo Laptop 15 pouces-17 pouces N88",
      ];

      List<String> listDesc = [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "Le président français Emmanuel Macron a assuré mardi avoir «obtenu» lors de ses discussions avec Vladimir Poutine «qu'il n'y ait pas de dégradation ni d'escalade» dans la crise russo-occidentale liée à l'Ukraine.",
        "L'organisation du Traité de l'Atlantique Nord (OTAN) est une alliance politique et militaire créée en 1949 dans le contexte de la guerre froide. Elle continue à jouer un rôle de premier plan dans le système de sécurité en Europe, même depuis la chute de l'URSS en 1991 et le délitement du Pacte de Varsovie (la contre-alliance du bloc soviétique). Ses extensions et sa relation privilégiée avec l'Ukraine sont au cœur des tensions actuelles avec la Russie. Explications en cartes.",
        "Quentin Fillon-Maillet : «Avec deux fautes au tir, je n'imaginais pas pouvoir jouer la victoire»",
        "ENQUÊTE - Faute d’avoir pu s’acquitter d’une traite faramineuse, le promoteur immobilier le plus fantasque de Los Angeles a perdu le contrôle de la gigantesque villa qu’il avait fait construire et dont il espérait tirer 500 millions de dollars. Son concepteur, ruiné, s’est exilé à Zurich.",
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
      String randomCat = (listCat..shuffle()).first;
      String randomLevel = (listLevel..shuffle()).first;
      String randomDesc = (listDesc..shuffle()).first;
      String randomItem = (listItem..shuffle()).first;
      String randomUserId = (listuserId..shuffle()).first;
      String randomNames = (listnames..shuffle()).first;
      String randomPlan = (listPlan..shuffle()).first;
      int randomPhone = (listPhones..shuffle()).first;

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
        avatar: 'https://source.unsplash.com/random?sig=$number*3+1',
        timeline: 'https://source.unsplash.com/random?sig=$number*3',
        displayName: randomNames,
        lastActive: DateTime.now().addYears(-37),
        role: 'public',
        state: true,
        plan: randomPlan,
        coins: 0.0,
        levelUser: '',
        stars: randomStars,
        userItemsNbr: userItemsNbr,
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
        imageUrls: ['https://source.unsplash.com/random?sig=$number+1'],
        usersLike: ['sans'],
        themb: 'https://source.unsplash.com/random?sig=$number+1',
        dateDebut: DateTime.now().add(const Duration(days: 4)),
        dateFin: DateTime.now().add(const Duration(days: 12)),
        levelItem: randomLevel,
        phone: randomPhone,
      );

      postCollection.add(post);
    }
  }

  void uploadRandomPub(int itemsNum) async {
    final postCollection =
        FirebaseFirestore.instance.collection('Caroussel').withConverter<Post>(
              fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
              toFirestore: (post, _) => post.toJson(),
            );

    final numbers = List.generate(itemsNum, (index) => index + 1);
    print('*****************************************************************');
    print(itemsNum.toString());

    for (final number in numbers) {
      List<String> listCat = [
        'Hotel',
        'Residence',
        'Agence',
        'Autres',
        'Sponsors',
      ];
      List<String> listItem = [
        "Laptop Lenovo IP3-15ITL6  / i5-1135G7 (2.4GHz)/ DDR4 8Go/SSD M,2 512 Gb/15.6 pouces FHD/ Intel Iris Xe + NVIDIA MX350 02Go/",
        "Laptop Lenovo ThinkBook i7-11th  (2.80 GHz) / DDR4 16Go / SSD M,2 256 Gb/ Ecran 15.6 pouces/ Intel Iris Xe Graphic + NVDIA GeForce  MX450",
        "Laptop Lenovo ThinkBook i7-11th  (2.80 GHz) / DDR4 16Go / SSD  1Tr/ Ecran 15.6 pouces/ Intel Iris Xe Graphic + NVDIA GeForce  MX451",
        "Micro All in One ENGIMA  EN238F i5_8Go_HDD500  Avec Batterie",
        "Micro All in One HP 200 G4 Silver/ J5040 / 4Gb / 1Tb / WiFi / Webcam / DVD-RW / ECRAN 21.5 pouces FHD",
        "Micro All in One Lenovo V30A / i3-10110U (2.10 GHz)/ DDR4 4 Go / HDD1TB / WIFI+WEBCAM / DVD.RW / Ecran 21.5 pouces",
        "Micro All in One Lenovo V30A / i3-10110U (2.10 GHz)/ DDR4 8 Go / SSD M,2 256 Gb / WIFI+WEBCAM / DVD.RW / Ecran 21.5 pouces",
        "Imprimante HP 7110 Wifi A3 Couleur (HP932_HP933)",
        "Imprimante Laser-jet CANON LBP226DW WiFi+ Recto et verso (057)",
        "Multifonction Laser-jet CANON MF237W Avec FAX+WiFi+Carouche 737 Org",
        "Imprimante EPSON Matricielle LX 300+",
        "Imprimante EPSON Matricielle LQ2090",
        "Photocopieur  Kyocera Ecosys FS-1025 MFP Réseau",
        "Ecran TACTIL 17 pouces",
        "Lecteur Cartes Chifa gemalto",
        "Imprimante Code Barre IT-POS Ref IT-2120",
        "Souris HAVIT Wireless HV-MS 624 GT  Rechrgable",
        "Souris ZELOTES Wireless Orthopédique F-17",
        "Casque Microphone  TWINS TW-809",
        "Casque Microphone  CAPSYS HD-808",
        "Cable USB LDNIO LS411 Type C",
        "Cable USB LDNIO LS411 Micro USB",
        "Batterie HP Probook RO04 430 G3_4430 G3_ 440 G3_HSTNN-PB6P",
        "Batterie HP ProBook G2-VI04 / 440_450_Q140_Pavilion 14-V / 15-P / 17",
        "Batterie SAMSUNG NP-N148_N150 ( C.Noir )",
        "Film De Four CANON 2900_1010_6030",
        "Kit Tambour CANON IR2016_2318_2020_2420",
        "Kit Tambour CANON IR2520",
        "Kit Tambour HP1025_LBP 7010_7018",
        "Tambour Brother DR1000_TN1050_HL1110 Goodhal",
        "Tambour Brother TN350 HL2035",
        "Tambour CANON IR2520",
        "Tambour KYOCERA FS-1016_1030_2030",
        "Ventilo Laptop 15 pouces N133",
        "Ventilo Laptop 15 pouces-17 pouces - S18",
        "Ventilo Laptop 15 pouces-17 pouces N88",
      ];
      List<String> listDesc = [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "Le président français Emmanuel Macron a assuré mardi avoir «obtenu» lors de ses discussions avec Vladimir Poutine «qu'il n'y ait pas de dégradation ni d'escalade» dans la crise russo-occidentale liée à l'Ukraine.",
        "L'organisation du Traité de l'Atlantique Nord (OTAN) est une alliance politique et militaire créée en 1949 dans le contexte de la guerre froide. Elle continue à jouer un rôle de premier plan dans le système de sécurité en Europe, même depuis la chute de l'URSS en 1991 et le délitement du Pacte de Varsovie (la contre-alliance du bloc soviétique). Ses extensions et sa relation privilégiée avec l'Ukraine sont au cœur des tensions actuelles avec la Russie. Explications en cartes.",
        "Quentin Fillon-Maillet : «Avec deux fautes au tir, je n'imaginais pas pouvoir jouer la victoire»",
        "ENQUÊTE - Faute d’avoir pu s’acquitter d’une traite faramineuse, le promoteur immobilier le plus fantasque de Los Angeles a perdu le contrôle de la gigantesque villa qu’il avait fait construire et dont il espérait tirer 500 millions de dollars. Son concepteur, ruiné, s’est exilé à Zurich.",
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
      List<String> listuserId = [
        'QGAVoJBwh3PnXAoksXprwbOjC3L2',
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
      String randomCat = (listCat..shuffle()).first;
      String randomLevel = (listLevel..shuffle()).first;
      String randomDesc = (listDesc..shuffle()).first;
      String randomItem = (listItem..shuffle()).first;
      String randomUserId = (listuserId..shuffle()).first;
      String randomNames = (listnames..shuffle()).first;
      int randomPhones = (listPhones..shuffle()).first;
      int prix = Random().nextInt(5000);
      String catego = listCat[0];
      String items = listItem[0];
      String desc = listDesc[0];
      double lat = 34 * Random().nextDouble(); //-90,90
      double long = -1 * Random().nextDouble(); //-180,180
      GeoPoint ramdomPosition = GeoPoint(lat, long);

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
          imageUrls: ['https://source.unsplash.com/random?sig=$number+1'],
          usersLike: ['sans'],
          themb: 'https://source.unsplash.com/random?sig=$number+1',
          dateDebut: DateTime.now().add(const Duration(days: 4)),
          dateFin: DateTime.now().add(const Duration(days: 12)),
          levelItem: randomLevel,
          phone: randomPhones);

      postCollection
          .add(post)
          .whenComplete(() => debugPrint('c bon caroussel'));
    }
  }

  void uploadRandomInstalives(int itemsNum) async {
    final postCollection =
        FirebaseFirestore.instance.collection('Instalives').withConverter<Post>(
              fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
              toFirestore: (post, _) => post.toJson(),
            );

    final numbers = List.generate(itemsNum, (index) => index + 1);
    print('*****************************************************************');
    print(itemsNum.toString());

    for (final number in numbers) {
      List<String> listCat = [
        'Hotel',
        'Residence',
        'Agence',
        'Autres',
        'Sponsors',
      ];
      List<String> listItem = [
        "Laptop Lenovo IP3-15ITL6  / i5-1135G7 (2.4GHz)/ DDR4 8Go/SSD M,2 512 Gb/15.6 pouces FHD/ Intel Iris Xe + NVIDIA MX350 02Go/",
        "Laptop Lenovo ThinkBook i7-11th  (2.80 GHz) / DDR4 16Go / SSD M,2 256 Gb/ Ecran 15.6 pouces/ Intel Iris Xe Graphic + NVDIA GeForce  MX450",
        "Laptop Lenovo ThinkBook i7-11th  (2.80 GHz) / DDR4 16Go / SSD  1Tr/ Ecran 15.6 pouces/ Intel Iris Xe Graphic + NVDIA GeForce  MX451",
        "Micro All in One ENGIMA  EN238F i5_8Go_HDD500  Avec Batterie",
        "Micro All in One HP 200 G4 Silver/ J5040 / 4Gb / 1Tb / WiFi / Webcam / DVD-RW / ECRAN 21.5 pouces FHD",
        "Micro All in One Lenovo V30A / i3-10110U (2.10 GHz)/ DDR4 4 Go / HDD1TB / WIFI+WEBCAM / DVD.RW / Ecran 21.5 pouces",
        "Micro All in One Lenovo V30A / i3-10110U (2.10 GHz)/ DDR4 8 Go / SSD M,2 256 Gb / WIFI+WEBCAM / DVD.RW / Ecran 21.5 pouces",
        "Imprimante HP 7110 Wifi A3 Couleur (HP932_HP933)",
        "Imprimante Laser-jet CANON LBP226DW WiFi+ Recto et verso (057)",
        "Multifonction Laser-jet CANON MF237W Avec FAX+WiFi+Carouche 737 Org",
        "Imprimante EPSON Matricielle LX 300+",
        "Imprimante EPSON Matricielle LQ2090",
        "Photocopieur  Kyocera Ecosys FS-1025 MFP Réseau",
        "Ecran TACTIL 17 pouces",
        "Lecteur Cartes Chifa gemalto",
        "Imprimante Code Barre IT-POS Ref IT-2120",
        "Souris HAVIT Wireless HV-MS 624 GT  Rechrgable",
        "Souris ZELOTES Wireless Orthopédique F-17",
        "Casque Microphone  TWINS TW-809",
        "Casque Microphone  CAPSYS HD-808",
        "Cable USB LDNIO LS411 Type C",
        "Cable USB LDNIO LS411 Micro USB",
        "Batterie HP Probook RO04 430 G3_4430 G3_ 440 G3_HSTNN-PB6P",
        "Batterie HP ProBook G2-VI04 / 440_450_Q140_Pavilion 14-V / 15-P / 17",
        "Batterie SAMSUNG NP-N148_N150 ( C.Noir )",
        "Film De Four CANON 2900_1010_6030",
        "Kit Tambour CANON IR2016_2318_2020_2420",
        "Kit Tambour CANON IR2520",
        "Kit Tambour HP1025_LBP 7010_7018",
        "Tambour Brother DR1000_TN1050_HL1110 Goodhal",
        "Tambour Brother TN350 HL2035",
        "Tambour CANON IR2520",
        "Tambour KYOCERA FS-1016_1030_2030",
        "Ventilo Laptop 15 pouces N133",
        "Ventilo Laptop 15 pouces-17 pouces - S18",
        "Ventilo Laptop 15 pouces-17 pouces N88",
      ];
      List<String> listDesc = [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "Le président français Emmanuel Macron a assuré mardi avoir «obtenu» lors de ses discussions avec Vladimir Poutine «qu'il n'y ait pas de dégradation ni d'escalade» dans la crise russo-occidentale liée à l'Ukraine.",
        "L'organisation du Traité de l'Atlantique Nord (OTAN) est une alliance politique et militaire créée en 1949 dans le contexte de la guerre froide. Elle continue à jouer un rôle de premier plan dans le système de sécurité en Europe, même depuis la chute de l'URSS en 1991 et le délitement du Pacte de Varsovie (la contre-alliance du bloc soviétique). Ses extensions et sa relation privilégiée avec l'Ukraine sont au cœur des tensions actuelles avec la Russie. Explications en cartes.",
        "Quentin Fillon-Maillet : «Avec deux fautes au tir, je n'imaginais pas pouvoir jouer la victoire»",
        "ENQUÊTE - Faute d’avoir pu s’acquitter d’une traite faramineuse, le promoteur immobilier le plus fantasque de Los Angeles a perdu le contrôle de la gigantesque villa qu’il avait fait construire et dont il espérait tirer 500 millions de dollars. Son concepteur, ruiné, s’est exilé à Zurich.",
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
      List<String> listuserId = [
        'QGAVoJBwh3PnXAoksXprwbOjC3L2',
        'oZknAZY63gT13DUTUvnx5NAz83B2',
        'GbrwkfGl0Zg6BO0YewKTBN7H0U02',
        'DA0uLaRQNnhebV6pJmX2ThsYmQe2',
        'lqkshlkqshflkshf',
        '12354687976554654',
        '98764543121',
        'ramzi',
        'kenzi',
        'danilselyane'
      ];
      List<int> listPhones = [
        0770852896,
        0668142852,
        0555987412,
        0789654123,
        0674258741,
        0550412365,
      ];
      String randomCat = (listCat..shuffle()).first;
      String randomLevel = (listLevel..shuffle()).first;
      String randomDesc = (listDesc..shuffle()).first;
      String randomItem = (listItem..shuffle()).first;
      String randomUserId = (listuserId..shuffle()).first;
      String randomNames = (listnames..shuffle()).first;
      int randomPhones = (listPhones..shuffle()).first;

      int prix = Random().nextInt(5000);
      String catego = listCat[0];
      String items = listItem[0];
      String desc = listDesc[0];
      double lat = 34 * Random().nextDouble(); //-90,90
      double long = -1 * Random().nextDouble(); //-180,180
      GeoPoint ramdomPosition = GeoPoint(lat, long);

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
        imageUrls: ['https://source.unsplash.com/random?sig=$number+1'],
        usersLike: ['sans'],
        themb: 'https://source.unsplash.com/random?sig=$number+1',
        dateDebut: DateTime.now().add(const Duration(days: 4)),
        dateFin: DateTime.now().add(const Duration(days: 12)),
        levelItem: randomLevel,
        phone: randomPhones,
      );

      postCollection
          .add(post)
          .whenComplete(() => debugPrint('c bon caroussel'));
    }
  }
}

class Post {
  final String userID;
  final String item;
  final String category;
  final int likes;
  final int price;
  final DateTime createdAt;
  final List imageUrls;
  final String themb;
  final String decription;
  final List usersLike;
  final DateTime dateDebut;
  final DateTime dateFin;
  final GeoPoint position;
  final String levelItem;
  final int phone;

  const Post({
    required this.userID,
    required this.item,
    required this.price,
    required this.category,
    required this.likes,
    required this.createdAt,
    required this.imageUrls,
    required this.themb,
    required this.decription,
    required this.usersLike,
    required this.dateDebut,
    required this.dateFin,
    required this.position,
    required this.levelItem,
    required this.phone,
  });
  Post.fromJson(Map<String, Object?> json)
      : this(
          userID: json['userID']! as String,
          item: json['item']! as String,
          category: json['category']! as String,
          likes: json['likes']! as int,
          price: json['price']! as int,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          decription: json['Description']! as String,
          imageUrls: json['imageUrls']! as List,
          themb: json['themb']! as String,
          usersLike: json['usersLike'] as List,
          dateDebut: (json['dateDebut']! as Timestamp).toDate(),
          dateFin: (json['dateFin']! as Timestamp).toDate(),
          position: json['position'] as GeoPoint,
          levelItem: json['levelItem']! as String,
          phone: json['phone'] as int,
        );
  Map<String, Object?> toJson() => {
        'userID': userID,
        'likes': likes,
        'createdAt': createdAt,
        'imageUrls': imageUrls,
        'themb': themb,
        "item": item,
        'price': price, // + '.00 dzd ',
        'category': category,
        'Description': decription,
        'usersLike': usersLike,
        'dateDebut': dateDebut,
        'dateFin': dateFin,
        'position': position,
        'levelItem': levelItem,
        'phone': phone,
      };
}

class UserClass {
  final String id;
  final int phone;
  final String email;
  final DateTime createdAt;
  final String avatar;
  final String timeline;
  final String displayName;
  final DateTime lastActive;
  final bool state;
  final String role;
  final String plan;
  final double coins;
  final String levelUser;
  final double stars;
  final int userItemsNbr;
  UserClass({
    required this.id,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.avatar,
    required this.timeline,
    required this.displayName,
    required this.lastActive,
    required this.role,
    required this.state,
    required this.plan,
    required this.coins,
    required this.levelUser,
    required this.stars,
    required this.userItemsNbr,
  });
  UserClass.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          phone: json['phone'] as int,
          email: json['email']! as String,
          avatar: json['avatar']! as String,
          timeline: json['timeline']! as String,
          createdAt: (json['createdAt']! as Timestamp).toDate(),
          displayName: json['displayName']! as String,
          role: json['role']! as String,
          lastActive: (json['lastActive']! as Timestamp).toDate(),
          state: json['state']! as bool,
          plan: json['plan']! as String,
          coins: json['coins'] as double,
          levelUser: json['levelUser']! as String,
          stars: json['stars'] as double,
          userItemsNbr: json['userItemsNbr'] as int,
        );

  Map<String, Object?> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'createdAt': createdAt,
        'avatar': avatar,
        'timeline': timeline,
        'displayName': displayName,
        'lastActive': lastActive,
        'role': role,
        'state': state,
        'plan': plan,
        'coins': coins,
        'levelUser': levelUser,
        'stars': stars,
        'userItemsNbr': userItemsNbr,
      };
}
