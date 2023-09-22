import 'dart:ui';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart' as intl;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ramzy/food/MyTabCategories.dart';
import 'package:ramzy/food/addFood.dart';
import 'package:ramzy/food/favShared.dart';
import 'package:ramzy/food2/MesAchatsPage.dart';
import 'package:ramzy/food2/QrScanner.dart';
import 'package:ramzy/food2/cart.dart';
import 'package:ramzy/food2/main.dart';
import 'package:ramzy/food2/models.dart';
import 'package:ramzy/food2/foodDetail.dart';
import 'package:ramzy/food2/recharger.dart';
import 'package:ramzy/food2/paymentPage.dart';

class MonWidget extends StatelessWidget {
  double calculateTotalAmount(List<Map<String, dynamic>> cartItems) {
    double totalAmount = 0.0;

    for (var cartItem in cartItems) {
      // Assurez-vous que les clés correspondent à la structure de vos articles
      final int price = cartItem['price'] as int;
      final int quantity = cartItem['qty'] as int;

      // Calculez le montant total pour cet article
      final int itemTotal = price * quantity;

      // Ajoutez le montant de cet article au montant total
      totalAmount += itemTotal;
    }

    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final cartItems = dataProvider.getCart(); // Obtenez les articles du panier
    final totalAmount = calculateTotalAmount(cartItems);

    return FutureBuilder<Map<String, dynamic>>(
        future:
            dataProvider.getCurrentUserDocument(), //getCurrentUserDocument(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data;
            final userImageUrl = userData!['avatar'];
            final usertimeline = userData['timeline'];
            final userName = userData['displayName'];

            return Scaffold(
              resizeToAvoidBottomInset: false,
              drawer: CustomDrawer(dataProvider),
              appBar: AppBar(
                actions: [
                  Center(
                    child: Card(
                        color: Colors.teal,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.values.first,
                                children: [
                                  Text(
                                    intl.NumberFormat.currency(
                                      symbol: '',
                                      decimalDigits: 2,
                                    ).format(userData['coins']),
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    ' DZD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        IconButton(
                          color: Colors.green,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CartPage2())),
                          icon: Icon(Icons.add_shopping_cart),
                        ),
                        Text(
                          intl.NumberFormat.currency(
                                  symbol: 'DZD ', decimalDigits: 2)
                              .format(totalAmount),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: CustomScrollView(slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        userImageUrl), // Utilisez une image par défaut si l'URL de l'image n'est pas disponible.
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QrScanner2()));
                                  },
                                  icon: Icon(
                                    Icons.qr_code,
                                    size: 35,
                                  ),
                                ),
                                IconButton.outlined(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PizzaForm(),
                                    ));
                                  },
                                  icon: Icon(
                                    Icons.add,
                                  ),
                                ),
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
                                      "https://cdn.pixabay.com/photo/2017/12/09/08/18/pizza-3007395_1280.jpg",
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello " +
                                      userData['displayName']
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
                          ],
                        )),
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
                      child: FutureBuilder<List<ListFood2>>(
                        future: dataProvider.getFilteredAndSortedData('pizza'),
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

                          List<ListFood2> foodDocs = snapshot.data!;

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: foodDocs.length,
                            itemBuilder: (context, index) {
                              final food = foodDocs[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailFood2(food: food),
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
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 10.0,
                                                sigmaY: 10.0,
                                              ),
                                              child: IntrinsicHeight(
                                                child: Container(
                                                  color: Colors.black45
                                                      .withAlpha(70),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 15.0, 15.0, 15.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        food.item
                                                            .toString()
                                                            .toUpperCase(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                                fontSize: 22,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800)
                                                            : TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 20,
                                                              ),
                                                      ),
                                                      Text(
                                                        food.flav,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white70,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)
                                                            : TextStyle(
                                                                color: Colors
                                                                    .white70,
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
                                                        intl.NumberFormat
                                                            .currency(
                                                          symbol: 'DZD ',
                                                          decimalDigits: 2,
                                                        ).format(food.price),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                        },
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: MyTabCategories(dataProvider: dataProvider),
                  ),
                ]),
              ),
            );
          }
        });
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}

class CustomDrawer extends StatelessWidget {
  final DataProvider dataProvider;

  CustomDrawer(this.dataProvider);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future:
            dataProvider.getCurrentUserDocument(), //getCurrentUserDocument(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data;
            final userImageUrl = userData!['avatar'];
            final usertimeline = userData['timeline'];
            final userName = userData['displayName'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    userName.toUpperCase(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  accountEmail: Text(
                    userData['email'],
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  currentAccountPicture: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(userImageUrl),
                    ),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        usertimeline,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => UserProfileWidget(),
                    // )),
                    child: Card(
                        color: Colors.teal,
                        child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: FittedBox(
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.values.first,
                                children: [
                                  Text(
                                    intl.NumberFormat.currency(
                                      symbol: '',
                                      decimalDigits: 2,
                                    ).format(userData['coins']),
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    ' DZD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    'Hello, ' + userName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    'What flavor do you want today?',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.qr_code),
                  title: Text("Envoyer des Coins"),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => QrScanner2()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_basket_rounded),
                  title: Text('Historique des Achats'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MesAchatsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Favorites'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FavoritesPage(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(Icons.account_box),
                  title: Text("About"),
                  onTap: () {
                    // Afficher une boîte de dialogue avec un code QR
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text('Mon Code QR')),
                          content: SizedBox(
                              width: 200,
                              height: 200,
                              child: PrettyQr(data: userData['id'])),
                          actions: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Fermer'),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            );
          }
        },
      ),
    );
  }
}

class MyTabCategories extends StatelessWidget {
  const MyTabCategories({
    super.key,
    required this.dataProvider,
  });

  final DataProvider dataProvider;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration(microseconds: 700),
      length: dataProvider.categories.length,
      child: Scaffold(
        appBar: AppBar(
          //  title: Text('Categories'),
          title: TabBar(
            isScrollable: true,
            tabs: dataProvider.categories.map((category) {
              return Tab(
                child: Text(
                  category.toString().capitalize(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: dataProvider.categories.map((category) {
            return CategoryList(category: category);
          }).toList(),
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final String category;

  CategoryList({required this.category});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: dataProvider.getCategoryItems(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('Aucune donnée disponible.');
        }

        // Traitez les données snapshot.data.docs pour afficher les éléments de la catégorie.
        // Parcourez snapshot.data.docs pour obtenir les éléments de la catégorie actuelle.
        final categoryItems = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final categoryItemData =
                categoryItems[index].data() as Map<String, dynamic>;
            final categoryItem = ListFood2.fromMap(categoryItemData);

            // Utilisez categoryItem pour construire votre widget d'élément de catégorie.
            return InkWell(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                              image: CachedNetworkImageProvider(
                                  categoryItem.image),
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
                                  categoryItem.item,
                                  overflow: TextOverflow.ellipsis,
                                  style: isArabic(categoryItem.item)
                                      ? GoogleFonts.cairo(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        )
                                      : TextStyle(
                                          fontSize: 16,
                                        ),
                                ),
                              ),
                              Text(categoryItem.cat),
                              Text(
                                intl.NumberFormat.currency(
                                  symbol: 'DZD ',
                                  decimalDigits: 2,
                                ).format(categoryItem.price),
                                overflow: TextOverflow.ellipsis,
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
                  ],
                ),
              ),
              // Ajoutez la logique pour gérer le clic sur l'élément ici.
              // Utilisez categoryItem pour passer les données de l'élément à la page de détail.
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailFood2(food: categoryItem),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
