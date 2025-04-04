// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_ai_app/constants.dart';
import 'package:personal_ai_app/chat_widget.dart';
import 'package:personal_ai_app/api_service.dart';
import 'package:personal_ai_app/core/utils/logger.dart';
import 'package:personal_ai_app/services.dart';
import '../../../../assets_manager.dart';

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
      chatMessages.insert(0, {
        'msg': text,
        'chatIndex': 1,
        'timestamp': DateTime.now().toIso8601String(),
      });
      textEditingController.clear();
    });

    try {
      // Fixed: Remove extra context parameter
      final response = await ApiService.sendMessage(text);
      if (!mounted) return;

      setState(() {
        chatMessages.insert(0, {
          'msg': response,
          'chatIndex': 2,
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
    } catch (e) {
      logger.e('Error in _handleSubmitted: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: Failed to get response',
            style: TextStyle(
              fontFamily: GoogleFonts.tajawal().fontFamily,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isTyping = false);
      }
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
        title: Text('Personal AI مساعدك الشخصي'),
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
                itemCount: chatMessages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  if (chatMessages.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.tajawal().fontFamily),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.tajawal().fontFamily),
                        controller: textEditingController,
                        onSubmitted: _handleSubmitted,
                        decoration: InputDecoration.collapsed(
                          hintText: 'How can I help you',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: GoogleFonts.tajawal().fontFamily,
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
