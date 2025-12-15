import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/screens/shared/chat_widgets/attachment_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/chat_message.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessage message;
  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final auth = Provider.of<AuthProvider>(context);
    bool isMine = widget.message.isMine(auth.user?.id ?? "");
    return SizedBox(
      width: size.width,
      child: Row(
        mainAxisAlignment:
            !isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.85,
            ),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: !isMine
                  ? Colors.grey.shade300
                  : theme.primaryColor.withValues(
                      alpha: 0.9,
                    ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!widget.message.isFile)
                  Text.rich(
                    TextSpan(
                      text: widget.message.message,
                    ),
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: !isMine ? null : theme.scaffoldBackgroundColor,
                    ),
                  ),
                Visibility(
                  visible: widget.message.lat is double &&
                      widget.message.lng is double,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AnyLinkPreview.builder(
                            itemBuilder: (p0, p1, p2, p3) {
                              return InkWell(
                                onTap: () {
                                  launchUrl(
                                    Uri(
                                      scheme: "https",
                                      host: "maps.google.com",
                                      queryParameters: {
                                        "q":
                                            "${widget.message.lat},${widget.message.lng}"
                                      },
                                    ),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                child: Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: theme.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    image: DecorationImage(
                                      image: p2!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              color:
                                                  theme.scaffoldBackgroundColor,
                                              child: Text.rich(
                                                TextSpan(
                                                  text: p1.title,
                                                ),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            placeholderWidget: const LinearProgressIndicator(),
                            link:
                                'https://maps.google.com?q=${widget.message.lat},${widget.message.lng}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.message.isFile)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AttachmentWidget(
                      key: GlobalKey(
                        debugLabel: widget.message.attachment,
                      ),
                      attachment: widget.message.attachment!,
                      attachmentType: widget.message.attachmentType!,
                      isMine: isMine,
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isMine)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          DateFormat("hh:mm a")
                              .format(widget.message.createdAt),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color:
                                !isMine ? null : theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    if (isMine)
                      Icon(
                        widget.message.read
                            ? Icons.done_all_outlined
                            : Icons.done_outlined,
                        color: theme.scaffoldBackgroundColor,
                        size: 18,
                      ),
                    if (!isMine)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          DateFormat("hh:mm a")
                              .format(widget.message.createdAt),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color:
                                !isMine ? null : theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
