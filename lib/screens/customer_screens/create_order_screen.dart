import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/widgets/custom_text_field.dart';
import 'package:mycar/models/car_spare_company.dart';
import 'package:mycar/models/customer_car.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:mycar/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';

import '../../core/styles/app_text_styles.dart';
import '../../generated/l10n.dart';
import '../../models/order.dart';
import '../../models/service_style.dart.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../shared/chat_widgets/attachment_widget.dart';

class CreateOrderScreen extends StatefulWidget {
  final CustomerCar car;
  final User? serviceProvider;
  final CarSpareCompany? carSpare;
  const CreateOrderScreen({
    super.key,
    required this.car,
    this.serviceProvider,
    this.carSpare,
  });

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  late AuthProvider auth;
  final ImagePicker picker = ImagePicker();
  GlobalKey<FormState> form = GlobalKey<FormState>();
  List<ServiceStyle> services = [];
  ServiceStyle? service;
  bool loadingServices = true;
  bool loading = false;
  bool serviceError = false;
  String serviceType = "atPlace";
  File? attachment;
  TextEditingController desc = TextEditingController();

  @override
  void initState() {
    if (widget.serviceProvider is User) {
      service = widget.serviceProvider?.serviceStyle;
      if (widget.serviceProvider!.serviceType.length == 1) {
        serviceType = widget.serviceProvider!.serviceType.first;
      }
      if (widget.serviceProvider?.serviceStyle?.key == "flatbed_service") {
        serviceType = "atPlace";
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((v) {
      loadData();
    });
    super.initState();
  }

  loadData() async {
    final resp = await ApiService.get(
      "/services",
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        loadingServices = false;
        services = List.generate(
          resp.data.length,
          (i) => ServiceStyle.fromMap(
            resp.data[i],
          ),
        );
      });
    }
  }
create() async {
  final valid = form.currentState!.validate();
  if (valid && !loading && service is ServiceStyle) {
    setState(() {
      loading = true;
    });
    
    // Check for existing ACTIVE chat if service provider is provided
    if (widget.serviceProvider != null) {
      final chatsResp = await ApiService.get(
        "/chats",
        queryParams: {
          "limit": 100,
          "skip": 0,
        },
        token: auth.token,
      );
      
      if (chatsResp.success && chatsResp.data != null) {
        bool chatExists = false;
        
        for (var chatData in chatsResp.data) {
          // Check if this chat is with the same provider
          String? chatProviderId;
          String? orderStatus;
          
          if (chatData['provider'] != null) {
            if (chatData['provider'] is String) {
              chatProviderId = chatData['provider'];
            } else if (chatData['provider'] is Map && chatData['provider']['_id'] != null) {
              chatProviderId = chatData['provider']['_id'];
            }
          }
          
          // Get order status
          if (chatData['order'] != null && chatData['order']['status'] != null) {
            orderStatus = chatData['order']['status'] as String;
          }
          
          // Skip if order is completed or canceled
          if (orderStatus == 'completed' || orderStatus == 'canceled') {
            continue;
          }
          
          // If provider matches and order is active/pending, chat exists
          if (chatProviderId == widget.serviceProvider!.id) {
            chatExists = true;
            break;
          }
        }
        
        if (chatExists) {
          if (mounted) {
            setState(() {
              loading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "You already have an active chat with this service provider"
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }
    }
    
    // Proceed with order creation
    Map<String, dynamic> map = {
      "serviceStyle": service?.id,
      "userCar": widget.car.id,
      "serviceType": serviceType,
    };
    if (widget.serviceProvider is User) {
      map['serviceProvider'] = widget.serviceProvider?.id;
    }
    if (widget.carSpare is CarSpareCompany) {
      map['carSpare'] = widget.carSpare?.id;
    }
    if (desc.text.isNotEmpty) {
      map['problemDesc'] = desc.text;
    }
    if (attachment is File) {
      if (attachment!.path.split(".").last.isVideo) {
        MediaInfo? mediaInfo = await VideoCompress.compressVideo(
          attachment!.path,
          frameRate: 30,
          quality: VideoQuality.DefaultQuality,
          deleteOrigin: true,
        );
        if (mediaInfo is MediaInfo) {
          map['attachment'] = await MultipartFile.fromFile(mediaInfo.path!);
          map['attachmentType'] = mediaInfo.path!.split(".").last;
        }
      } else {
        map['attachment'] = await MultipartFile.fromFile(attachment!.path);
        map['attachmentType'] = attachment!.path.split(".").last;
      }
    }
    final resp = await ApiService.postFormdata(
      "/orders",
      map,
      token: auth.token,
    );
    if (resp.success) {
      if (mounted) {
        Navigator.pop(context, Order.fromMap(resp.data));
      }
    } else {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  } else {
    if (service is! ServiceStyle && mounted) {
      setState(() {
        serviceError = true;
      });
    }
  }
}

  captureImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 5,
    );
    if (image is XFile && mounted) {
      setState(() {
        attachment = File(image.path);
      });
    }
  }

  captureVideo() async {
    final XFile? image = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(
        seconds: 15,
      ),
    );
    if (image is XFile && mounted) {
      setState(() {
        attachment = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(
          color: theme.scaffoldBackgroundColor,
        ),
        title: Text(
          S.current.orderDetails,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.scaffoldBackgroundColor,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: form,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: serviceError
                                ? Border.all(
                                    color: theme.colorScheme.error,
                                  )
                                : null,
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S.current.serviceType,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              if (service is! ServiceStyle)
                                Builder(
                                  builder: (context) {
                                    if (loadingServices) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  5,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Loader(),
                                      ),
                                    ),
                                  ),
                                ),
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: List.generate(
                                          services.length,
                                          (i) => InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (service?.id !=
                                                    services[i].id) {
                                                  service = services[i];
                                                } else {
                                                  service = null;
                                                }
                                                if (services[i].key ==
                                                    "flatbed_service") {
                                                  serviceType = "atPlace";
                                                }
                                                serviceError = false;
                                              });
                                            },
                                            child: SelectServiceCard(
                                              service: services[i],
                                              selected: service?.id ==
                                                      services[i].id &&
                                                  widget.serviceProvider
                                                      is! User,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              if (service is ServiceStyle)
                                SelectServiceCard(
                                  service: service!,
                                  selected:
                                      true && widget.serviceProvider is! User,
                                  remove: () {
                                    setState(() {
                                      service = null;
                                    });
                                  },
                                ),
                              Visibility(
                                visible: serviceError,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        S.current.fieldRequired,
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (widget.serviceProvider is User)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      S.current.serviceProvider,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: widget.serviceProvider
                                                    ?.avatar is String
                                                ? CachedNetworkImage(
                                                    imageUrl: widget
                                                        .serviceProvider!
                                                        .avatar!,
                                                    width: 45,
                                                    height: 45,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CircleAvatar(
                                                    radius: 22.5,
                                                    backgroundColor:
                                                        theme.primaryColor,
                                                    child: Center(
                                                      child: Text(
                                                        widget
                                                            .serviceProvider!
                                                            .name
                                                            .characters
                                                            .first,
                                                        style: TextStyle(
                                                          color: theme
                                                              .scaffoldBackgroundColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          const Gap(10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.serviceProvider!.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                S.current.farAway(double.tryParse(widget
                                                    .serviceProvider!.dist) ?? 0.0),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
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
                      if (widget.carSpare is CarSpareCompany)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      S.current.selectSpare,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: widget.carSpare?.image
                                                    is String
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        widget.carSpare!.image!,
                                                    width: 65,
                                                    height: 65,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    "assets/spare.png",
                                                    width: 65,
                                                    height: 65,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          const Gap(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget
                                                      .carSpare!.carSpare!.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S.current.orderType,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if ((widget.serviceProvider is User &&
                                          widget.serviceProvider!.serviceType
                                              .contains("atPlace")) ||
                                      widget.serviceProvider is! User)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  serviceType = "atPlace";
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border:
                                                      serviceType == "atPlace"
                                                          ? Border.all(
                                                              color: theme
                                                                  .primaryColor,
                                                              width: 2,
                                                            )
                                                          : null,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle_rounded,
                                                      color: serviceType ==
                                                              "atPlace"
                                                          ? theme.primaryColor
                                                          : Colors.grey,
                                                    ),
                                                    const Gap(10),
                                                    Text(
                                                      S.current.atPlace,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: serviceType ==
                                                                "atPlace"
                                                            ? theme.primaryColor
                                                            : Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if ((widget.serviceProvider is User &&
                                          widget.serviceProvider!.serviceType
                                              .contains("atShop")) ||
                                      service?.key != "flatbed_service")
                                    const Gap(8),
                                  if ((widget.serviceProvider is User &&
                                          widget.serviceProvider!.serviceType
                                              .contains("atShop")) ||
                                      service?.key != "flatbed_service")
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  serviceType = "atShop";
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border:
                                                      serviceType == "atShop"
                                                          ? Border.all(
                                                              color: theme
                                                                  .primaryColor,
                                                              width: 2,
                                                            )
                                                          : null,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle_rounded,
                                                      color: serviceType ==
                                                              "atShop"
                                                          ? theme.primaryColor
                                                          : Colors.grey,
                                                    ),
                                                    const Gap(10),
                                                    Text(
                                                      S.current.atShop,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: serviceType ==
                                                                "atShop"
                                                            ? theme.primaryColor
                                                            : Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S.current.orderAttachment,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Container(
                                width: context.width * 0.8,
                                height: context.height * 0.20,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.1),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: attachment is File
                                    ? Center(
                                        child: AttachmentWidget(
                                          attachment: attachment!.path,
                                          attachmentType:
                                              attachment!.path.split(".").last,
                                          isMine: true,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          S.current.videoOrImage,
                                          style: AppTextStyles.medium14,
                                        ),
                                      ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      onTap: captureImage,
                                      leading: const Icon(Icons.camera),
                                      title: Text(
                                        S.current.captureImage,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const Gap(5),
                                  Expanded(
                                    child: ListTile(
                                      onTap: captureVideo,
                                      leading:
                                          const Icon(Icons.video_call_rounded),
                                      title: Text(
                                        S.current.captureVideo,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S.current.orderDesc,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: CustomTextField(
                                  controller: desc,
                                  hintText: S.current.orderDesc,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButtonWidget(
                color: theme.primaryColor,
                height: 50,
                radius: 15,
                isLoading: loading,
                textColor: theme.scaffoldBackgroundColor,
                title: S.current.completeOrder,
                onPressed: create,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectServiceCard extends StatelessWidget {
  const SelectServiceCard({
    super.key,
    required this.service,
    this.selected = false,
    this.remove,
  });
  final ServiceStyle service;
  final bool selected;
  final Function()? remove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 2,
                    offset: const Offset(3, 3),
                  )
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: service.icon,
                color: theme.primaryColor,
                errorWidget: (context, url, error) {
                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  );
                },
                width: 24,
              ),
            ),
            const Gap(10),
            Expanded(
              child: Text(
                service.name,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            if (selected) const Gap(5),
            Visibility(
              visible: selected,
              child: IconButton(
                onPressed: remove,
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
