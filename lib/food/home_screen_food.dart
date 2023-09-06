import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import '../food/testlist.dart';
import '../food/addFood.dart';
import '../food/carts.dart';
import 'package:ramzy/food/list_food_Models.dart';
import '../food/DetailFood.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:intl/intl.dart' as intl;
import 'package:screenshot/screenshot.dart';

class FirestoreDataProvider {
  List<Map<String, dynamic>>? cachedData;

  Future<List<Map<String, dynamic>>> fetchData() async {
    if (cachedData == null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Foods')
          .orderBy('item')
          .get();

      cachedData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }

    return cachedData ?? [];
  }

  // Query _getQueryFromCachedDataAndFilter(String? selectedCategory) {
  //   Query query = FirebaseFirestore.instance.collection('Foods');
  //
  //   if (selectedCategory != null) {
  //     query = query.where('cat', isEqualTo: selectedCategory);
  //   }
  //
  //   return query;
  // }
  //
  Future<List<Map<String, dynamic>>> _getFutureDataFromCachedData() async {
    await fetchData();
    // print(cachedData);
    return cachedData ?? [];
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}

class HomeScreen_food extends StatefulWidget {
  const HomeScreen_food({
    Key? key,
    required this.userDoc,
  }) : super(key: key);
  final userDoc;

