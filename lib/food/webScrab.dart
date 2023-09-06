import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ramzy/food/DetailFood.dart';
import 'package:ramzy/food/list_food_Models.dart';

class MyAppmainWeb extends StatefulWidget {
  @override
  _MyAppmainWebState createState() => _MyAppmainWebState();
}

class _MyAppmainWebState extends State<MyAppmainWeb> {
  List<ListFood> foodList = [];
  User? currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    fetchFoodListFromFirestore(currentUser!.uid);
  }

  // void fetchFoodListFromFirestore() async {
  //   final firestore = FirebaseFirestore.instance;
  //   final collection = firestore.collection('Foods');
  //
  //   try {
  //     final querySnapshot = await collection.get();
  //     final foodListFromFirestore = querySnapshot.docs.map((doc) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //
  //       return ListFood(
  //         item: data['item'],
  //         desc: data['desc'],
  //         price: data['price'],
  //         image: data['image'],
  //         flav: data['flav'],
  //         cat: data['cat'],
  //         createdAt: data['createdAt'],
  //         user: data['user'],
  //         docId: data['docId'],
  //       );
  //     }).toList();
  //
  //     setState(() {
  //       foodList = foodListFromFirestore;
  //     });
  //
  //     // No need to call importDataAndImagesToFirestore here
  //   } catch (error) {
  //     print("Error fetching data from Firestore: $error");
  //   }
  // }

// Create a StreamController that emits ListFood objects
  StreamController<List<ListFood>> _foodListController =
      StreamController<List<ListFood>>();

// Define a getter to access the stream
  Stream<List<ListFood>> get foodListStream => _foodListController.stream;

// Replace your original function with this
  void fetchFoodListFromFirestore(String currentUserUid) {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Foods');

    try {
      collection.snapshots().listen((querySnapshot) {
        final foodListFromFirestore = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          return ListFood(
            item: data['item'],
            desc: data['desc'],
            price: data['price'],
            image: data['image'],
            flav: data['flav'],
            cat: data['cat'],
            createdAt: data['createdAt'],
            user: currentUserUid, // Set the current user UID here
            docId: doc.id, // Use the document ID of the Firestore document
          );
        }).toList();

        // Emit the new food list to the stream
        _foodListController.add(foodListFromFirestore);
      });

      // No need for try-catch here, snapshots will handle errors
    } catch (error) {
      print("Error fetching data from Firestore: $error");
    }
  }

// Don't forget to close the StreamController when it's no longer needed
  void dispose() {
    _foodListController.close();
  }

  Future<void> addMultipleDocumentsToFirestoreID() async {
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    final categories = [
      "pizza",
      "tacos",
      "sandwich",
      "plat",
      "soupe",
      "salade",
      "dessert",
      "poisson",
      "traditionnel",
      "repas froid",
      "complement"
    ];
    final List<String> LoremIpsum = [
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).',
      'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.',
      'There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.',
      'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
      "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?",
      "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.",
      "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains.",
    ];
    final random = Random();

    for (int i = 1; i <= 55; i++) {
      final randomCategory = categories[random.nextInt(categories.length)];
      final randomLoremIpsum = LoremIpsum[random.nextInt(LoremIpsum.length)];
      final randomLoremIpsum2 = LoremIpsum[random.nextInt(LoremIpsum.length)];

      final randomPrice = random.nextInt(50) + 10;

      final listFood = ListFood(
        item: 'Item $i',
        desc: randomLoremIpsum,
        image: 'food ($i).jpg',
        price: randomPrice,
        cat: randomCategory,
        flav: randomLoremIpsum2,
        createdAt: Timestamp.now(),
        user: FirebaseAuth.instance.currentUser!.uid,
        docId: '',
      );

      final storageRef = storage.ref().child('Foods/${listFood.image}');
      final imageUrl = await storageRef.getDownloadURL();

      final addedDocRef = await firestore.collection('Foods').add({
        'item': listFood.item,
        'desc': listFood.desc,
        'image': imageUrl,
        'price': listFood.price,
        'cat': listFood.cat,
        'flav': listFood.flav,
        'createdAt': listFood.createdAt,
        'user': listFood.user,
      });

      // Mise à jour du document pour inclure l'ID du document Firestore
      await addedDocRef.update({'docId': addedDocRef.id});

      print('Added Item $i to Firestore');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Food List'),
          actions: [
            IconButton(
                onPressed: () async {
                  await addMultipleDocumentsToFirestoreID();
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: StreamBuilder<List<ListFood>>(
          stream: foodListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final foodList = snapshot.data;

              return ListView.builder(
                itemCount: foodList!.length,
                itemBuilder: (context, index) {
                  final food = foodList[index];

                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailFood(food: food);
                        },
                      ),
                    ),
                    child: ListTile(
                      // dense: true,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: food.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      title: Text(
                        food.item,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        food.desc,
                        textAlign: TextAlign.justify,
                        // overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Display more information as needed
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
