import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/car_spare_company.dart';
import 'package:mycar/models/chat.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:mycar/models/user.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';
import '../../core/styles/app_text_styles.dart';
import '../../models/order.dart';
import 'chat_widgets/attachment_widget.dart';
import 'create_chat_widget.dart';

class OrdersDetailsModal extends StatefulWidget {
  const OrdersDetailsModal({super.key, required this.order});
  final Order order;

  @override
  State<OrdersDetailsModal> createState() => _OrdersDetailsModalState();
}

class _OrdersDetailsModalState extends State<OrdersDetailsModal> {
  bool isAccepting = false;
  bool isRejecting = false;

  Future<Chat?> acceptOrder(BuildContext context, AuthProvider auth) async {
    if (isAccepting) return null;

    setState(() {
      isAccepting = true;
    });

    try {
      // First, show the create chat widget to get the chat
      final chat = await showModalBottomSheet<Chat>(
        context: context,
        showDragHandle: true,
        enableDrag: true,
        useRootNavigator: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        sheetAnimationStyle: const AnimationStyle(
          curve: Curves.easeInOutCubic,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.45,
        ),
        builder: (context) {
          return CreateChatWidget(
            order: widget.order,
          );
        },
      );

      if (chat == null) {
        setState(() {
          isAccepting = false;
        });
        return null;
      }

      // Now accept the offer with the chat ID
      final resp = await ApiService.put(
        "/orders/offers",
        {
          "id": chat.id,
        },
        token: auth.token,
      );

      if (resp.success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              S.current.acceptOrder,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        
        // Update chat status before returning
        chat.status = "active";
        chat.order.status = "active";
        
        return chat;
      } else {
        if (mounted) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                resp.message ?? "An error occurred",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        return null;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "An error occurred: $e",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          isAccepting = false;
        });
      }
    }
  }

Future<bool> rejectOrder(BuildContext context, AuthProvider auth) async {
  if (isRejecting) return false;

  // Show confirmation dialog
  bool? confirmReject = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(S.current.rejectOrder),
        content:  Text(S.current.rejectOrderConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Reject",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );

  if (confirmReject != true) {
    return false;
  }

  setState(() {
    isRejecting = true;
  });

  try {
    // Use the cancel endpoint but update status to "rejected" locally
    final resp = await ApiService.put(
      "/orders/cancel",  // Using cancel endpoint
      {"id": widget.order.id},
      token: auth.token,
    );

    if (resp.success && mounted) {
      // Update order status
      setState(() {
        widget.order.status = "rejected";  // Or "canceled" if that's what backend returns
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            S.current.rejectOrder ,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      
      return true;
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              resp.message ?? "An error occurred",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      return false;
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "An error occurred: $e",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return false;
  } finally {
    if (mounted) {
      setState(() {
        isRejecting = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: widget.order.user?.name ?? S.current.orderPending,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: widget.order.problemDesc ??
                                        (widget.order.userCar != null 
                                            ? "${widget.order.userCar!.carCompany?.name ?? ''} - ${widget.order.userCar!.carName?.name ?? ''}"
                                            : S.current.orderPending),
                                  ),
                                  style: AppTextStyles.regular12.copyWith(
                                    color: const Color.fromARGB(
                                        255, 100, 100, 100),
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: DateFormat("yyyy/MM/dd hh:mm a")
                                        .format(widget.order.createdAt),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.order.serviceProviderId is String,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.flash_on_outlined,
                                color: Colors.yellow,
                              ),
                              const Gap(10),
                              Text(
                                S.current.privateOrder,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                    ),
                    child: Row(
                      children: [
                        if (widget.order.serviceStyle is ServiceStyle)
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.order.serviceStyle!.icon,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    widget.order.serviceStyle!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const Gap(10),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: theme.primaryColor,
                                ),
                                const Gap(10),
                                Text(
                                  widget.order.place,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (auth.user?.serviceStyle is! ServiceStyle &&
                      widget.order.serviceProvider is User)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.order.serviceProvider?.avatar ??
                                                  "",
                                          errorWidget: (context, url, error) {
                                            return Image.asset(
                                              "assets/spare.png",
                                              width: 45,
                                            );
                                          },
                                          width: 45,
                                        ),
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text.rich(
                                                TextSpan(
                                                  text: widget.order
                                                      .serviceProvider?.name ?? '',
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: S.current.locale == "ar" ? 0 : null,
                                  right: S.current.locale == "ar" ? null : 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      S.current.serviceProvider,
                                      style: TextStyle(
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.order.carSpare is CarSpareCompany)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: widget.order.carSpare?.image ?? "",
                                        errorWidget: (context, url, error) {
                                          return Image.asset(
                                            "assets/spare.png",
                                            width: 120,
                                          );
                                        },
                                        width: 120,
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                      text: widget.order.carSpare
                                                          ?.carSpare?.name ?? '',
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (widget.order.carSpare?.price is double)
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        text: (widget.order.carSpare
                                                                    ?.price ??
                                                                0)
                                                            .toStringAsFixed(2),
                                                        children: [
                                                          const TextSpan(
                                                              text: "  "),
                                                          TextSpan(
                                                            text: widget.order
                                                                .serviceProvider
                                                                ?.country
                                                                .currency ?? '',
                                                          )
                                                        ],
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                ),
                                Positioned(
                                  left: S.current.locale == "ar" ? 0 : null,
                                  right: S.current.locale == "ar" ? null : 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      widget.order.carSpare?.condition == "new"
                                          ? S.current.newSpare
                                          : S.current.usedSpare,
                                      style: TextStyle(
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (widget.order.attachment is String)
                    Row(
                      children: [
                        Text(
                          S.current.orderAttachment,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  if (widget.order.attachment is String)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).width * 0.5,
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: AttachmentWidget(
                                  attachment: widget.order.attachment!,
                                  attachmentType: widget.order.attachmentType!,
                                  isMine: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.order.problemDesc is String)
                    Row(
                      children: [
                        Text(
                          S.current.orderDesc,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  if (widget.order.problemDesc is String)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(text: widget.order.problemDesc),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const Gap(10),
        // Show Accept/Reject buttons for service providers
        if (auth.user?.serviceStyle is ServiceStyle)
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: Platform.isIOS ? 25 : 8.0,
            ),
            child: Row(
              children: [
                Flexible(
                  child: ElevatedButtonWidget(
                    onPressed: (isAccepting || isRejecting) ? null : () async {
                      final rejected = await rejectOrder(context, auth);
                      if (rejected && mounted) {
                        Navigator.pop(context);
                      }
                    },
                    title: isRejecting ? "..." : S.current.rejectOrder,
                    textColor: theme.scaffoldBackgroundColor,
                    color: theme.colorScheme.error,
                  ),
                ),
                const Gap(10),
                Flexible(
                  child: ElevatedButtonWidget(
                    onPressed: (isAccepting || isRejecting) ? null : () async {
                      final chat = await acceptOrder(context, auth);
                      if (chat != null && mounted) {
                        Navigator.pop(context, chat);
                      }
                    },
                    title: isAccepting ? "..." : S.current.accept,
                    textColor: theme.scaffoldBackgroundColor,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}