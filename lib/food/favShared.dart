import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favoriteItemIds = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  // Load favorite item IDs from SharedPreferences
  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteItemIds = prefs.getStringList('favoriteItemIds') ?? [];
    });
  }

  // Toggle the favorite status of an item
  Future<void> toggleFavorite(String itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteItemIds.contains(itemId)) {
        favoriteItemIds.remove(itemId);
      } else {
        favoriteItemIds.add(itemId);
      }
      prefs.setStringList('favoriteItemIds', favoriteItemIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteItemIds.length,
        itemBuilder: (context, index) {
          // Here, you can retrieve the favorite items using the item IDs
          String itemId = favoriteItemIds[index];
          // You can fetch the corresponding item data based on itemId
          // Replace this with your logic to fetch the item data

          return ListTile(
            title: Text('Item Id : $itemId'), // Replace with actual item data
            trailing: IconButton(
              onPressed: () async {
                // Show a confirmation dialog
                bool confirmed = await showDeleteConfirmationDialog(context);

                if (confirmed) {
                  // User confirmed the deletion
                  setState(() {
                    // Remove the item ID from the list of favoriteItemIds
                    favoriteItemIds.remove(itemId);
                  });
                  // You can also update the SharedPreferences here to persist the changes
                  // itemManager.toggleFavorite(itemId); // Update SharedPreferences

                  // Optionally, you can call a method to refresh the UI or perform other actions
                  // refreshUI();
                }
              },
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirm Deletion'),
              content: Text('Are you sure you want to delete this item?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // User canceled the deletion
                  },
                ),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // User confirmed the deletion
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Provide a default value of false when dialog is dismissed
  }
}
