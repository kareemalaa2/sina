import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/chat.dart';
import 'package:mycar/models/chat_message.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
// import 'package:mycar/route_generator.dart';

import '../../generated/l10n.dart';
import '../../models/order.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/elevated_button_widget.dart';
import 'chat_widgets/chat_bubble.dart';
import 'chat_widgets/chat_rate.dart';
import 'widgets/accept_offer_dialog.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;
  const ChatScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

enum Menu { location, browseImage, captureImage, captureVideo, cancel }

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  TextEditingController message = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? file;
  Position? _locationData;
  late Chat chat;
  final ScrollController _scMessages = ScrollController();
  bool isMultimedia = false;
  late AuthProvider auth;
  List<ChatMessage> messages = [];
  int total = 0;
  int page = 0;
  bool loading = false;
  bool sending = false;
  ValueNotifier<bool> isTyping = ValueNotifier(false);
  final record = RecorderController();

  @override
  void initState() {
    chat = widget.chat;
    WidgetsBinding.instance.addPostFrameCallback((v) {
      loadData();
      auth.socket?.on("${chat.id}-message", (data) {
        if (mounted) {
          ChatMessage chatMsg = ChatMessage.fromMap(data);
          final msgIndex = messages.indexWhere((x) => x.id == chatMsg.id);
          setState(() {
            if (msgIndex == -1) {
              messages.insert(0, chatMsg);
              total++;
            } else {
              messages[msgIndex] = chatMsg;
            }
          });
        }
      });

      auth.socket?.on("${chat.order.id}-order", (data) {
        Order order = Order.fromMap(data);
        if (order.serviceProviderId == auth.user?.id && mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    S.current.acceptOffer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .closed
              .then((v) {});
        }
        if (order.serviceProviderId != auth.user?.id &&
            auth.user?.serviceStyle is ServiceStyle &&
            mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
                SnackBar(
                  backgroundColor: Colors.deepOrange,
                  content: Text(
                    S.current.offerDeclined,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .closed
              .then((v) {
            if (mounted) {
              context.pop();
            }
          });
        }
      });

      auth.socket?.on(chat.id, (data) {
        if (mounted) {
          Chat chatData = Chat.fromMap(data);
          setState(() {
            chat = chatData;
          });
        }
      });
    });
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get auth here instead
    auth = Provider.of<AuthProvider>(context, listen: false);
    
    // NOW do your debug logging
    print('=== ChatScreen Init Debug ===');
    print('Auth User ID: ${auth.user?.id}');
    print('Chat Provider ID: ${chat.provider.id}');
    print('Chat Client ID: ${chat.client.id}');
    print('Order Status: ${chat.order.status}');
    print('============================');
  }
  loadData({bool more = false}) async {
    setState(() {
      if (more) {
        page++;
      } else {
        page = 0;
        messages.clear();
      }
      loading = true;
    });
    final resp = await ApiService.get(
      "/chats/messages",
      queryParams: {
        "limit": 10,
        "skip": 0,
        "id": chat.id,
      },
      token: auth.token,
    );
    if (resp.success && mounted) {
      setState(() {
        messages.addAll(List.generate(
          resp.data.length,
          (i) => ChatMessage.fromMap(resp.data[i]),
        ));
        total = resp.total;
        loading = false;
      });
    } else {
      if (mounted) {
        loading = false;
      }
    }
  }

  sendMessage() async {
    final valid = form.currentState!.validate();
    if (record.isRecording) {
      await record.stop();
    }
    final Directory tempDir = await getTemporaryDirectory();
    bool isRecorded = await File(p.join(tempDir.path, "record.m4a")).exists();
    if ((valid && !sending) || isRecorded) {
      setState(() {
        sending = true;
      });
      Map<String, dynamic> map = {
        "chat": chat.id,
      };
      if (message.text.isNotEmpty) {
        map['message'] = message.text;
      }
      if (file is File) {
        map['attachment'] = await MultipartFile.fromFile(file!.path);
        map['attachmentType'] = file!.path.split(".").last;
      }
      if (isRecorded) {
        map['attachment'] =
            await MultipartFile.fromFile(p.join(tempDir.path, "record.m4a"));
        map['attachmentType'] = "m4a";
      }
      if (_locationData is Position) {
        map['lat'] = _locationData?.latitude;
        map['lng'] = _locationData?.longitude;
      }
      final resp = await ApiService.postFormdata(
        "/chats/messages",
        map,
        queryParams: {
          "limit": 10,
          "skip": 0,
          "id": chat.id,
        },
        token: auth.token,
      );
      if (resp.success) {
        if (isRecorded) {
          await File(p.join(tempDir.path, "record.m4a")).delete();
        }
        if (mounted) {
          final msg = ChatMessage.fromMap(resp.data);
          final msgIndex = messages.indexWhere((x) => x.id == msg.id);
          setState(() {
            if (msgIndex == -1) {
              messages.insert(0, msg);
            }
            total++;
            message.text = "";
            isMultimedia = false;
            _locationData = null;
            file = null;
            sending = false;
          });
          _scMessages.jumpTo(0);
        }
      } else {
        if (mounted) {
          setState(() {
            sending = false;
          });
        }
      }
    }
  }

  aquireLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && mounted) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && mounted) {
       await showDialog(context: context, 
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline_rounded,size: 30,color: Theme.of(context).primaryColor,),
                  const Gap(10),
                  Text(S.current.enableLocationServiceToContinue,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Theme.of(context).primaryColor,),),
                  const Gap(10),
                  ElevatedButtonWidget(
                    height: 48,
                    icon: Icons.map,
                    title: S.current.enableService,
                    onPressed: () {
                      Geolocator.openLocationSettings();
                    },
                  ),
                ],
              ),
            ),
          );
        },
    );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever && mounted) {
       await showDialog(context: context, 
        builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline_rounded,size: 30,color: Theme.of(context).primaryColor,),
                    const Gap(10),
                    Text(S.current.enableLocationServiceToContinue,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Theme.of(context).primaryColor,),),
                    const Gap(10),
                    ElevatedButtonWidget(
                      height: 48,
                      icon: Icons.map,
                      title: S.current.enableService,
                      onPressed: () {
                        Geolocator.openLocationSettings();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
      );
      return false;
    }
    _locationData = await Geolocator.getCurrentPosition();
    sendMessage();
  }

  pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image is XFile) {
      file = File(image.path);
      sendMessage();
    }
  }

  captureImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (image is XFile) {
      file = File(image.path);
      sendMessage();
    }
  }

  captureVideo() async {
    final XFile? image = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(
        seconds: 30,
      ),
    );
    if (image is XFile) {
      file = File(image.path);
      sendMessage();
    }
  }

  readMessage(ChatMessage msg) {
    if (msg.sender.id != auth.user?.id && !msg.read) {
      ApiService.put(
        "/chats/messages",
        {},
        queryParams: {
          "id": msg.id,
        },
        token: auth.token,
      );
    }
  }

  startRecording() async {
    bool hasPermission = await record.checkPermission();
    if (hasPermission) {
      final Directory tempDir = await getTemporaryDirectory();
      if (await File(p.join(tempDir.path, "record.m4a")).exists()) {
        await File(p.join(tempDir.path, "record.m4a")).delete();
      }
      await record.record(
        path: p.join(tempDir.path, "record.m4a"),
        androidEncoder: AndroidEncoder.aac,
        androidOutputFormat: AndroidOutputFormat.mpeg4,
        iosEncoder: IosEncoder.kAudioFormatMPEG4AAC,
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    auth.socket?.on("${chat.id}-typing", (data) {
      if (mounted) {
        if (auth.user?.id != data) {
          isTyping.value = true;
          Future.delayed(const Duration(seconds: 2)).then((v) {
            isTyping.value = false;
          });
        }
      }
    });
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BackButton(
                color: theme.scaffoldBackgroundColor,
              ),
              Container(
                width: 40,
                height: 40,
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
                    imageUrl: chat.getAvatar(auth.user?.id ?? "") ?? "",
                    errorWidget: (context, url, error) {
                      return CircleAvatar(
                        child: Text.rich(
                          TextSpan(
                            text: chat
                                .displayName(auth.user?.id ?? "")
                                .characters
                                .firstOrNull
                                ?.toUpperCase(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Text(
                    chat.displayName(auth.user?.id ?? ""),
                    style: TextStyle(
                      color: theme.scaffoldBackgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
if (chat.provider.id == auth.user?.id && chat.order.status == "pending")
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ElevatedButtonWidget(
      height: 35,
      radius: 50,
      onPressed: () async {
        final val = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AcceptOffer(chat: chat);
          },
        );
        if (val == true) {
          setState(() {
            chat.status = "active";
            chat.order.status = "active";
          });
        }
      },
      title: S.current.accept,
    ),
  ),

// Separate button for client to mark as completed
if (chat.client.id == auth.user?.id && chat.order.status == "active")
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: ElevatedButtonWidget(
      height: 35,
      radius: 50,
      onPressed: () async {
        final val = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AcceptOffer(chat: chat);
          },
        );
        if (val == true) {
          setState(() {
            chat.status = "completed";
            chat.order.status = "completed";
          });
        }
      },
      title: S.current.completed,
    ),
  ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 3,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
              itemCount: messages.length + 1,
              padding: EdgeInsets.only(
                bottom: 70 + (isMultimedia ? 115 : 0),
              ),
              controller: _scMessages,
              reverse: true,
              itemBuilder: (context, i) {
                if (i > 0) {
                  readMessage(messages[i - 1]);
                  if (messages[i - 1].isRating) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ChatRate(
                        message: messages[i - 1],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ChatBubble(
                        message: messages[i - 1],
                      ),
                    );
                  }
                } else {
                  return ValueListenableBuilder(
                    valueListenable: isTyping,
                    builder: (context, val, w) {
                      return Visibility(
                        visible: val,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                "assets/typing.gif",
                                height: 30,
                                width: 80,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
      bottomSheet: Visibility(
        visible:
            chat.order.status != "completed" && chat.order.status != "canceled",
        child: Container(
          padding: EdgeInsets.only(
            bottom: Platform.isIOS ? 10 : 5,
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Form(
            key: form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (record.isRecording) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      record.stop();
                                      record.setRefresh(true);
                                      setState(() {});
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          theme.scaffoldBackgroundColor,
                                      child: Icon(
                                        Icons.delete,
                                        color: theme.colorScheme.error,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: AudioWaveforms(
                                      size: Size(context.width * 0.65, 40),
                                      recorderController: record,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    child: StreamBuilder<Duration>(
                                      stream: record.onCurrentDuration,
                                      builder: (context, snapshot) {
                                        return Text(
                                          "${snapshot.data?.inMinutes}:${(snapshot.data?.inSeconds ?? 0) - ((snapshot.data?.inMinutes ?? 0) * 60)}",
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return TextFormField(
                              controller: message,
                              maxLines: 2,
                              minLines: 1,
                              validator: (value) {
                                if (isMultimedia || record.isRecording) {
                                  return null;
                                } else {
                                  if (value is String && value.isEmpty) {
                                    return "";
                                  } else {
                                    return null;
                                  }
                                }
                              },
                              onChanged: (value) {
                                auth.socket?.emit("send", {
                                  "room": "${chat.id}-typing",
                                  "data": auth.user?.id,
                                });
                                setState(() {});
                              },
                              onTap: () {
                                setState(() {
                                  isMultimedia = false;
                                });
                              },
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(
                                  fontSize: 0,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.05,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 0.05,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                hintText: S.current.writeSomething,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isMultimedia = !isMultimedia;
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          theme.scaffoldBackgroundColor,
                                      radius: 24,
                                      child: Icon(
                                        isMultimedia
                                            ? Icons.close
                                            : Icons.attach_file_outlined,
                                        size: 30,
                                        color: isMultimedia
                                            ? theme.colorScheme.error
                                            : theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: message.text.isEmpty && !record.isRecording
                          ? InkWell(
                              onTap: () {
                                if (record.isRecording) {
                                  sendMessage();
                                } else {
                                  startRecording();
                                }
                              },
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: theme.scaffoldBackgroundColor,
                                child: Builder(
                                  builder: (context) {
                                    if (record.isRecording) {
                                      return Builder(
                                        builder: (context) {
                                          if (sending) {
                                            return const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            return Icon(
                                              Icons.send,
                                              color: theme.primaryColor,
                                            );
                                          }
                                        },
                                      );
                                    } else {
                                      return Builder(
                                        builder: (context) {
                                          if (sending) {
                                            return const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            return Icon(
                                              Icons.mic,
                                              color: theme.primaryColor,
                                            );
                                          }
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: sendMessage,
                              child: CircleAvatar(
                                backgroundColor: theme.scaffoldBackgroundColor,
                                child: Builder(
                                  builder: (context) {
                                    if (sending) {
                                      return const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Icon(
                                        Icons.send,
                                        color: theme.primaryColor,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isMultimedia,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  onPressed: aquireLocation,
                                  icon: const Icon(Icons.location_on_outlined),
                                  label: Text(S.current.sendLocation),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  onPressed: pickImage,
                                  icon: const Icon(Icons.image_outlined),
                                  label: Text(S.current.imageGallery),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  onPressed: captureImage,
                                  icon: const Icon(Icons.camera_alt_outlined),
                                  label: Text(S.current.captureImage),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  onPressed: captureVideo,
                                  icon: const Icon(Icons.camera),
                                  label: Text(S.current.captureVideo),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}