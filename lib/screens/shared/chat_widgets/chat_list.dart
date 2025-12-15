import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/models/chat_message.dart';
import 'package:mycar/models/order.dart';
import 'package:mycar/models/user.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/screens/shared/chat_widgets/chat_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../generated/l10n.dart';
import '../../../models/chat.dart';
import '../../../models/service_style.dart.dart';
import '../../../services/api_service.dart';
import '../../../widgets/loader.dart';

class ChatList extends StatefulWidget {
  final String status;
  const ChatList({
    super.key,
    required this.status,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with SingleTickerProviderStateMixin {
  late AuthProvider auth;
  ScrollController scrollController = ScrollController();
  List<Chat> chats = [];
  int total = 0;
  int page = 0;
  bool loading = false;
  bool loadingMessages = false; // 🔥 حالة تحميل الرسائل
  
  Map<String, DateTime> lastInteractionTimes = {};
  Set<String> registeredListeners = {};
  
  // 🔥 للـ shimmer animation
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  Timer? _shimmerTimer; // 🔥 مؤقت الـ 7 ثواني

  @override
  void initState() {
    // 🔥 إعداد الـ shimmer animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((v) async {
      auth = Provider.of<AuthProvider>(context, listen: false);
      await loadInteractionTimes();
      loadData();
      scrollController.addListener(listener);
    });
    super.initState();
  }

  listener() {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (chats.length < total) {
          loadData(more: true);
        }
      }
    }
  }

  Future<void> loadInteractionTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedData = prefs.getString('chat_interaction_times_${auth.user?.id}');
      if (savedData != null) {
        final Map<String, dynamic> decoded = json.decode(savedData);
        lastInteractionTimes = decoded.map(
          (key, value) => MapEntry(key, DateTime.parse(value as String)),
        );
      }
    } catch (e) {
      print('Error loading interaction times: $e');
    }
  }

  Future<void> saveInteractionTimes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, String> toSave = lastInteractionTimes.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      );
      await prefs.setString('chat_interaction_times_${auth.user?.id}', json.encode(toSave));
    } catch (e) {
      print('Error saving interaction times: $e');
    }
  }

  Future<void> loadLastMessage(Chat chat) async {
    try {
      final resp = await ApiService.get(
        "/chats/messages",
        queryParams: {
          "limit": 1,
          "skip": 0,
          "id": chat.id,
        },
        token: auth.token,
      );

      if (resp.success && resp.data.isNotEmpty && mounted) {
        setState(() {
          chat.unread = ChatMessage.fromMap(resp.data[0]);
        });
      }
    } catch (e) {
      print('❌ Error loading last message for chat ${chat.id}: $e');
    }
  }

  void registerSocketListeners(Chat chat) {
    final chatId = chat.id;
    
    if (registeredListeners.contains(chatId)) {
      return;
    }
    
    registeredListeners.add(chatId);

    auth.socket?.on(chat.userId(auth.user?.id ?? ""), (data) {
      if (mounted) {
        final chatIndex = chats.indexWhere((c) => c.id == chatId);
        if (chatIndex != -1) {
          setState(() {
            if (chats[chatIndex].userId(auth.user?.id ?? "") ==
                chats[chatIndex].client.id) {
              chats[chatIndex].client = User.fromMap(data);
            } else {
              chats[chatIndex].provider = User.fromMap(data);
            }
          });
        }
      }
    });

    auth.socket?.on("$chatId-typing", (data) {
      if (mounted) {
        final chatIndex = chats.indexWhere((c) => c.id == chatId);
        if (chatIndex != -1) {
          setState(() {
            if (auth.user?.id != data) {
              chats[chatIndex].isTyping = true;
              chats[chatIndex].typingTimer =
                  Timer(const Duration(seconds: 1), () {
                if (mounted) {
                  final idx = chats.indexWhere((c) => c.id == chatId);
                  if (idx != -1) {
                    setState(() {
                      chats[idx].isTyping = false;
                    });
                  }
                }
              });
            }
          });
        }
      }
    });

auth.socket?.on("$chatId-message", (data) {
  if (mounted) {
    final chatIndex = chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      setState(() {
        ChatMessage msg = ChatMessage.fromMap(data);
        
        chats[chatIndex].unread = msg;
        
        // ✅ Always update interaction time for ANY message
        lastInteractionTimes[chatId] = DateTime.now();
        saveInteractionTimes();
        
        if (auth.user?.id != msg.sender.id) {
          chats[chatIndex].unreadCount++;
        }
        chats.sort((a, b) {
          final aTime = lastInteractionTimes[a.id] ?? 
                        a.unread?.createdAt ?? 
                        a.createdAt;
          final bTime = lastInteractionTimes[b.id] ?? 
                        b.unread?.createdAt ?? 
                        b.createdAt;
          return bTime.compareTo(aTime);
        });
      });
    }
  }
});
    auth.socket?.on("${chat.order.id}-order", (data) {
      Order order = Order.fromMap(data);
      if (order.serviceProviderId != auth.user?.id &&
          auth.user?.serviceStyle is ServiceStyle &&
          mounted) {
        final chatIndex = chats.indexWhere((c) => c.id == chatId);
        if (chatIndex != -1) {
          setState(() {
            chats.removeAt(chatIndex);
          });
        }
      }
    });
  }
