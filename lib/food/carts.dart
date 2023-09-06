import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

class CartManager {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final prefs = await _prefs;
    final cartData = prefs.getStringList('cart') ?? [];
    return cartData
        .map((item) => json.decode(item))
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<void> addToCart(Map<String, dynamic> food) async {
    final prefs = await _prefs;
    final cartData = prefs.getStringList('cart') ?? [];
    cartData.add(json.encode(food));
    await prefs.setStringList('cart', cartData);
  }

  Future<void> removeFromCart(Map<String, dynamic> food) async {
    final prefs = await _prefs;
    final cartData = prefs.getStringList('cart') ?? [];
    cartData.remove(json.encode(food));
    await prefs.setStringList('cart', cartData);
  }
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartManager cartManager = CartManager();
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final items = await cartManager.getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  int calculateTotalAmount() {
    int totalAmount = 0;
    for (var cartItem in cartItems) {
      final price =
          cartItem['price'] as int?; // Use 'as int?' to handle null values
      final qty =
          cartItem['qty'] as int?; // Use 'as int?' to handle null values

      if (price != null && qty != null) {
        totalAmount += price * qty;
      }
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: Text('Bon Panier'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: calculateTotalAmount() >= 1000
                ? Text(
                    intl.NumberFormat.compactCurrency(
                            symbol: 'DZD ', decimalDigits: 2)
                        .format(calculateTotalAmount()),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange),
                  )
                : Text(
                    intl.NumberFormat.currency(symbol: 'DZD ', decimalDigits: 2)
                        .format(calculateTotalAmount()),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange),
                  ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundImage: cartItem['image'] == null
                    ? CachedNetworkImageProvider(
                        "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg")
                    : CachedNetworkImageProvider(cartItem['image']),
              ),
            ),
            title: Text(cartItem['item']),
            subtitle: Text(
                'DZD ${cartItem['price']} x ${cartItem['qty']} = ${cartItem['price'] * cartItem['qty']}'),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                await cartManager.removeFromCart(cartItem);
                _loadCartItems();
              },
            ),
          );
        },
      ),
    );
  }
}
