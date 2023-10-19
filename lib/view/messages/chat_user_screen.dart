import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';
import 'package:intl/intl.dart';
import '../../constants/components.dart';

class ChatUserScreen extends StatefulWidget {
  final String name;

  const ChatUserScreen({Key? key, required this.name}) : super(key: key);

  @override
  ChatUserScreenState createState() => ChatUserScreenState(name);
}

class ChatUserScreenState extends State<ChatUserScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Object> _messages = []; // List to store messages
  final String name;
  late ScrollController _scrollController;

  ChatUserScreenState(this.name);

  @override
  void initState() {
    super.initState();
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    _scrollController = ScrollController();
    _messages.add(
      SentMessage(
        content: 'Hello!',
        timestamp: '10:00 AM',
      ),
    );
    _messages.add(
      ReceivedMessage(
        content: 'Hello, I need installers, do you have a team?',
        timestamp: '10:02 AM',
      ),
    );
    _messages.add(
      SentMessage(
        content: "I'm fine, thanks",
        timestamp: '10:03 AM',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('chat'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'today',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(137, 138, 141, 1),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildMessage(_messages[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(Object message) {
    if (message is SentMessage) {
      return _buildSentMessage(message);
    } else if (message is ReceivedMessage) {
      return _buildReceivedMessage(message);
    }
    return const SizedBox.shrink(); // Handle other message types if needed
  }

  Widget _buildSentMessage(SentMessage message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(93, 176, 117, 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: screenWidth(context, .7)),
          child: Text(
            message.content,
            style: midTextStyle(context, const Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
        Text(
          message.timestamp,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color.fromRGBO(137, 138, 141, 1),
            // overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildReceivedMessage(ReceivedMessage message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const ClipOval(
            child: Image(
              image: AssetImage('assets/images/person.png'),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: midTextStyle(context, black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                constraints: BoxConstraints(maxWidth: screenWidth(context, .7)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    message.content,
                    style: midTextStyle(context, black),
                  ),
                ),
              ),
            ),
            Text(
              message.timestamp,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(137, 138, 141, 1),
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: const Color.fromRGBO(236, 236, 236, 1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(76, 217, 100, 1),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.add,
                    color: white,
                    size: 25,
                  ),
                ),
              ),
              onPressed: (){},
            ),
            Expanded(
              child: TFF(
                controller: _messageController,
                action: TextInputAction.send,
                type: TextInputType.text,
                hint: 'Placeholder',
                filled: true,
                isPrefix: false,
                borderColor: white,
                prefix: Icons.tag_faces,
                underlineBorder: false,
                isOutLineBorder: false,
                suffix: Icons.arrow_upward_outlined,
                SuffixContainerColor: const Color.fromRGBO(0, 122, 255, 1),
                suffixColor: white,
                suffixSize: 20,
                suffixPressed: (){
                  final messageText =
                  _messageController.text.trim(); // Trim whitespace
                  if (messageText.isNotEmpty) {
                    final newMessage = SentMessage(
                      content: messageText,
                      timestamp: DateFormat('hh:mm a').format(DateTime.now()),
                    );
                    setState(() {
                      _messages.add(newMessage);
                      _messageController.clear();
                    });

                    // Scroll to the bottom in real-time
                    _scrollToBottom();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// Function to scroll to the bottom
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class SentMessage {
  final String content;
  final String timestamp;

  SentMessage({required this.content, required this.timestamp});
}

class ReceivedMessage {
  final String content;
  final String timestamp;

  ReceivedMessage({required this.content, required this.timestamp});
}


