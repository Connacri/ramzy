import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomTab extends StatefulWidget {
  @override
  _CustomTabState createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tabs').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        //Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

        final tabs = snapshot.data!.docs.map((doc) => doc.data()! as Map<String, dynamic>).toList();
        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                isScrollable: true,
                tabs: tabs.map((tab) => Tab(text: tab['title'])).toList(),
              ),
            ),
            body: TabBarView(
              children: tabs
                  .map((tab) => Center(child: Text(tab['content'])))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
