import 'dart:async';

import 'package:mycar/models/chat_message.dart';
import 'package:mycar/models/user.dart';

import 'order.dart';

class Chat {
  String id;
  User client;
  User provider;
  Order order;
  String status;
  int unreadCount;
  bool isTyping;
  ChatMessage? unread;
  DateTime createdAt;
  late Timer typingTimer;
  Chat({
    required this.id,
    required this.client,
    required this.provider,
    required this.order,
    required this.status,
    required this.unreadCount,
    required this.createdAt,
    this.isTyping = false,
    this.unread,
  }) {
    typingTimer = Timer(const Duration(seconds: 1), () {
      isTyping = false;
    });
  }

  String displayName(String user) {
    if (user == client.id) {
      return provider.name;
    } else {
      return client.name;
    }
  }

  String? getAvatar(String user) {
    if (user == client.id) {
      return provider.avatar;
    } else {
      return client.avatar;
    }
  }

  bool isActive(String user) {
    if (user == client.id) {
      return provider.socket is String;
    } else {
      return client.socket is String;
    }
  }

  String userId(String user) {
    if (user == client.id) {
      return provider.id;
    } else {
      return client.id;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'client': client.toMap(),
      'provider': provider.toMap(),
      'order': order.toMap(),
      'status': status,
      'unreadCount': unreadCount,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      client: User.fromMap(map['client'] as Map<String, dynamic>),
      provider: User.fromMap(map['provider'] as Map<String, dynamic>),
      order: Order.fromMap(map['order'] as Map<String, dynamic>),
      unread: map['unread'] != null
          ? ChatMessage.fromMap(map['unread'] as Map<String, dynamic>)
          : null,
      status: map['status'] as String,
      unreadCount: (map['unreadCount'] ?? 0) as int,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
