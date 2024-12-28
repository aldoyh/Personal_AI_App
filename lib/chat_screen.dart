// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:personal_ai_app/constants.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:personal_ai_app/api_service.dart';
import 'package:personal_ai_app/chat_widget.dart';
// import 'package:personal_ai_app/text_widget.dart';
import 'package:personal_ai_app/services.dart';

import '../../assets_manager.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final bool _isTyping = true;
  late TextEditingController textEditingController;

  // Declare this list to store messages
  List<Map<String, dynamic>> chatMessages = [];

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(AssetsManager.logo),
        ),
        title: Text(
          'Personal  AI',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    if (chatMessages.isEmpty) {
                      return Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    if (kDebugMode) {
                      print("Building chat bubble. No $index");
                    }
                    if (index == 0) {
                      return ChatWidget(
                        msg: "Hello, how can I help you?",
                        chatIndex: 1,
                      );
                    } else if (index == 1) {
                      return ChatWidget(
                        msg: "I'm doing well, thank you!",
                        chatIndex: 2,
                      );
                    } else if (index == 2) {
                      return ChatWidget(
                        msg: "What's your name?",
                        chatIndex: 1,
                      );
                    } else if (index == 3) {
                      return ChatWidget(
                        msg: "My name is AI.",
                        chatIndex: 2,
                      );
                    }

                    return ChatWidget(
                      msg: chatMessages[index]['msg'].toString(),
                      chatIndex: int.parse(
                          chatMessages[index]['chatIndex'].toString()),
                    );
                  }),
            ),
            if (_isTyping) ...[
              SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
              // SizedBox(
              //   height: 15,
              // ),
              // Material(
              Container(
                color: kCardColor,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) {
                            //to do message
                          },
                          decoration: InputDecoration.collapsed(
                            hintText: 'How can I help you',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            await ApiService.getModels();
                          } catch (error) {
                            print('error $error');
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
