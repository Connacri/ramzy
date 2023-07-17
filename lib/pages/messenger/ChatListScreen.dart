import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ramzy/pages/UsersListScreen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({
    Key? key,
    //required this.id,
  }) : super(key: key);
  //final String id;
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //  'AxbGwwLmOHXZZhxxrZz1hUz6wcJ2'; // Replace with your current user's ID
  final DatabaseReference _dataref = FirebaseDatabase.instance.ref();
  // final DatabaseReference _messagesRef =
  //     FirebaseDatabase.instance.ref().child('messages');
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<UserRealTime> usersList = [];
  //UserRealTime? selectedUser;
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());

    return Scaffold(
        appBar: AppBar(
          title: Text('Chat List'),
        ),
        body: Column(
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder(
                stream:
                    _database.child('members').child(currentUser!.uid).onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final membersSnapshot = snapshot.data!;
                    final membersData = membersSnapshot.snapshot.value
                        as Map<dynamic, dynamic>?;

                    if (membersData != null) {
                      final chatIds = membersData.keys.toList();

                      return ListView.builder(
                        itemCount: chatIds.length,
                        itemBuilder: (context, index) {
                          final chatId =
                              membersData[chatIds[index]]['chatId'] as String;

                          return StreamBuilder(
                            stream:
                                _database.child('chats').child(chatId).onValue,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasData) {
                                final chatSnapshot = snapshot.data!;
                                final chatData = chatSnapshot.snapshot.value
                                    as Map<dynamic, dynamic>?;

                                if (chatData != null) {
                                  final lastMessageSent =
                                      chatData['lastMessage'] as String?;
                                  final lastSender =
                                      chatData['lastSender'] as String?;
                                  final timeStampChats =
                                      chatData['timestamp'] as int?;
                                  final members = chatData['members']
                                      as Map<dynamic, dynamic>?;

                                  String? otherMemberId;
                                  if (members != null) {
                                    otherMemberId = members.keys.firstWhere(
                                      (memberId) =>
                                          memberId != currentUser!.uid,
                                      orElse: () => null,
                                    );
                                  }

                                  if (lastMessageSent != null &&
                                      timeStampChats != null &&
                                      otherMemberId != null) {
                                    final userDocRef = FirebaseFirestore
                                        .instance
                                        .collection('Users')
                                        .doc(otherMemberId);

                                    return StreamBuilder(
                                      stream: userDocRef.snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasData) {
                                          final userSnapshot =
                                              snapshot.data as DocumentSnapshot;
                                          final userData = userSnapshot.data()
                                              as Map<String, dynamic>;
                                          final avatarUrl =
                                              userData['avatar'] as String?;

                                          return ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreenIndividuel(
                                                    selectedUserId:
                                                        otherMemberId,
                                                    currentUserId:
                                                        currentUserId,
                                                  ),
                                                ),
                                              );
                                            },
                                            leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    avatarUrl ?? '')),
                                            title: Text(
                                                userData['displayName']
                                                    .toString()
                                                    .capitalize(),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            subtitle: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    lastSender == currentUserId
                                                        ? 'vous : '
                                                                .toString()
                                                                .capitalize() +
                                                            lastMessageSent
                                                                .toString()
                                                                .capitalize()
                                                        : userData['displayName']
                                                                .toString()
                                                                .capitalize() +
                                                            ' : ' +
                                                            lastMessageSent
                                                                .toString()
                                                                .capitalize(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                      color: Colors.black38,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                                // Text(
                                                //   DateTime.fromMillisecondsSinceEpoch(
                                                //           timeStampChats)
                                                //       .toString(),
                                                //   textAlign: TextAlign.end,
                                                //   style: TextStyle(
                                                //       color: Colors.blueAccent,
                                                //       fontSize: 10),
                                                // ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  timeago.format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            timeStampChats),
                                                    locale: 'fr',
                                                  ),
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        return ListTile(
                                          title: Text(lastMessageSent),
                                          subtitle: Text(otherMemberId!),
                                        );
                                      },
                                    );
                                  }
                                }
                              }

                              return Center(child: Text('No data'));
                            },
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('Pas Encore de Messages'));
                    }
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  return SizedBox(); // Retourne un widget vide si aucune condition n'est remplie
                },
              ),
            ),
          ],
        ));
  }
}

class ChatScreenIndividuel extends StatefulWidget {
  ChatScreenIndividuel({
    required this.currentUserId,
    required this.selectedUserId, //required this.DataUserMap
  });
  final String currentUserId;
  final String? selectedUserId;

  @override
  State<ChatScreenIndividuel> createState() => _ChatScreenIndividuelState();
}

class _ChatScreenIndividuelState extends State<ChatScreenIndividuel> {
  final DatabaseReference _dataref = FirebaseDatabase.instance.ref();
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');

