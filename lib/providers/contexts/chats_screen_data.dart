import 'package:flutter/material.dart';

import '../../models/chat.dart';

class ChatsScreenData {
  ScrollController scrollController = ScrollController();
  List<Chat> chats = [];
  int total = 0;
  int page = 0;
  String status = "";
  ValueNotifier<bool> loading = ValueNotifier(false);
}
