import 'package:flutter/material.dart';

import '../../../../models/message.dart';
import '../../../shared/profile_pic.dart';
import '../../../theme/globals.dart';

class ChatMessage extends StatelessWidget {
  final Message msg;
  final String uid;

  const ChatMessage({
    Key? key,
    required this.msg,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.55;

    if (uid == msg.sentUid) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: width,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: red,
                      ),
                      child: Text(
                        msg.content,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ProfilePic(url: msg.photoURL, size: 12),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              msg.name.split(" ")[0],
              textAlign: TextAlign.right,
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfilePic(url: msg.photoURL, size: 12),
            const SizedBox(width: 4),
            SizedBox(
              width: width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                  child: Text(
                    msg.content,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(msg.name.split(" ")[0]),
      ],
    );
  }
}