  List<UserRealTime> usersList = [];
  TextEditingController _messageController = TextEditingController();
  String? chatId;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    getChatId(widget.currentUserId, widget.selectedUserId!).then((value) {
      setState(() {
        chatId = value;
      });
    });
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      autoScroll_toEnd(); // Scroll to the end of the chat
    });
  }

  void sendMessage(String selectedUserId) {
    String messageText = _messageController.text.trim();
    if (selectedUserId.isNotEmpty && messageText.isNotEmpty) {
      final DatabaseReference _chatsRef = _dataref.child('chats');
      final DatabaseReference _membersRef = _dataref.child('members');
      final DatabaseReference _messagesRef = _dataref.child('messages');
      final DatabaseReference _userChatsRef = _dataref.child('userChats');

      DateTime now = DateTime.now().toUtc();

      if (chatId != null) {
        // Chat already exists for the selected users
        String messageId = _messagesRef.child(chatId!).push().key!;

        Map<String, dynamic> messageData = {
          'name': currentUser,
          'message': messageText,
          'timestamp': now.millisecondsSinceEpoch,
        };

        _messagesRef
            .child(chatId!)
            .child(messageId)
            .set(messageData)
            .then((value) {
          print('Message sent successfully!');
          _messageController.clear();
          updateChatLastMessage(chatId!, messageText, now);
          // setState(() {}); // Trigger a rebuild to update messages
          autoScroll_toEnd(); // Scroll to the end of the chat
        }).catchError((error) {
          print('Failed to send message: $error');
        });
      } else {
        // Create a new chat for the selected users
        chatId = _chatsRef.push().key!;
        String messageId = _messagesRef.child(chatId!).push().key!;

        Map<String, dynamic> messageData = {
          'name': currentUser,
          'message': messageText,
          'timestamp': now.millisecondsSinceEpoch,
        };

        Map<String, dynamic> chatData = {
          'members': {
            currentUser: true,
            selectedUserId: true,
          },
          'lastMessage': messageText,
          'lastSender': currentUser,
          'timestamp': now.millisecondsSinceEpoch,
        };

        _messagesRef
            .child(chatId!)
            .child(messageId)
            .set(messageData)
            .then((value) {
          print('Message sent successfully!');
          _messageController.clear();

          _membersRef
              .child(currentUser)
              .child(selectedUserId)
              .child('chatId')
              .set(chatId!)
              .then((value) {
            _membersRef
                .child(selectedUserId)
                .child(currentUser)
                .child('chatId')
                .set(chatId!)
                .then((value) {
              _chatsRef.child(chatId!).set(chatData).then((value) {
                print('New chat created successfully!');
                setState(() {}); // Trigger a rebuild to show the chat
                autoScroll_toEnd(); // Scroll to the end of the chat
              }).catchError((error) {
                print('Failed to create chat: $error');
              });
            }).catchError((error) {
              print('Failed to set chat ID for selected user: $error');
            });
          }).catchError((error) {
            print('Failed to set chat ID for current user: $error');
          });
        }).catchError((error) {
          print('Failed to send message: $error');
        });
      }
    }
  }

  void updateChatLastMessage(
      String chatId, String messageText, DateTime timestamp) {
    final DatabaseReference _chatsRef = _dataref.child('chats');
    Map<String, dynamic> updateData = {
      'lastMessage': messageText,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };

    _chatsRef.child(chatId).update(updateData).then((value) {
      print('Chat updated successfully!');
    }).catchError((error) {
      print('Failed to update chat: $error');
    });
  }

  Future<String?> getChatId(String currentUserId, String selectedUserId) async {
    final DatabaseEvent membersSnapshot = await FirebaseDatabase.instance
        .ref()
        .child('members')
        .child(currentUserId)
        .child(selectedUserId)
        .once();

    if (membersSnapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> memberData =
          membersSnapshot.snapshot.value as Map<dynamic, dynamic>;
      final String? chatId = memberData['chatId'] as String?;

      return chatId;
    }

    return null; // ChatId not found
  }

  ////////////////////////////////////////////////////////////////////////

  void autoScroll_toEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose(); ////////////******************************
    _scrollController.dispose();
    super.dispose();
  }

  bool haveText = false;

  Widget chatInputField(selectedUserId) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: 20,
              top: 10,
            ),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.mic,
                  color: Color.fromARGB(255, 0, 127, 232),
                )),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 20,
                top: 10,
              ),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextField(
                    // onSubmitted: (text) {
                    //   if (text.length > 0)
                    //     setState(() {
                    //       haveText = true;
                    //     });
                    //   else
                    //     setState(() {
                    //       haveText = false;
                    //     });
                    // },
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: 'Type message', border: InputBorder.none),
                  )),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.attach_file,
                        color: Color.fromARGB(255, 0, 127, 232),
                        size: 20,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Color.fromARGB(255, 0, 127, 232),
                        size: 20,
                      )),
                  SizedBox(
                    width: 13,
                  ),
                  InkWell(
                      onTap: () {
                        sendMessage(selectedUserId);
                      },
                      child: Icon(
                        Icons.send,
                        color: haveText
                            ? Color.fromARGB(255, 0, 127, 232)
                            : Colors.grey,
                        size: 20,
                      )),
                  SizedBox(
                    width: 13,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _messagesRef.child(chatId!).child(messageId).update({
        'isDeleted': true,
      });
      setState(() {
        // Trigger a rebuild to update the UI
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message deleted'),
        ),
      );
    } catch (error) {
      print('Failed to delete message: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete message'),
        ),
      );
    }
  }

  Widget buildMessageItem(
    Map<dynamic, dynamic> chatMessageData,
    String messageId,
  ) {
    final message = chatMessageData['message'] as String;
    final nameId = chatMessageData['name'] as String;
    final isDeleted = chatMessageData['isDeleted'] as bool? ?? false;

    if (isDeleted) {
      return Text('Message deleted');
    } else {
      return ListTile(
        title: Text(message),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => deleteMessage(messageId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(chatId == null ? 'Nouvelle Chat' : 'Les Messages'),
        ),
        body: //SingleChildScrollView(
            //child:
            Column(
          mainAxisSize:
              MainAxisSize.min, // Set mainAxisSize to MainAxisSize.min
          children: [
            Expanded(
              // fit: FlexFit.loose,
              child: chatId == null
                  ? Center(
                      child: Text('No chat found for the selected user.'),
                    )
                  : StreamBuilder(
                      stream: _dataref.child('messages').child(chatId!).onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final chatMessagesSnapshot = snapshot.data!;
                          final chatMessagesData = chatMessagesSnapshot
                              .snapshot.value as Map<dynamic, dynamic>?;

                          if (chatMessagesData != null) {
                            final chatMessages =
                                chatMessagesData.entries.toList();
                            chatMessages.sort((a, b) {
                              final timestampA =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      a.value['timestamp']);
                              final timestampB =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      b.value['timestamp']);
                              return timestampA.compareTo(timestampB);
                            });

                            return ListView.builder(
                              controller: _scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: chatMessages.length,
                              itemBuilder: (context, index) {
                                final chatMessageEntry = chatMessages[index];
                                final chatMessageData = chatMessageEntry.value;
                                final message =
                                    chatMessageData['message'] as String;
                                final nameId =
                                    chatMessageData['name'] as String;
                                final messageId =
                                    chatMessageEntry.key as String;
                                final timestamp =
                                    chatMessageData['timestamp'] as int;

                                final bool isCurrentUserMessage =
                                    nameId == currentUser;
                                final bool isWithinTimeLimit = DateTime.now()
                                        .difference(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                timestamp))
                                        .inMinutes <=
                                    5;

                                return Dismissible(
                                  key: Key(messageId),
                                  direction:
                                      // (isCurrentUserMessage == true &&
                                      //         isWithinTimeLimit)
                                      //     ?
                                      DismissDirection.endToStart,
                                  //: DismissDirection.none,
                                  onDismissed: (direction) {
                                    if (isCurrentUserMessage == true &&
                                        isWithinTimeLimit) {
                                      // Delete the message from the database
                                      _messagesRef
                                          .child(chatId!)
                                          .child(messageId)
                                          .remove()
                                          .then(
                                        (_) {
                                          print(
                                              'Message deleted successfully!');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'Message deleted successfully!'),
                                            ),
                                          );
                                        },
                                      ).catchError((error) {
                                        print(
                                            'Failed to delete message: $error');
                                      });
                                    } else {
                                      // Re-insert the dismissed item back into the list
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('delais dépassé'),
                                        ),
                                      );
                                    }
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(nameId)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(38.0),
                                            child: LinearProgressIndicator(),
                                          ),
                                        );
                                      } else if (snapshot.hasData) {
                                        final userSnapshot = snapshot.data!;
                                        final userData = userSnapshot.data()
                                            as Map<String, dynamic>;
                                        final avatarUrl =
                                            userData['avatar'] as String?;

                                        return Align(
                                          alignment: nameId == currentUser
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: nameId == currentUser
                                              ? itemMessage_Sender(
                                                  message: message)
                                              : itemMessage_receiver(
                                                  photo: avatarUrl ?? '',
                                                  message: message,
                                                ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      return SizedBox();
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    ),
            ),
            chatInputField(widget.selectedUserId!),
          ],
        ),
        // ),
      ),
    );
  }
}

// item message (sender)
class itemMessage_Sender extends StatelessWidget {
  final String message;

  const itemMessage_Sender({Key? key, required this.message}) : super(key: key);
  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 70,
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Text(
                  message,
                  textAlign:
                      isArabic(message) ? TextAlign.right : TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.check_circle,
            color: Color.fromARGB(255, 35, 156, 255),
            size: 14,
          )
        ],
      ),
    );
  }
}

// item message (receiver)
class itemMessage_receiver extends StatelessWidget {
  final String message;
  final String photo;
  const itemMessage_receiver(
      {Key? key, required this.message, required this.photo})
      : super(key: key);
  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(photo),
            radius: 22,
          ),
          SizedBox(width: 10),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                message,
                textAlign: isArabic(message) ? TextAlign.right : TextAlign.left,
                softWrap: true,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ),
          SizedBox(width: 70),
        ],
      ),
    );
  }
}
