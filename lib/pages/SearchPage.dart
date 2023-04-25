import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _searchController = TextEditingController();
  List<QueryDocumentSnapshot>? _searchResults;

  Future<void> _searchDocuments(String query) async {
    final collection = FirebaseFirestore.instance.collection('Products');

    final allDocuments = await collection.get();
    final documents = allDocuments.docs;

    final options = FuzzyOptions(
      findAllMatches: true,
      minMatchCharLength: 2,
      threshold: 0.2,
    );

    final fuse = Fuzzy(
      documents.map((document) => document.data()['item']).toList(),
      options: options,
    );

    final searchResults = fuse.search(query);
    final searchResultIds = searchResults.map((result) => result.item).toList();

    final snapshot = await collection
        .where(FieldPath.documentId, whereIn: searchResultIds)
        .get();

    setState(() {
      _searchResults = snapshot.docs;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
          ),
          onChanged: (query) {
            _searchDocuments(query);
          },
        ),
      ),
      body: _searchResults == null
          ? Center(child: Text('Start searching...'))
          : _searchResults!.isEmpty
              ? Center(child: Text('No results found.'))
              : ListView.builder(
                  itemCount: _searchResults!.length,
                  itemBuilder: (context, index) {
                    final document = _searchResults![index];
                    return ListTile(
                      title: Text(document['item']),
                      subtitle: Text(document['Description']),
                    );
                  },
                ),
    );
  }
}
