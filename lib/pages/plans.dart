// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
//
// class MyHom extends StatefulWidget {
//   MyHom({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomState createState() => _MyHomState();
// }
//
// class _MyHomState extends State<MyHom> {
//   static const maxCount = 100;
//   static const double maxHeight = 1000;
//   final random = math.Random();
//   final scrollDirection = Axis.vertical;
//
//   late AutoScrollController controller;
//   late List<List<int>> randomList;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = AutoScrollController(
//         viewportBoundaryGetter: () =>
//             Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
//         axis: scrollDirection);
//     randomList = List.generate(maxCount,
//         (index) => <int>[index, (maxHeight * random.nextDouble()).toInt()]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() => counter = 0);
//               _scrollToCounter();
//             },
//             icon: Text('First'),
//           ),
//           IconButton(
//             onPressed: () {
//               setState(() => counter = maxCount - 1);
//               _scrollToCounter();
//             },
//             icon: Text('Last'),
//           )
//         ],
//       ),
//       body: ListView(
//         scrollDirection: scrollDirection,
//         controller: controller,
//         children: randomList.map<Widget>((data) {
//           return Padding(
//             padding: EdgeInsets.all(8),
//             child: _getRow(data[0], math.max(data[1].toDouble(), 50.0)),
//           );
//         }).toList(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _nextCounter,
//         tooltip: 'Increment',
//         child: Text(counter.toString()),
//       ),
//     );
//   }
//
//   int counter = -1;
//   Future _nextCounter() {
//     setState(() => counter = (counter + 1) % maxCount);
//     return _scrollToCounter();
//   }
//
//   Future _scrollToCounter() async {
//     await controller.scrollToIndex(counter,
//         preferPosition: AutoScrollPosition.begin);
//     controller.highlight(counter);
//   }
//
//   Widget _getRow(int index, double height) {
//     return _wrapScrollTag(
//         index: index,
//         child: Container(
//           padding: EdgeInsets.all(8),
//           alignment: Alignment.topCenter,
//           height: height,
//           decoration: BoxDecoration(
//               border: Border.all(color: Colors.lightBlue, width: 4),
//               borderRadius: BorderRadius.circular(12)),
//           child: Text('index: $index, height: $height'),
//         ));
//   }
//
//   Widget _wrapScrollTag({required int index, required Widget child}) =>
//       AutoScrollTag(
//         key: ValueKey(index),
//         controller: controller,
//         index: index,
//         child: child,
//         highlightColor: Colors.black.withOpacity(0.1),
//       );
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class plans extends StatefulWidget {
  const plans({Key? key}) : super(key: key);

  @override
  State<plans> createState() => _plansState();
}

class _plansState extends State<plans> {
  final List planList = ['bronze', 'silver', 'gold', 'platinium'];
  final List<Color> colorsLabel = [
    Colors.white,
    Colors.black54,
    Colors.white,
    Colors.white
  ];
  final List<Color> colorsList = [
    Color.fromARGB(255, 139, 169, 2),
    Color.fromARGB(255, 243, 236, 216),
    Color.fromARGB(255, 255, 196, 0),
    Color.fromARGB(255, 255, 95, 0),
  ];
  final List<Color> colorsList2 = [
    Color.fromARGB(255, 66, 58, 41),
    Color.fromARGB(255, 66, 58, 41),
    Color.fromARGB(255, 79, 2, 2),
    Color.fromARGB(255, 38, 32, 20),
  ];
  final List<int> price = [1000, 2000, 4000, 5000];

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Les Plans Prenium Disponible')),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 6),
        height: 220,
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: planList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4),
              child: Container(
                width: 300,
                height: 800,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: RadialGradient(
                        radius: 2,
                        tileMode: TileMode.clamp,
                        colors: [
                          colorsList[index], //Colors.greenAccent;
                          colorsList2[index],
                        ])),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        planList[index].toUpperCase().trim(),
                        style: TextStyle(
                            fontSize: 30.0, color: colorsLabel[index]),
                      ),
                      FittedBox(
                        child: Text(
                          NumberFormat.currency(
                                  symbol: 'DZD ', decimalDigits: 2)
                              .format(
                            price[index],
                          ),
                          style: TextStyle(
                              fontSize: 20.0, color: colorsLabel[index]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlanWidget extends StatelessWidget {
  const PlanWidget({Key? key, required this.Designation}) : super(key: key);
  final String Designation;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_balance),
      title: Text(Designation),
    );
  }
}
