import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:ramzy/food/fav.dart';
import 'package:ramzy/food/favShared.dart';
import 'package:ramzy/food/webScrab.dart';
import 'package:ramzy/food2/home.dart';
import 'package:ramzy/food2/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../food/addFood.dart';
import '../food/carts.dart';
import 'package:ramzy/food/list_food_Models.dart';
import '../food/DetailFood.dart';
import 'package:intl/intl.dart' as intl;

class ItemManager {
  List<String> favoriteItemIds = [];

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteItemIds = prefs.getStringList('favoriteItemIds') ?? [];
  }

  Future<void> toggleFavorite(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    if (favoriteItemIds.contains(itemId)) {
      favoriteItemIds.remove(itemId);
    } else {
      favoriteItemIds.add(itemId);
    }
    prefs.setStringList('favoriteItemIds', favoriteItemIds);
  }

  bool isFavorite(String itemId) {
    return favoriteItemIds.contains(itemId);
  }
}

class MyTabCategory extends StatefulWidget {
  const MyTabCategory({
    Key? key,
    required this.userDoc,
  }) : super(key: key);
  final userDoc;

  @override
  State<MyTabCategory> createState() => _MyTabCategoryState();
}

class _MyTabCategoryState extends State<MyTabCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ItemManager itemManager = ItemManager();
  List<String> favoriteItemIds = [];
  List<Map> itemsList = [];
  List<String> uniqueCategories = [];

  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 5), // Contrôle la vitesse de rotation
    // )..repeat(); // Répète l'animation en continu
    itemManager.loadFavorites();
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> selectedCategories = [];
  List<Map<String, dynamic>>? cachedData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData(); // Fetch data when the widget is created
  }

  Future<void> fetchData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Foods').get();

      List<Map> allItems = [];
      List<String> allCategories = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data()
            as Map<String, dynamic>; // Extract data from the document

        allItems.add(data);

        String category = data['cat'] as String;
        if (!allCategories.contains(category)) {
          allCategories.add(category);
        }
      }

      setState(() {
        itemsList = allItems;
        uniqueCategories = allCategories;

        // Initialize the TabController with the correct length
        _tabController =
            TabController(length: uniqueCategories.length, vsync: this);
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAndProcessData() async {
    await fetchData(); // Call the fetchData function
    List<Map<String, dynamic>> processedData = itemsList
        .map((dynamicMap) => dynamicMap.cast<String, dynamic>())
        .toList();
    return processedData; // Return the processed data with the correct type
  }

  List<Map<dynamic, dynamic>> filterItemsByCategory(String category) {
    return itemsList.where((element) {
      String itemCategory = element['cat']
          as String; // Assurez-vous que 'cat' est la clé correcte dans votre Map
      return itemCategory == category; // Compare avec la catégorie sélectionnée
    }).toList();
  }

////////////////////////////////////////////////////////////////////////////////
// Update the items list based on the favorite status
  void updateItemList() {
    setState(() {
      // Mise à jour de la liste d'items à partir de votre source de données
      // Par exemple, si vous avez une liste de tous les items, vous pouvez filtrer ici les favoris.
      itemsList = itemsList
          .where((item) => itemManager.isFavorite(item['docId']))
          .toList();
    });
  }

////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: uniqueCategories.isEmpty // Check if uniqueCategories is empty
            ? Center(
                child: InkWell(
                  radius: 100,
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => MyAppmainWeb())),
                  child: Container(
                    height: 200,
                    width: 200,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          'https://vietnamdecouverte.com/pic/blog/images/cuisine%20vietnam(1).jpg'),
                    ),
                  ),
                ),
              ) // Show a loading indicator while fetching data
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
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
                          IconButton.outlined(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FoodHome(),
                                ));
                              },
                              icon: Icon(
                                Icons.adb_outlined,
                              )),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FavoritesPage();
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.favorite),
                          ),
                          pizzaAnime(
                              url:
                                  "https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg"),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                  ),
                  SliverToBoxAdapter(
                    child: Container(
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
                          pizzaAnime(
                              url:
                                  "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg"),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        padding: EdgeInsets.only(left: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        height: 350,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future:
                              fetchAndProcessData(), // Use the new function to get the data
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Erreur : ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Text('Aucune donnée disponible.');
                            }

                            List<Map<String, dynamic>> foodDocs =
                                snapshot.data!;

                            return buildListViewFutureBuilder(foodDocs);
                          },
                        )),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 60,
                      child: TabBar(
                        physics: BouncingScrollPhysics(),
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: Colors.blue,
                        indicatorWeight: 2.0,
                        unselectedLabelColor: Colors.blueGrey,
                        labelColor: Colors.orange,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal),
                        tabs: uniqueCategories.map((category) {
                          return Tab(
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                          "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg")),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  category.toString().capitalize(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: _tabController,
                      children: uniqueCategories.map((category) {
                        final filterItems = filterItemsByCategory(category);

                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filterItems.length,
                            itemBuilder: (context, index) {
                              final data = filterItems[index];

                              ListFood food = ListFood(
                                docId: data['docId'],
                                item: data['item'],
                                desc: data['desc'],
                                price: (data['price'] ?? 0).toInt(),
                                image: data['image'],
                                flav: data['flav'],
                                cat: data['cat'] ?? '',
                                createdAt: data['createdAt'],
                                user: data['user'],
                              );

                              bool isFavorite = itemManager.isFavorite(food
                                  .docId); // Use itemManager to check if an item is a favorite.

                              return InkWell(
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        data['image']),
                                                fit: BoxFit.cover,
                                                alignment: Alignment.topCenter,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: screenWidth / 2.1,
                                                  child: Text(
                                                    data['item'].toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        isArabic(data['item'])
                                                            ? GoogleFonts.cairo(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              )
                                                            : TextStyle(
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (isFavorite) {
                                              itemManager.toggleFavorite(food
                                                  .docId); // Use itemManager to toggle favorites.
                                            } else {
                                              itemManager.toggleFavorite(food
                                                  .docId); // Use itemManager to toggle favorites.
                                            }
                                            // No need to updateItemList() here since you're using the itemManager to manage favorites.
                                          });
                                        },
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavorite ? Colors.red : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
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
                                  textAlign: isArabic(
                                    food.item,
                                  )
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: isArabic(
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
                                  textAlign: isArabic(
                                    food.flav,
                                  )
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: isArabic(
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

// class FavB extends StatefulWidget {
//   const FavB({Key? key}) : super(key: key);
//
//   @override
//   State<FavB> createState() => _FavBState();
// }
//
// class _FavBState extends State<FavB> {
//   bool isFav = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         setState(() {
//           isFav = !isFav;
//         });
//       },
//       icon: Icon(
//         isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
//         color: Color(0xffFF5F99),
//         size: 24.0,
//       ),
//     );
//   }
// }

class FavB extends StatefulWidget {
  FavB({Key? key, required this.docId}) : super(key: key);
  final String docId;

  @override
  State<FavB> createState() => _FavBState();
}

class _FavBState extends State<FavB> {
  bool isFav = false;
  late SharedPreferences _prefs;
  late String itemToFavorite;

  @override
  void initState() {
    super.initState();
    itemToFavorite = widget.docId; // Utilisation du docId de ListFood
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isFav = _prefs.getBool(widget.docId) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    final FavManager favManager =
        FavManager(); // Créez une instance de FavManager

    if (!isFav) {
      // Si ce n'est pas déjà un favori, ajoutez-le
      final Map<String, dynamic> food = {
        'docId':
            widget.docId, // Utilisez le docId comme identifiant de l'élément
        // Ajoutez d'autres informations sur l'élément si nécessaire
      };
      await favManager.addTofav(food);
    } else {
      // S'il est déjà un favori, supprimez-le
      final Map<String, dynamic> food = {
        'docId':
            widget.docId, // Utilisez le docId comme identifiant de l'élément
        // Ajoutez d'autres informations sur l'élément si nécessaire
      };
      await favManager.removeFromfav(food);
    }

    setState(() {
      isFav = !isFav; // Inversez l'état de favori
    });
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> buyFoodNotifier =
        ValueNotifier<int>(1); // Initial value

    final CartManager cartManager = CartManager();

    return IconButton(
      onPressed: () async {
        final buyFood = buyFoodNotifier.value;

        // Ajoutez l'article aux favoris en utilisant _toggleFavorite
        await _toggleFavorite();

        // Ajoutez également l'article au panier
        await cartManager.addToCart({
          'qty': buyFood,
          'item':
              widget.docId, // Utilisez le docId comme identifiant de l'élément
          // Ajoutez d'autres informations sur l'élément si nécessaire
        });

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => FavPage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item added to Favoris and Cart')),
        );
      },
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : Colors.grey,
        size: 24.0,
      ),
    );
  }
}

// class buildTile extends StatelessWidget {
//   const buildTile({
//     Key? key,
//     required this.food,
//     required this.data,
//     required this.screenWidth,
//     required this.isArabic,
//     required this.isFavorite,
//     required this.toggleFavorite,
//   }) : super(key: key);
//
//   final ListFood food;
//   final Map<dynamic, dynamic> data;
//   final double screenWidth;
//   final isArabic;
//   final isFavorite;
// final toggleFavorite;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) {
//               return DetailFood(food: food);
//             },
//           ),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     image: DecorationImage(
//                       image: CachedNetworkImageProvider(data['image']),
//                       fit: BoxFit.cover,
//                       alignment: Alignment.topCenter,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: screenWidth / 2.1,
//                         child: Text(
//                           data['item'].toString(),
//                           overflow: TextOverflow.ellipsis,
//                           style: isArabic(data['item'])
//                               ? GoogleFonts.cairo(
//                                   // textStyle: Theme.of(context).textTheme.headline4,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600)
//                               : TextStyle(
//                                   // color: Colors.white70,
//                                   fontSize: 16,
//                                 ),
//                         ),
//                       ),
//                       Text(food.cat),
//                       Text(
//                         intl.NumberFormat.currency(
//                           symbol: 'DZD ',
//                           decimalDigits: 2,
//                         ).format(data['price']),
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: Colors.orange,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             //Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
//             IconButton(
//               icon: Icon(
//                 isFavorite ? Icons.favorite : Icons.favorite_border,
//                 color: isFavorite ? Colors.red : null, // Change icon color
//               ),
//               onPressed: () => toggleFavorite(item),
//             ),
//             // FavB(
//             //   docId: data['docId'],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class pizzaAnime extends StatefulWidget {
  const pizzaAnime({
    Key? key,
    required this.url,
  }) : super(key: key);
  final url;

  @override
  State<pizzaAnime> createState() => _pizzaAnimeState();
}

class _pizzaAnimeState extends State<pizzaAnime>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double turns = 0.0;
  @override
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CartPage())),
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
            widget.url,
          )),
        ),
      ),
    );
  }
}
