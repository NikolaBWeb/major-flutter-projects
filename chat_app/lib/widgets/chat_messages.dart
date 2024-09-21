import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authedUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching messages'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 10,
            right: 10,
          ),
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final chatMessage = snapshot.data!.docs[index].data();
            final nextChatMessage = index + 1 < snapshot.data!.docs.length
                ? snapshot.data!.docs[index + 1].data()
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final isSameUser = currentMessageUserId == nextMessageUserId;

            if (isSameUser) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: currentMessageUserId == authedUser?.uid,
              );
            } else {
              return MessageBubble.first(
                message: chatMessage['text'],
                isMe: currentMessageUserId == authedUser?.uid,
                username: chatMessage['username'],
                userImage: chatMessage['image_url'], // Changed 'imageUrl' to 'image_url' to match the Firestore field
              );
            }
          },
        );
      },
    );
  }
}
