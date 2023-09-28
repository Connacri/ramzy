import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food/carts.dart';
import 'package:ramzy/food/editFood.dart';
import 'package:ramzy/food/list_food_Models.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ramzy/food2/cart.dart';
import 'package:ramzy/food2/main.dart';
import 'package:ramzy/food2/models.dart';
import 'package:ramzy/pages/ProfileOthers.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailFood2 extends StatelessWidget {
  final ListFood2 food;
  DetailFood2({Key? key, required this.food}) : super(key: key);

  final ValueNotifier<int> buyFoodNotifier =
      ValueNotifier<int>(1); // Initial value

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: food.image,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(15, 20, 10, 20), //.all(20.0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(food.user)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Icon(Icons.error);
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Icon(Icons.account_box);
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> dataU =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return InkWell(
                        onTap: () async {
                          //  Map dataUser = data as Map;
                          await Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ProfileOthers(data: dataU);
                          }));
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: dataU['avatar'],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 140,
                              child: Text(
                                "${dataU['displayName']}"
                                    .toUpperCase(), // - ${data['email']}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              width: 50,
                            )),
                            IconButton(
                                icon: Icon(
                                  Icons.call,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  final Uri launchUrlR = Uri(
                                      scheme: 'Tel',
                                      path: '+213${dataU['phone']}');
                                  if (await canLaunchUrl(launchUrlR)) {
                                    await launchUrl(launchUrlR);
                                  } else {
                                    print('This Call Cant execute');
                                  }
                                }),
                            IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  //var phone = 00971566129156;
                                  String msg = 'Hi this is Oran';
                                  var whatsappUrl =
                                      "whatsapp://send?phone=+213${dataU['phone']}" +
                                          "&text=${Uri.encodeComponent(msg)}";

                                  final Uri launchUrlRW = Uri(
                                      scheme: 'Tel',
                                      path: "+213${dataU['phone']}" +
                                          "&text=${Uri.encodeComponent(msg)}");
                                  try {
                                    launch(whatsappUrl);
                                  } catch (e) {
                                    //To handle error and display error message
                                    print("Unable to open whatsapp");
                                  }
                                }),
                          ],
                        ),
                      );
                    }

                    return Text("loading");
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.item,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            intl.NumberFormat.currency( locale:
                            'fr_FR',
                              symbol: 'DZD ',
                              decimalDigits: 2,
                            ).format(food.price),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xffFF5F99),
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xffFF5F99),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: BuyFood(
                                food: food, buyFoodNotifier: buyFoodNotifier),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      food.flav,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      food.desc,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          isExtended: true,
          elevation: 5,
          splashColor: Colors.white70,
          onPressed: () async {
            final buyFood = buyFoodNotifier.value;
            final itemToAdd = {
              'qty': buyFood,
              'item': food.item,
              'price': food.price,
              'image': food.image,
              'docId': food.docId,
              'user': food.user,
              'cat': food.cat,
              'flav': food.flav,
              'createdAt': food.createdAt.millisecondsSinceEpoch,
              'desc': food.desc,
            };
            // Obtenez la liste actuelle du panier depuis SharedPreferences
            final List<Map<String, dynamic>> cartItems =
                await dataProvider.getCart();

            // Ajoutez le nouvel article à la liste
            cartItems.add(itemToAdd);

            // Enregistrez la nouvelle liste du panier dans SharedPreferences
            await dataProvider.saveCart(cartItems);

            // Affichez une confirmation à l'utilisateur
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Article ajouté au panier')),
            // );

            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CartPage2()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Commander",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: buyFoodNotifier,
                builder: (context, quantity, child) {
                  final total = food.price * quantity;
                  return Text(
                    'Total: \DZD ${total.toStringAsFixed(2)}', // Afficher le total ici
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuyFood extends StatefulWidget {
  final ListFood2 food;
  final ValueNotifier<int> buyFoodNotifier; // Ajout du ValueNotifier

  const BuyFood({Key? key, required this.food, required this.buyFoodNotifier})
      : super(key: key);

  @override
  State<BuyFood> createState() => _BuyFoodState();
}

class _BuyFoodState extends State<BuyFood> {
  void _incFood() {
    widget.buyFoodNotifier.value++; // Utilisez le ValueNotifier de BuyFood
  }

  void _decFood() {
    if (widget.buyFoodNotifier.value > 1) {
      widget.buyFoodNotifier.value--; // Utilisez le ValueNotifier de BuyFood
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _decFood,
          icon: Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable:
              widget.buyFoodNotifier, // Utilisez le ValueNotifier de BuyFood
          builder: (context, buyFood, _) {
            return Text(
              "$buyFood",
              style: TextStyle(color: Colors.white),
            );
          },
        ),
        IconButton(
          onPressed: _incFood,
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
