import 'dart:developer';
import 'dart:math';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/food/testlist.dart';
import 'package:ramzy/food2/TestProgressTimeLine.dart';
import 'package:ramzy/food2/main.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile_nic/timeline_tile.dart';
import 'package:timelines/timelines.dart' as timeline;
import 'package:timelines/timelines.dart';

class MesAchatsPage extends StatelessWidget {
  final _processes = [
    'Prospect',
    'Tour',
    'Offer',
    'Contract',
    'Settled',
  ];
  int _processIndex = 2;

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return
        //   Timeline.tileBuilder(
        //   theme: TimelineThemeData(
        //     direction: Axis.horizontal,
        //     connectorTheme: ConnectorThemeData(
        //       space: 30.0,
        //       thickness: 5.0,
        //     ),
        //   ),
        //   builder: TimelineTileBuilder.connected(
        //     connectionDirection: ConnectionDirection.before,
        //     itemExtentBuilder: (_, __) =>
        //         MediaQuery.of(context).size.width / _processes.length,
        //     oppositeContentsBuilder: (context, index) {
        //       return Padding(
        //         padding: const EdgeInsets.only(bottom: 15.0),
        //         child: Image.network(
        //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDbu8XFNT3fJ0_4McXIVHhHcE1lU2eNP6QXA&usqp=CAU',
        //           width: 50.0,
        //           color: getColor(index),
        //         ),
        //       );
        //     },
        //     contentsBuilder: (context, index) {
        //       return Padding(
        //         padding: const EdgeInsets.only(top: 15.0),
        //         child: Text(
        //           _processes[index],
        //           style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             color: getColor(index),
        //           ),
        //         ),
        //       );
        //     },
        //     indicatorBuilder: (_, index) {
        //       var color;
        //       var child;
        //       if (index == _processIndex) {
        //         color = inProgressColor;
        //         child = Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: CircularProgressIndicator(
        //             strokeWidth: 3.0,
        //             valueColor: AlwaysStoppedAnimation(Colors.white),
        //           ),
        //         );
        //       } else if (index < _processIndex) {
        //         color = completeColor;
        //         child = Icon(
        //           Icons.check,
        //           color: Colors.white,
        //           size: 15.0,
        //         );
        //       } else {
        //         color = todoColor;
        //       }
        //
        //       if (index <= _processIndex) {
        //         return Stack(
        //           children: [
        //             CustomPaint(
        //               size: Size(30.0, 30.0),
        //               painter: _BezierPainter(
        //                 color: color,
        //                 drawStart: index > 0,
        //                 drawEnd: index < _processIndex,
        //               ),
        //             ),
        //             DotIndicator(
        //               size: 30.0,
        //               color: color,
        //               child: child,
        //             ),
        //           ],
        //         );
        //       } else {
        //         return Stack(
        //           children: [
        //             CustomPaint(
        //               size: Size(15.0, 15.0),
        //               painter: _BezierPainter(
        //                 color: color,
        //                 drawEnd: index < _processes.length - 1,
        //               ),
        //             ),
        //             OutlinedDotIndicator(
        //               borderWidth: 4.0,
        //               color: color,
        //             ),
        //           ],
        //         );
        //       }
        //     },
        //     connectorBuilder: (_, index, type) {
        //       if (index > 0) {
        //         if (index == _processIndex) {
        //           final prevColor = getColor(index - 1);
        //           final color = getColor(index);
        //           List<Color> gradientColors;
        //           if (type == ConnectorType.start) {
        //             gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
        //           } else {
        //             gradientColors = [
        //               prevColor,
        //               Color.lerp(prevColor, color, 0.5)!
        //             ];
        //           }
        //           return DecoratedLineConnector(
        //             decoration: BoxDecoration(
        //               gradient: LinearGradient(
        //                 colors: gradientColors,
        //               ),
        //             ),
        //           );
        //         } else {
        //           return SolidLineConnector(
        //             color: getColor(index),
        //           );
        //         }
        //       } else {
        //         return null;
        //       }
        //     },
        //     itemCount: _processes.length,
        //   ),
        // );

        WillPopScope(
      // Cette fonction sera appelée lorsque l'utilisateur appuie sur le bouton de retour
      onWillPop: () async {
        // Utilisez popUntil pour revenir à la première page
        Navigator.popUntil(context, (route) => route.isFirst);
        return false; // Empêche la navigation arrière standard
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mes Achats'),
        ),
        body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
          future: dataProvider.getAllCommandeDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: MesAchatsListShimmer(),
                // CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun achat trouvé.'));
            }

