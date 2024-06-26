import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map1/Chat/group_info.dart';
import 'package:map1/Chat/widgets/message_tile.dart';
import 'package:map1/LoginSignup/components/widgets.dart';
import 'package:map1/my_colors.dart';
import 'package:map1/service/database_service.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                ),
              );
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'lib/images/chatBG.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Opacity(
              opacity: 0.3,
              child: Container(
                color: const Color.fromARGB(255, 16, 28, 85),
              ),
            ),
          ),
          Positioned.fill(
            child: chatMessages(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      // color: MyColors.ButtonBlue,
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(35),
                    // color: Colors.grey[300],
                    color: MyColors.ButtonBlue,
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          style: const TextStyle(
                            // color: MyColors.ButtonBlue,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Send a message...",
                            hintStyle: TextStyle(
                              // color: MyColors.ButtonBlue,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
