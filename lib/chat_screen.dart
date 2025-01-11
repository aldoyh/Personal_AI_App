// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_ai_app/constants.dart';
import 'package:personal_ai_app/chat_widget.dart';
import 'package:personal_ai_app/services.dart';
import 'package:personal_ai_app/api_service.dart';
import 'core/utils/logger.dart';
import '../../assets_manager.dart';
// import 'features/settings/domain/providers/settings_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;

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

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _isTyping = true;
      chatMessages.insert(0, {'msg': text, 'chatIndex': 1});
      textEditingController.clear();
    });

    try {
      // Send the message to the API
      final response = await ApiService.sendMessage(text);
      setState(() {
        chatMessages.insert(0, {'msg': response, 'chatIndex': 2});
      });
    } catch (e) {
      logger.e('Error in _handleSubmitted: $e');
      setState(() {
        chatMessages.insert(0, {'msg': 'Error: $e', 'chatIndex': 2});
      });
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
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
        title: Text('Personal AI مساعدك الشخصي',
            style: TextStyle(
              color: const Color.fromARGB(255, 71, 2, 91),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.tajawal.toString(),
            )),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
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
                itemCount: chatMessages.length,
                reverse: true,
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
                    logger.d("Building chat bubble. No $index");
                  }
                  return ChatWidget(
                    msg: chatMessages[index]['msg'].toString(),
                    chatIndex:
                        int.parse(chatMessages[index]['chatIndex'].toString()),
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
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
                        onSubmitted: _handleSubmitted,
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
                        _handleSubmitted(textEditingController.text);
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
          ],
        ),
      ),
    );
  }
}
