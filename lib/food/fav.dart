import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

class FavManager {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<Map<String, dynamic>>> getfavItems() async {
    final prefs = await _prefs;
    final favData = prefs.getStringList('fav') ?? [];
    return favData
        .map((item) => json.decode(item))
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<void> addTofav(Map<String, dynamic> food) async {
    final prefs = await _prefs;
    final favData = prefs.getStringList('fav') ?? [];
    favData.add(json.encode(food));
    await prefs.setStringList('fav', favData);
  }

  Future<void> removeFromfav(Map<String, dynamic> food) async {
    final prefs = await _prefs;
    final favData = prefs.getStringList('fav') ?? [];
    favData.remove(json.encode(food));
    await prefs.setStringList('fav', favData);
  }
}

class FavPage extends StatefulWidget {
  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final FavManager favManager = FavManager();
  List<Map<String, dynamic>> favItems = [];

  @override
  void initState() {
    super.initState();
    _loadfavItems();
  }

  Future<void> _loadfavItems() async {
    final items = await favManager.getfavItems();
    setState(() {
      favItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        title: Text('Mes Favoris'),
        actions: [],
      ),
      body: ListView.builder(
        itemCount: favItems.length,
        itemBuilder: (context, index) {
          final favItem = favItems[index];
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundImage: favItem['image'] == null
                    ? CachedNetworkImageProvider(
                        "https://cdn.pixabay.com/photo/2020/05/17/04/22/pizza-5179939_640.jpg")
                    : CachedNetworkImageProvider(favItem['image']),
              ),
            ),
            title: Text(favItem['item']),
            subtitle: Text('DZD ${favItem['price']}'),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                await favManager.removeFromfav(favItem);
                _loadfavItems();
              },
            ),
          );
        },
      ),
    );
  }
}
