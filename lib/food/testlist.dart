import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:ramzy/food/DetailFood.dart';
import 'package:ramzy/food/home_screen_food.dart';
import 'package:ramzy/food/list_food_Models.dart';

class CategoryFilterModel extends ChangeNotifier {
  String _catSelected = '';

  String get catSelected => _catSelected;

  set catSelected(String value) {
    _catSelected = value;
    notifyListeners();
    print('click:  ' + catSelected);
  }
}

class YourPageWithCategoryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryFilterModel>(
      create: (context) => CategoryFilterModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('Filtered List')),
        body: Column(
          children: [
            Container(
              height: 50,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: FirestoreDataProvider().fetchData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: LinearProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(
                        'Une erreur s\'est produite : ${snapshot.error}');
                  } else {
                    List<Map<String, dynamic>> cachedData = snapshot.data!;

                    List<String> uniqueCategories = cachedData
                        .map((item) => item['cat'] as String)
                        .toSet()
                        .toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: uniqueCategories.length,
                      itemBuilder: (context, index) {
                        String category = uniqueCategories[index];

                        return CategoryButton(
                          categoryName: category,
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: YourFilteredPaginateFirestore(),
            ),
          ],
        ),
      ),
    );
  }
}

class YourFilteredPaginateFirestore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryFilterModel = Provider.of<CategoryFilterModel>(context);
    final catSelected = categoryFilterModel.catSelected;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider.value(
      value: categoryFilterModel,
      //child: Center(child: Text(catSelected)),
      child: PaginateFirestore(
        itemBuilderType: PaginateBuilderType.listView,
        query: FirebaseFirestore.instance
            .collection('Foods')
            .where('cat', isEqualTo: catSelected),
        itemBuilder: (BuildContext context, List<DocumentSnapshot> snapshotList,
            int index) {
          print(catSelected);
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
                                textAlign: isArabic(data[
                                        'item']) // Utilisez "this.isArabic"
                                    ? TextAlign.right
                                    : TextAlign.left,
                                style: isArabic(data[
                                        'item']) // Utilisez "this.isArabic"
                                    ? GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)
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

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}

class CategoryButton extends StatelessWidget {
  final String categoryName;
  const CategoryButton({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryFilterModel = Provider.of<CategoryFilterModel>(context);
    final isSelected = categoryFilterModel.catSelected == categoryName;

    return GestureDetector(
      onTap: () {
        categoryFilterModel.catSelected = isSelected ? '' : categoryName;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        color: isSelected ? Colors.blue : Colors.grey,
        child: Text(
          categoryName,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////

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

  Query _getQueryFromCachedDataAndFilter(String? selectedCategory) {
    Query query = FirebaseFirestore.instance.collection('Foods');

    if (selectedCategory != null) {
      query = query.where('cat', isEqualTo: selectedCategory);
    }

    return query;
  }

  Future<List<Map<String, dynamic>>> getFutureDataFromCachedData(
      String? selectedCategory) async {
    await fetchData();

    if (selectedCategory == null) {
      return cachedData ?? [];
    } else {
      Query query = _getQueryFromCachedDataAndFilter(selectedCategory);
      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}

class MyFirestoreListView extends StatefulWidget {
  @override
  _MyFirestoreListViewState createState() => _MyFirestoreListViewState();
}

class _MyFirestoreListViewState extends State<MyFirestoreListView> {
  final FirestoreDataProvider _dataProvider = FirestoreDataProvider();

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore ListView Example')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dataProvider.getFutureDataFromCachedData(_selectedCategory),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> documents = snapshot.data!;

            Set<String> uniqueCategories = Set();
            documents.forEach((doc) {
              uniqueCategories.add(doc['cat']);
            });

            return Column(
              children: [
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: uniqueCategories.length,
                    itemBuilder: (context, index) {
                      String category = uniqueCategories.elementAt(index);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          color: _selectedCategory == category
                              ? Colors.blue
                              : Colors.transparent,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: _selectedCategory == category
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: uniqueCategories.length + 1,
                    controller: PageController(
                      initialPage: 0,
                    ),
                    itemBuilder: (context, index) {
                      String pageTitle;
                      if (index == 0) {
                        pageTitle = 'Tous les documents';
                      } else {
                        String category = uniqueCategories.elementAt(index - 1);
                        pageTitle = 'Catégorie: $category';
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              pageTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: index == 0
                                  ? documents.length
                                  : documents
                                      .where((doc) =>
                                          doc['cat'] ==
                                          uniqueCategories.elementAt(index - 1))
                                      .length,
                              itemBuilder: (context, subIndex) {
                                Map<String, dynamic> doc;
                                if (index == 0) {
                                  doc = documents[subIndex];
                                } else {
                                  String category =
                                      uniqueCategories.elementAt(index - 1);
                                  doc = documents
                                      .where((doc) => doc['cat'] == category)
                                      .toList()[subIndex];
                                }

                                return ListTile(
                                  title: Text(doc['item']),
                                  // Autres champs à afficher
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Error loading data'));
          }
        },
      ),
    );
  }
}
