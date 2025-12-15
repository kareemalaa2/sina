import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/route_generator.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/chat_message.dart';

class ChatRate extends StatefulWidget {
  final ChatMessage message;
  const ChatRate({
    super.key,
    required this.message,
  });

  @override
  State<ChatRate> createState() => _ChatRateState();
}

class _ChatRateState extends State<ChatRate> {
  double rate = 1;
  bool isLoading = false;
  TextEditingController message = TextEditingController();
  late AuthProvider auth;

  @override
  void initState() {
    super.initState();
  }

rating() async {
  if (!isLoading) {
    setState(() {
      isLoading = true;
    });

    final resp = await ApiService.put(
      "/chats/rate",
      {
        "rate": rate,
        "message": message.text,
        "user": auth.user?.name,
      },
      queryParams: {
        "id": widget.message.id,
      },
      token: auth.token,
    );

    if (mounted) {
      setState(() {
        isLoading = false;
      });

 if (resp.success) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        'Rating submitted successfully!',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: Duration(seconds: 1),
    ),
  );

  await Future.delayed(const Duration(milliseconds: 500));

  if (mounted) {
    // ✅ Replace current route entirely
    context.go('/customer-home');
  }
}
else {
        // ❌ Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Failed to submit rating. Please try again.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    auth = Provider.of<AuthProvider>(context);
    bool isMine = widget.message.isMine(auth.user?.id ?? "");
    return Container(
      constraints: BoxConstraints(
        maxWidth: size.width,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                widget.message.isRating && widget.message.rate is int
                    ? Icons.check_circle_outline
                    : Icons.timer,
                color: widget.message.isRating && widget.message.rate is int
                    ? Colors.green
                    : theme.scaffoldBackgroundColor,
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: 3,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: widget.message.sender.avatar ?? "",
                    errorWidget: (context, url, error) {
                      return CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text.rich(
                            TextSpan(
                              text: widget
                                  .message.sender.name.characters.firstOrNull
                                  ?.toUpperCase(),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
            ],
          ),
          const Gap(10),
          Text.rich(
            TextSpan(
              text: widget.message.sender.name,
            ),
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: !isMine ? null : theme.scaffoldBackgroundColor,
            ),
          ),
          const Gap(10),
          RatingBar.builder(
            initialRating: (widget.message.rate ?? rate).toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            unratedColor: theme.scaffoldBackgroundColor,
            itemPadding: const EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
              shadows: [
                BoxShadow(
                  color: theme.scaffoldBackgroundColor,
                  blurRadius: 5,
                  spreadRadius: 5,
                ),
              ],
            ),
            onRatingUpdate: (rating) {
              if (widget.message.rate is! double &&
                  auth.user?.serviceStyle is! ServiceStyle) {
                setState(() {
                  rate = rating;
                });
              }
            },
          ),
          const Gap(10),
          if (widget.message.rate is! int &&
              auth.user?.serviceStyle is! ServiceStyle)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    minLines: 3,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: S.current.writeSomething,
                    ),
                  ),
                ),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: widget.message.message,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !isMine ? null : theme.scaffoldBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
          if (widget.message.rate is! int &&
              auth.user?.serviceStyle is! ServiceStyle)
            Row(
              children: [
                Expanded(
                  child: ElevatedButtonWidget(
                    isLoading: isLoading,
                    onPressed: rating,
                    color: Colors.green,
                    title: S.current.send,
                    textColor: theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          if (widget.message.rate is! int) const Gap(10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  DateFormat("hh:mm a").format(widget.message.createdAt),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: !isMine ? null : theme.scaffoldBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