            final List<DocumentSnapshot<Map<String, dynamic>>>
                commandeDocuments = snapshot.data!;

            return MesAchatsList(commandeDocuments, dataProvider);
          },
        ),
      ),
    );
  }
}

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

class MesAchatsList extends StatelessWidget {
  final List<DocumentSnapshot<Map<String, dynamic>>> commandeDocuments;
  final DataProvider dataProvider;

  MesAchatsList(this.commandeDocuments, this.dataProvider);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: commandeDocuments.length,
            itemBuilder: (context, index) {
              commandeDocuments.sort((a, b) {
                final DateTime createdAtA = a['createdAt'].toDate() as DateTime;
                final DateTime createdAtB = b['createdAt'].toDate() as DateTime;
                return createdAtB
                    .compareTo(createdAtA); // Trie en ordre décroissant
              });

              final Map<String, dynamic> data =
                  commandeDocuments[index].data()!;
              final double cartTotal = data['cartTotal'] as double;
              final DateTime createdAt = data['createdAt'].toDate() as DateTime;
              final List<Map<String, dynamic>> items =
                  List<Map<String, dynamic>>.from(data['items'] ?? []);

              // Le reste du code reste inchangé...
              Random random = Random();
              int randomIndex = random.nextInt(data['items'].length);
              final DateFormat dateFormatter = DateFormat(
                'EEEE dd/MM/yyyy à HH:mm',
                'fr_FR', // Utilisez 'fr_FR' pour la locale française.
              ); // Format de date souhaité
              final String formattedDate = dateFormatter.format(createdAt);
              final NumberFormat cartTotalFormatter = NumberFormat.currency( locale:
              'fr_FR',
                symbol:
                    'DZD ', // Vous pouvez définir le symbole de la devise ici s'il est nécessaire.
                decimalDigits:
                    2, // Le nombre de chiffres après la virgule que vous voulez afficher.
              );

              final String formattedCartTotal =
                  cartTotalFormatter.format(cartTotal);

              final timelinePosition = index + 1;

              return //PackageDeliveryTrackingPage();
                  ////////////////////////////////////
                  InkWell(
                child: MyListTile(
                  position: data['position'],
                  statut: data['statut'],
                  total: formattedCartTotal,
                  createdAt: formattedDate,
                ),
                onTap: () {
                  // Handle the tap on a specific purchase to show the items.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Text('List des Commandes'),
                            Text(
                              'Total Achat : $formattedCartTotal',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Le ' + formattedDate.toString().capitalize(),
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 13),
                            ),
                            Divider()
                          ],
                        ),
                        content: CustomScrollView(
                          // physics: ,
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                                delegate: SliverChildListDelegate([
                              ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final cartItem = items[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: cartItem['image'] == null
                                                  ? CachedNetworkImageProvider(
                                                      "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg")
                                                  : CachedNetworkImageProvider(
                                                      cartItem['image']),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          cartItem['qty'] > 99
                                              ? 'nd'
                                              : cartItem['qty']
                                                  .toString()
                                                  .padLeft(2, '0'),
                                          style: TextStyle(fontSize: 35),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartItem['item'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                'DZD ${cartItem['price'].toStringAsFixed(2)}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ])),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        FutureBuilder<double>(
          future: dataProvider.calculateTotalOfAllAchats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Shimmer.fromColors(
                    baseColor: Colors.black54,
                    highlightColor: Colors.grey,
                    enabled: true,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
              );
            }

            if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }

            final double totalAchats = snapshot.data ?? 0.0;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Total de tous les achats : $totalAchats DZD',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ],
    );
  }
}

class MyListTile extends StatelessWidget {
  MyListTile(
      {required this.position,
      required this.statut,
      required this.total,
      required this.createdAt});
  final String position;
  final String statut;
  final String total;
  final String createdAt;