loadData({bool more = false}) async {
  // ✅ فقط أول تحميل أو Refresh يظهر الشيمر
  final bool showShimmer = !more;

  setState(() {
    if (more) {
      page++;
      loading = true; // pagination indicator فقط
    } else {
      page = 0;
      chats.clear();
      registeredListeners.clear();
      loading = true;
      if (showShimmer) {
        loadingMessages = true; // ✅ الشيمر يظهر فقط أول مرة أو refresh
        _shimmerTimer?.cancel();
        _shimmerTimer = Timer(const Duration(seconds: 7), () {
          if (mounted) {
            setState(() {
              loadingMessages = false;
            });
          }
        });
      }
    }
  });

  final resp = await ApiService.get(
    "/chats",
    queryParams: {
      "limit": 10,
      "skip": page * 10,
      "status": widget.status,
    },
    token: auth.token,
  );

  if (resp.success && mounted) {
    final newChats = List.generate(
      resp.data.length,
      (i) => Chat.fromMap(resp.data[i]),
    );

    setState(() {
      chats.addAll(newChats);
      total = resp.total;
    });

    for (var chat in newChats) {
      await loadLastMessage(chat);
      registerSocketListeners(chat);
    }

    if (mounted) {
      setState(() {
        chats.sort((a, b) {
          final aTime = lastInteractionTimes[a.id] ??
              a.unread?.createdAt ??
              a.createdAt;
          final bTime = lastInteractionTimes[b.id] ??
              b.unread?.createdAt ??
              b.createdAt;
          return bTime.compareTo(aTime);
        });
        loading = false;
        if (showShimmer) loadingMessages = false; // ✅ نوقف الشيمر بعد ما يخلص
      });
    }
  } else {
    if (mounted) {
      setState(() {
        loading = false;
        if (showShimmer) loadingMessages = false;
      });
    }
  }
}

  @override
  void dispose() {
    _shimmerController.dispose(); // 🔥 تنظيف الـ animation
    _shimmerTimer?.cancel(); // 🔥 إلغاء المؤقت
    scrollController.removeListener(listener);
    for (var chat in chats) {
      auth.socket?.off(chat.userId(auth.user?.id ?? ""));
      auth.socket?.off("${chat.id}-typing");
      auth.socket?.off("${chat.id}-message");
      auth.socket?.off("${chat.order.id}-order");
    }
    super.dispose();
  }

  // 🔥 بناء shimmer item
  Widget _buildShimmerItem() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              // Avatar shimmer
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                    begin: Alignment(_shimmerAnimation.value - 1, 0),
                    end: Alignment(_shimmerAnimation.value, 0),
                    colors: const [
                      Color(0xFFE0E0E0),
                      Color(0xFFF5F5F5),
                      Color(0xFFE0E0E0),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name shimmer
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          begin: Alignment(_shimmerAnimation.value - 1, 0),
                          end: Alignment(_shimmerAnimation.value, 0),
                          colors: const [
                            Color(0xFFE0E0E0),
                            Color(0xFFF5F5F5),
                            Color(0xFFE0E0E0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Message shimmer
                    Container(
                      height: 14,
                      width: double.infinity * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          begin: Alignment(_shimmerAnimation.value - 1, 0),
                          end: Alignment(_shimmerAnimation.value, 0),
                          colors: const [
                            Color(0xFFE0E0E0),
                            Color(0xFFF5F5F5),
                            Color(0xFFE0E0E0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Time shimmer
              Container(
                height: 12,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    begin: Alignment(_shimmerAnimation.value - 1, 0),
                    end: Alignment(_shimmerAnimation.value, 0),
                    colors: const [
                      Color(0xFFE0E0E0),
                      Color(0xFFF5F5F5),
                      Color(0xFFE0E0E0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await loadData();
      },
      child: Stack(
        children: [
          // 🔥 القائمة الأصلية (مخفية أثناء الـ shimmer)
          Opacity(
            opacity: loadingMessages ? 0 : 1,
            child: ListView.builder(
              controller: scrollController,
              itemCount: chats.length + 1,
              itemBuilder: (context, i) {
                if (i == chats.length) {
                  if (chats.isEmpty && !loading) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: context.height * 0.55,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline_outlined, size: 45),
                            const Gap(15),
                            Text(
                              S.current.noMessages,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Builder(
                      builder: (context) {
                        if (loading) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Gap(10),
                              Loader(),
                              Gap(10),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }
                } else {
                  return ChatCard(
                    chat: chats[i],
                    onTap: () async {
                      setState(() {
                        chats[i].unreadCount = 0;
                      });
                      
                      await context.push("/chat", extra: chats[i]);
                    },
                  );
                }
              },
            ),
          ),
          
          // 🔥 Shimmer overlay (يظهر فوق القائمة لمدة 7 ثواني)
          if (loadingMessages)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) => _buildShimmerItem(),
              ),
            ),
        ],
      ),
    );
  }
}