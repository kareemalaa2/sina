// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/models/chat.dart';
import 'package:mycar/models/customer_car.dart';
import 'package:mycar/models/order.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_service.dart';

class CreateChatWidget extends StatefulWidget {
  final Order order;
  const CreateChatWidget({
    super.key,
    required this.order,
  });

  @override
  State<CreateChatWidget> createState() => _CreateChatWidgetState();
}

class _CreateChatWidgetState extends State<CreateChatWidget> {
  late AuthProvider auth;
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      createChat();
    });
    super.initState();
  }

  createChat() async {
    final resp = await ApiService.post(
      "/chats",
      {
        "order": widget.order.id,
      },
      token: auth.token,
    );
    if (resp.success) {
      Future.delayed(const Duration(seconds: 3)).then((v) {
        if (mounted) {
          Navigator.pop(context, Chat.fromMap(resp.data));
        }
      });
    } else {
      if (mounted) {
        loading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.current.creatingChat,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const Gap(5),
        Icon(
          Icons.chat,
          size: 45,
          color: theme.primaryColor,
        ),
        const Gap(5),
        Padding(
          padding: const EdgeInsets.all(100),
          child: Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class CarCardWidget extends StatelessWidget {
  const CarCardWidget({
    super.key,
    required this.car,
    required this.onTap,
    this.selected = false,
  });
  final CustomerCar car;
  final bool selected;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 3.0,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(
              color: selected ? theme.primaryColor : Colors.grey,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: car.carCompany.logo,
                      width: 60,
                      height: 60,
                      errorWidget: (ctx, err, w) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                        );
                      },
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.carName.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: S.current.modelYear,
                                children: [
                                  const TextSpan(
                                    text: " :   ",
                                  ),
                                  TextSpan(
                                    text: car.carModel.toString(),
                                    style: AppTextStyles.regular12.copyWith(
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              style: AppTextStyles.bold16.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            text: car.carCompany.name,
                          ),
                          style: AppTextStyles.bold16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