  Color getColor(int index) {
    if (positionList[index] == position) {
      return inProgressColor;
    } else if (index < positionList.indexOf(position)) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  List statutList = [
    'commande',
  ];
  List positionList = ['moi', 'traiteur', 'livreur', 'Livré'];
  List iconsList = [
    Icons.account_circle_rounded,
    FontAwesomeIcons.kitchenSet,
    // Icons.soup_kitchen,
    Icons.delivery_dining_sharp,
    FontAwesomeIcons.handshake
    // Icons.handshake_outlined,
  ];
  @override
  Widget build(BuildContext context) {
    double mediaQuerywidth = MediaQuery.of(context).size.width;

    return statut != 'finalisé'
        ? Container(
            // padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 10, 0),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.shopping_cart_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 0 /*10*/),
                          child: Text(
                            'Total Achat :  $total',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 0 /*10*/),
                          child: Text(
                            'Le ' + createdAt.toString().capitalize(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 150,
                  width: mediaQuerywidth,
                  child: Timeline.tileBuilder(
                    theme: TimelineThemeData(
                      direction: Axis.horizontal,
                      connectorTheme: ConnectorThemeData(
                        space: 30.0,
                        thickness: 5.0,
                      ),
                    ),
                    builder: TimelineTileBuilder.connected(
                      connectionDirection: ConnectionDirection.before,
                      itemExtentBuilder: (_, __) =>
                          MediaQuery.of(context).size.width /
                          positionList.length,
                      oppositeContentsBuilder: (context, index) {
                        return Container(
                          height: 50,
                          child: Column(
                            children: [
                              Icon(
                                iconsList[index],
                                color: getColor(index),
                              ),
                              Text(
                                positionList[index].toString().capitalize(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: getColor(index),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      contentsBuilder: (context, index) {
                        return Container(
                          height: 30,
                          child: positionList[index] == position
                              ? Center(
                                  child: Text(
                                  statut.capitalize(),
                                  style: TextStyle(
                                    color: getColor(index),
                                  ),
                                ))
                              : Center(child: Text('')),
                        );
                      },
                      indicatorBuilder: (_, index) {
                        var color;
                        var child;
                        if (index == positionList.indexOf(position)) {
                          color = inProgressColor;
                          child = Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Center(
                                child: Icon(
                              FontAwesomeIcons.hourglassHalf,
                              size: 16,
                              color: Colors.white,
                            )),
                            // CircularProgressIndicator(
                            //   strokeWidth: 3.0,
                            //   valueColor: AlwaysStoppedAnimation(Colors.white),
                            // ),
                          );
                        } else if (index < positionList.indexOf(position)) {
                          color = completeColor;
                          child = Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15.0,
                          );
                        } else {
                          color = todoColor;
                        }

                        if (index <= positionList.indexOf(position)) {
                          return Stack(
                            children: [
                              CustomPaint(
                                size: Size(30.0, 30.0),
                                painter: _BezierPainter(
                                  color: color,
                                  drawStart: index > 0,
                                  drawEnd:
                                      index < positionList.indexOf(position),
                                ),
                              ),
                              DotIndicator(
                                size: 30.0,
                                color: color,
                                child: child,
                              ),
                            ],
                          );
                        } else {
                          return Stack(
                            children: [
                              CustomPaint(
                                size: Size(15.0, 15.0),
                                painter: _BezierPainter(
                                  color: color,
                                  drawEnd: index < positionList.length - 1,
                                ),
                              ),
                              OutlinedDotIndicator(
                                borderWidth: 4.0,
                                color: color,
                              ),
                            ],
                          );
                        }
                      },
                      connectorBuilder: (_, index, type) {
                        if (index > 0) {
                          if (index == positionList.indexOf(position)) {
                            final prevColor = getColor(index - 1);
                            final color = getColor(index);
                            List<Color> gradientColors;
                            if (type == ConnectorType.start) {
                              gradientColors = [
                                Color.lerp(prevColor, color, 0.5)!,
                                color
                              ];
                            } else {
                              gradientColors = [
                                prevColor,
                                Color.lerp(prevColor, color, 0.5)!
                              ];
                            }
                            return DecoratedLineConnector(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                ),
                              ),
                            );
                          } else {
                            return SolidLineConnector(
                              color: getColor(index),
                            );
                          }
                        } else {
                          return null;
                        }
                      },
                      itemCount: positionList.length,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Total Achat :  $total',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Le ' + createdAt.toString().capitalize(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class MesAchatsListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                      child: Icon(
                    Icons.shopping_cart_rounded,
                    color: Colors.white,
                  )),
                  title: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      color: Colors.grey,
                      height: 16,
                      width: 10,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      color: Colors.grey,
                      height: 16,
                      width: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          Shimmer.fromColors(
              baseColor: Colors.black54,
              highlightColor: Colors.grey,
              enabled: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  color: Colors.grey,
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                //LinearProgressIndicator(),
              )),
        ],
      ),
    );
  }
}
