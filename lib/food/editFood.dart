// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:ramzy/food/DetailFood.dart';
// import 'package:ramzy/food/list_food_Models.dart';
//
// class FoodDetailScreen extends StatefulWidget {
//   final ListFood food;
//
//   FoodDetailScreen({required this.food});
//
//   @override
//   _FoodDetailScreenState createState() => _FoodDetailScreenState();
// }
//
// class _FoodDetailScreenState extends State<FoodDetailScreen> {
//   final TextEditingController _itemController = TextEditingController();
//   final TextEditingController _flavController = TextEditingController();
//   final TextEditingController _descController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _itemController.text = widget.food.item;
//     _flavController.text = widget.food.flav;
//     _descController.text = widget.food.desc;
//     _priceController.text = widget.food.price.toString();
//   }
//
//   Future<void> _updateFoodDetails() async {
//     final foodRef =
//         FirebaseFirestore.instance.collection('foods').doc(widget.food.id);
//
//     await foodRef.update({
//       'item': _itemController.text,
//       'flav': _flavController.text,
//       'desc': _descController.text,
//       'price': double.parse(_priceController.text),
//     });
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Food Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: _itemController,
//               decoration: InputDecoration(labelText: 'Item'),
//             ),
//             TextFormField(
//               controller: _flavController,
//               decoration: InputDecoration(labelText: 'Flavor'),
//             ),
//             TextFormField(
//               controller: _descController,
//               decoration: InputDecoration(labelText: 'Description'),
//             ),
//             TextFormField(
//               controller: _priceController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: 'Price'),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: _updateFoodDetails,
//               child: Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