  @override
  State<HomeScreen_food> createState() => _HomeScreen_foodState();
}

class _HomeScreen_foodState extends State<HomeScreen_food>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double turns = 0.0;

  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Contrôle la vitesse de rotation
    )..repeat(); // Répète l'animation en continu
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addFoodListToFirestore(List<ListFood> foodList) async {
    final CollectionReference foodsCollection =
        FirebaseFirestore.instance.collection('Foods');

    for (var food in foodList) {
      await foodsCollection.add({
        'item': food.item,
        'desc': food.desc,
        'image': food.image,
        'flav': food.flav,
        'price': food.price,
        'cat': food.cat,
        'createdAt': food.createdAt,
        'user': food.user,
      });
    }

    //  print('Food list added to Firestore.');
  }

  final FirestoreDataProvider provider = FirestoreDataProvider();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    String catSelected = 'pizza'; // Initialisez cela selon votre besoin

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Firestore Example'),
      // ),
      body: PaginateFirestore(
        header: SliverToBoxAdapter(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                        widget.userDoc['avatar'],
                      )),
                    ),
                    IconButton.outlined(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PizzaForm(),
                          ));
                        },
                        icon: Icon(
                          Icons.add,
                        )),
                    // IconButton(
                    //     onPressed: () =>
                    //         Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => HomeScreenFood2(
                    //             userDoc: widget.userDoc,
                    //           ),
                    //         )),
                    //     icon: Icon(Icons.account_balance)),
                    Container(
                      width: 40,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CartPage())),
                        child: RotationTransition(
                          turns:
                              Tween(begin: 0.0, end: 1.0).animate(_controller),
                          child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                            "https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg",
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello " +
                          widget.userDoc['displayName']
                              .toString()
                              .toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "What flavour do you want today?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                      child: GestureDetector(
                        onTap: () {
                          // addFoodListToFirestore(foodList);
                          // print('foodList');
                        },
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg",
                            maxHeight: 30,
                            maxWidth: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 15),
                  margin: EdgeInsets.only(bottom: 10),
                  height: 350,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: provider._getFutureDataFromCachedData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Erreur : ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('Aucune donnée disponible.');
                      }

                      List<Map<String, dynamic>> foodDocs = snapshot.data!;
                      return buildListViewFutureBuilder(foodDocs);
                    },
                  )),
              Container(
                  height: 50,
                  child: Container(
                    height: 50,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: FirestoreDataProvider().fetchData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Une erreur s\'est produite : ${snapshot.error}');
                        } else {
                          List<Map<String, dynamic>> cachedData =
                              snapshot.data!;

                          // Récupérer les catégories uniques à partir des données
                          List<String> uniqueCategories = cachedData
                              .map((item) => item['cat'] as String)
                              .toSet()
                              .toList();
                          // print(uniqueCategories);
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: uniqueCategories.length,
                            itemBuilder: (context, index) {
                              String category = uniqueCategories[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      catSelected = category;
                                    });
                                    print(catSelected);
                                  },
                                  child: Text(
                                    category,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  )),
              // Container(
              //   height: 50,
              //   child: FutureBuilder<List<Map<String, dynamic>>>(
              //     future:
              //         provider.getUniqueCategories(documents),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return CircularProgressIndicator();
              //       }
              //
              //       if (snapshot.hasError) {
              //         return Text('Erreur : ${snapshot.error}');
              //       }
              //
              //       if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //         return Text('Aucune donnée disponible.');
              //       }
              //
              //       List<String> uniqueCategories = snapshot.data!;
              //
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         scrollDirection: Axis.horizontal,
              //         itemCount: uniqueCategories.length,
              //         itemBuilder: (context, index) {
              //           String category = uniqueCategories[index];
              //           bool isSelected = selectedCategory == category;
              //
              //           return GestureDetector(
              //             onTap: () {
              //               setState(() {
              //                 selectedCategory = isSelected ? null : category;
              //               });
              //             },
              //             child: Container(
              //               margin: EdgeInsets.all(10),
              //               padding: EdgeInsets.symmetric(
              //                   horizontal: 15, vertical: 5),
              //               decoration: BoxDecoration(
              //                 color: isSelected ? Colors.blue : Colors.grey,
              //                 borderRadius: BorderRadius.circular(15),
              //               ),
              //               child: Text(
              //                 category,
              //                 style: TextStyle(
              //                   color: isSelected ? Colors.red : Colors.black,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     },
              //   ),
              // )
            ],
          ),
        ),
        onEmpty: Center(
          child: FittedBox(
            child: Text(
              'En Construction',
              style: TextStyle(fontSize: 40, color: Colors.black45),
            ),
          ),
        ),
        separator: const EmptySeparator(),
        initialLoader: const InitialLoader(),
        bottomLoader: const BottomLoader(),
        shrinkWrap: true,
        isLive: true,
        itemBuilderType: PaginateBuilderType.listView,
        query: FirebaseFirestore.instance
            .collection('Foods')
            .where('cat', isEqualTo: catSelected),

        //provider._getQueryFromCachedDataAndFilter(catSelected),
        itemBuilder: (BuildContext context, List<DocumentSnapshot> snapshotList,
            int index) {
          var data = snapshotList[index].data() as Map<String, dynamic>;
          ListFood food = ListFood(
            item: data['item'],
            desc: data['desc'],
            price: (data['price'] ?? 0).toInt(),
            image: data['image'],
            flav: data['flav'],
            cat: data['cat'] ?? '',
            createdAt: data['createdAt'],
            user: data['user'],
            docId: data['docId'],
          );

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DetailFood(food: food);
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(data['image']),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth / 2.1,
                              child: Text(
                                data['item'].toString(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: provider.isArabic(
                                  data['item'],
                                )
                                    ? TextAlign.right
                                    : TextAlign.left,
                                style: provider.isArabic(
                                  data['item'],
                                )
                                    ? GoogleFonts.cairo(
                                        // textStyle: Theme.of(context).textTheme.headline4,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)
                                    : TextStyle(
                                        // color: Colors.white70,
                                        fontSize: 16,
                                      ),
                              ),
                            ),
                            Text(food.cat),
                            Text(
                              intl.NumberFormat.currency(
                                symbol: 'DZD ',
                                decimalDigits: 2,
                              ).format(data['price']),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  FavB(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ListView buildListViewFutureBuilder(List<Map<String, dynamic>> foodDocs) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: foodDocs.length,
      itemBuilder: (context, index) {
        final foodMap = foodDocs[index];
        final food =
            ListFood.fromMap(foodMap); // Use fromMap instead of fromSnapshot
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return DetailFood(food: food);
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(right: 15, left: 0),
            width: 250,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 1,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 342,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          food.image,
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: IntrinsicHeight(
                          child: Container(
                            color: Colors.black45.withAlpha(70),
                            padding:
                                EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  food.item.toString().toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: provider.isArabic(
                                    food.item,
                                  )
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: provider.isArabic(
                                    food.item,
                                  )
                                      ? GoogleFonts.cairo(
                                          // textStyle: Theme.of(context).textTheme.headline4,
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800)
                                      : TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                ),
                                Text(
                                  food.flav,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: provider.isArabic(
                                    food.flav,
                                  )
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: provider.isArabic(
                                    food.flav,
                                  )
                                      ? GoogleFonts.cairo(
                                          // textStyle: Theme.of(context).textTheme.headline4,
                                          fontSize: 16,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600)
                                      : TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                ),
                                Text(
                                  food.flav,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                Divider(
                                  color: Colors.white70,
                                ),
                                Text(
                                  intl.NumberFormat.currency(
                                    symbol: 'DZD ',
                                    decimalDigits: 2,
                                  ).format(food.price),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FavB extends StatefulWidget {
  const FavB({Key? key}) : super(key: key);

  @override
  State<FavB> createState() => _FavBState();
}

class _FavBState extends State<FavB> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isFav = !isFav;
        });
      },
      icon: Icon(
        isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
        color: Color(0xffFF5F99),
        size: 24.0,
      ),
    );
  }
}
