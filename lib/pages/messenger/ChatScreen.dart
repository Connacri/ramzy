import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/pages/ProvidersPublic.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ramzy/pages/UsersListScreen.dart';
import 'package:ramzy/pages/messenger/ChatListScreen.dart';
////////////////////////////////chat screen/////////////////////////////////

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    required this.selectedUserId,
  }) : super(key: key);
  final String selectedUserId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseReference _dataref = FirebaseDatabase.instance.ref();
  // final DatabaseReference _messagesRef =
  //     FirebaseDatabase.instance.ref().child('messages');
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('users');
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<UserRealTime> usersList = [];
  // UserRealTime? selectedUser;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void sendMessage(String selectedUserId) {
    String messageText = _messageController.text.trim();
    if (selectedUserId.isNotEmpty && messageText.isNotEmpty) {
      final DatabaseReference _chatsRef = _dataref.child('chats');
      final DatabaseReference _membersRef = _dataref.child('members');
      final DatabaseReference _messagesRef = _dataref.child('messages');
      final DatabaseReference _userChatsRef = _dataref.child('userChats');

      DateTime now = DateTime.now().toUtc();

      _membersRef
          .child(currentUser!.uid)
          .child(selectedUserId)
          .child('chatId')
          .once()
          .then((snapshot) {
        String? existingChatId = snapshot.snapshot.value?.toString();

        if (existingChatId != null) {
          // Chat already exists for the selected users
          String chatId = existingChatId;
          String messageId = _messagesRef.child(chatId).push().key!;

          Map<String, dynamic> messageData = {
            'name': currentUser!.uid,
            'message': messageText,
            'timestamp': now.millisecondsSinceEpoch,
          };

          _messagesRef
              .child(chatId)
              .child(messageId)
              .set(messageData)
              .then((value) {
            print('Message sent successfully!');
            _messageController.clear();
            updateChatLastMessage(chatId, messageText, now);
          }).catchError((error) {
            print('Failed to send message: $error');
          });
        } else {
          // Create a new chat for the selected users
          String chatId = _chatsRef.push().key!;
          String messageId = _messagesRef.child(chatId).push().key!;

          Map<String, dynamic> messageData = {
            'name': currentUser!.uid,
            'message': messageText,
            'timestamp': now.millisecondsSinceEpoch,
          };

          Map<String, dynamic> chatData = {
            'members': {
              currentUser!.uid: true,
              selectedUserId: true,
            },
            'lastMessage': messageText,
            'timestamp': now.millisecondsSinceEpoch,
          };

          _messagesRef
              .child(chatId)
              .child(messageId)
              .set(messageData)
              .then((value) {
            print('Message sent successfully!');
            _messageController.clear();

            _membersRef
                .child(currentUser!.uid)
                .child(selectedUserId)
                .child('chatId')
                .set(chatId)
                .then((value) {
              _membersRef
                  .child(selectedUserId)
                  .child(currentUser!.uid)
                  .child('chatId')
                  .set(chatId)
                  .then((value) {
                _chatsRef.child(chatId).set(chatData).then((value) {
                  print('New chat created successfully!');
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
      }).catchError((error) {
        print('Failed to check chat existence: $error');
      });
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

  final DatabaseReference _userChatsRef =
      FirebaseDatabase.instance.ref().child('userChats');
  final DatabaseReference _chatsRef =
      FirebaseDatabase.instance.ref().child('chats');

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Expanded(
              child: StreamBuilder(
            stream: _userChatsRef.child(currentUser!.uid).onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userChatsSnapshot = snapshot.data!;
                final userChatsData =
                    userChatsSnapshot.snapshot.value as Map<dynamic, dynamic>;

                return ListView.builder(
                  itemCount: userChatsData.length,
                  itemBuilder: (context, index) {
                    final chatId = userChatsData.keys.elementAt(index);

                    return StreamBuilder(
                      stream: _chatsRef.child(chatId).onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final chatSnapshot = snapshot.data!;
                          final chatData = chatSnapshot.snapshot.value
                              as Map<dynamic, dynamic>;

                          final members =
                              chatData['members'] as Map<dynamic, dynamic>;
                          final lastMessageSent =
                              chatData['lastMessageSent'] as String?;

                          String lastMessage = '';

                          if (lastMessageSent != null) {
                            final lastMessageSnapshot = chatSnapshot.snapshot
                                .child(lastMessageSent)
                                .value as Map<dynamic, dynamic>;
                            lastMessage =
                                lastMessageSnapshot['message'] as String;
                          }

                          // Build the list tile for the chat
                          return ListTile(
                            title: Text('Chat ID: $chatId'),
                            subtitle: Text('Last Message: $lastMessage'),
                            // onTap: () {
                            //   // Handle chat click action here
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ChatScreenIndividuel(
                            //               chatId: chatId,
                            //             )),
                            //   );
                            // },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        return CircularProgressIndicator();
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              return CircularProgressIndicator();
            },
          )),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => sendMessage(widget.selectedUserId),
                  child: Text('Send'),
                ),
                SizedBox(
                  height: 150,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
