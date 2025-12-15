import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycar/models/chat.dart';
import 'package:mycar/models/chat_message.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../providers/auth_provider.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;
  final Function()? onTap;
  const ChatCard({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        onTap: onTap,
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 3,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: chat.getAvatar(
                          auth.user?.id ?? "",
                        ) ??
                        "",
                    errorWidget: (context, url, error) {
                      return CircleAvatar(
                        child: Text.rich(
                          TextSpan(
                            text: chat
                                .displayName(auth.user?.id ?? "")
                                .characters
                                .firstOrNull
                                ?.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.circle,
                size: 18,
                color: chat.isActive(auth.user?.id ?? "")
                    ? Colors.green
                    : Colors.grey,
              ),
            ),
          ],
        ),
        title: Text.rich(
          TextSpan(
            text: chat.displayName(auth.user?.id ?? ""),
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text.rich(
          TextSpan(
            text: chat.isTyping
                ? S.current.isTyping
                : chat.unread is ChatMessage
                    ? chat.unread?.message
                    : S.current.noMessages,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: chat.isTyping
                ? theme.primaryColor
                : chat.unread is ChatMessage
                    ? null
                    : const Color.fromARGB(255, 143, 143, 143),
            fontSize: 14,
          ),
        ),
        trailing: SizedBox(
          width: 75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat("hh:mm a").format(chat.createdAt),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 143, 143, 143),
                ),
              ),
              Visibility(
                visible: chat.unreadCount > 0,
                child: Column(
                  children: [
                    Container( 
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration( 
                        shape: BoxShape.circle,
                        color: theme.primaryColor,
                      ),
                      child:    Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                 
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
