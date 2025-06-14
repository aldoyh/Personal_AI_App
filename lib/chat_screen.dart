import 'package:flutter/material.dart';
import 'package:personal_ai_app/constants/constants.dart';
import 'package:personal_ai_app/services/api_service.dart';
import 'package:personal_ai_app/widgets/chat_widget.dart';
import 'package:personal_ai_app/widgets/text_widget.dart';
import 'package:personal_ai_app/services/services.dart';
import 'package:personal_ai_app/services/assets_manager.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = true;
  late TextEditingController textEditingController;

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
          'Personal AI',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatMessages[index]['msg'],
                    chatIndex: chatMessages[index]['chatIndex'],
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SizedBox(
                height: 15,
              ),
              const Material(
                color: kCardColor,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle send button press
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
