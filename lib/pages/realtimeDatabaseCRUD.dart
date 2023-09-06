import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class realtimeDatabaseCRUD extends StatefulWidget {
  const realtimeDatabaseCRUD({super.key});

  @override
  State<realtimeDatabaseCRUD> createState() => _realtimeDatabaseCRUDState();
}

class _realtimeDatabaseCRUDState extends State<realtimeDatabaseCRUD> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DatabaseReference _databaseReference;

  // Modèle de données
  late String _name;
  late String _email;

  @override
  void initState() {
    super.initState();
    _databaseReference = _database.reference().child('users');
    readDocument();
  }

  // Opération Create (Créer)
  void createData() {
    _databaseReference.push().set({
      'time': DateTime.now().toString(),
      'name': _name,
      'email': 'Zero', //_email,
    }).then((_) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Données créées avec succès !')),
      // );
      print('Données créées avec succès !');
    }).catchError((error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Erreur lors de la création des données.')),
      // );
      print('Erreur lors de la création des données.');
    });
  }

  // void readDocument(String key) {
  //   DatabaseReference documentRef =
  //       _database.reference().child('users').child(key);
  //   documentRef.once().then((DatabaseEvent snapshot) {
  //     if (snapshot.snapshot.value != null) {
  //       // Document exists, process the data
  //       Map<dynamic, dynamic> documentData =
  //           snapshot.snapshot.value as Map<dynamic, dynamic>;
  //       Document document = Document(
  //         key: key,
  //         data: documentData,
  //       );
  //       setState(() {
  //         documents.add(document);
  //       });
  //     } else {
  //       // Document does not exist
  //       print('Document not found');
  //     }
  //   }).catchError((error) {
  //     print('Failed to read document: $error');
  //   });
  // }

  List<DatabaseReference> references = [];

  void readDocument() {
    DatabaseReference documentRef = _database.reference().child('users');
    documentRef.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        // Data exists, process the data
        dynamic data = snapshot.snapshot.value;
        if (data is Map<dynamic, dynamic>) {
          data.forEach((key, value) {
            DatabaseReference reference = documentRef.child(key);
            setState(() {
              references.add(reference);
            });
          });
        } else {
          print('Data is not of type Map<dynamic, dynamic>');
        }
      } else {
        // Data does not exist
        print('No data found');
      }
    }).catchError((error) {
      print('Failed to read data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase CRUD'),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     await Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => ChatListScreen(), //UserListScreen(),
          //       ),
          //     );
          //   },
          //   icon: Icon(Icons.account_box_sharp),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              children: [
                IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UserList()),
                      );
                    },
                    icon: Icon(Icons.account_circle_rounded)),
                FirebaseAnimatedList(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  query: FirebaseDatabase.instance.ref().child('users'),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    // Process the data and build your UI
                    // ...
                    dynamic reference = snapshot.value!;
                    var keyFinder = snapshot.key;
                    return ListTile(
                      trailing: IconButton(
                        onPressed: () {
                          deleteReference(keyFinder!);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      title: Text(' Email: ${reference['email']}'),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(' Nom: ${reference['name']}'),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${reference['time']}',
                                style: TextStyle(fontSize: 12),
                              )),
                        ],
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            labelText: 'Ecrire Ton Message',
                            labelStyle: TextStyle(color: Colors.blue),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.blue), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              //<-- SEE HERE
                              borderSide:
                                  BorderSide(width: 3, color: Colors.blue),
                            ),
                          ),
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Veuillez saisir un nom';
                            }
                            return null;
                          },
                          onSaved: (input) => _name = input!,
                        ),
                      ),
                      IconButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              createData();
                            }
                            setState(() {
                              references;
                            });
                          },
                          icon: Icon(Icons.send)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void deleteReference(String referenceId) {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  DatabaseReference referenceToDelete =
      _databaseRef.child('users').child(referenceId);
  referenceToDelete.remove().then((_) {
    print('Reference deleted successfully.');
  }).catchError((error) {
    print('Failed to delete reference: $error');
  });
}

class Document {
  final String key;
  final Map<dynamic, dynamic> data;

  Document({required this.key, required this.data});
}

/////////////////////////////////////////////////////////////

class MessageService {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');

  Future<void> sendMessage(
      String senderId, String receiverId, String content) async {
    final messageRef = _messagesRef.push();
    await messageRef.set({
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': ServerValue.timestamp,
    });
  }

  Stream getConversationMessages(String conversationId, String receiverId) {
    return _messagesRef.child(conversationId).orderByChild('timestamp').onValue;
  }
}

class UserList extends StatelessWidget {
  final List<String> userList = ['user1', 'user2', 'user3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return ListTile(
            title: Text(user),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                    senderId: FirebaseAuth.instance.currentUser!.uid.toString(),
                    receiverId: user,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ConversationScreen extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final MessageService messageService = MessageService();

  ConversationScreen({required this.senderId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  messageService.getConversationMessages(senderId, receiverId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = <String>[];
                  final data = snapshot.data!.snapshot.value;
                  if (data != null) {
                    data.forEach((key, value) {
                      messages.add(value['content']);
                    });
                  }
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SendMessageForm(
            senderId: senderId,
            receiverId: receiverId,
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}

class SendMessageForm extends StatefulWidget {
  final String senderId;
  final String receiverId;

  SendMessageForm({required this.senderId, required this.receiverId});

  @override
  _SendMessageFormState createState() => _SendMessageFormState();
}

class _SendMessageFormState extends State<SendMessageForm> {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      await MessageService()
          .sendMessage(widget.senderId, widget.receiverId, content);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: 'Type a message'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
