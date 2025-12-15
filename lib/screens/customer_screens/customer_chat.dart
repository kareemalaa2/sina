import 'package:flutter/material.dart';
import 'package:mycar/generated/l10n.dart';
import '../shared/chat_widgets/chat_list.dart';

class CustomerChat extends StatefulWidget {
    final int initialIndex; // 👈 add this

  const CustomerChat({super.key , this.initialIndex = 0}); // 👈 modify constructor

  @override
  State<CustomerChat> createState() => _CustomerChatState();
}

class _CustomerChatState extends State<CustomerChat>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(
      length: 2,
      vsync: this,
            initialIndex: widget.initialIndex, // 👈 use it here

    );
    tabController.addListener(listener);
    super.initState();
  }

  listener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    tabController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                // isScrollable: true,
                // tabAlignment: TabAlignment.start,
                labelColor: theme.primaryColor,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
                indicatorPadding: const EdgeInsets.all(0),
                labelPadding: const EdgeInsets.all(0),
                tabAlignment: TabAlignment.center,
                tabs: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 22,
                    ),
                    decoration: BoxDecoration(
                      color: tabController.index == 0
                          ? theme.primaryColor.withValues(
                              alpha: 0.87,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      S.current.pendingOrders,
                      style: TextStyle(
                        color: tabController.index == 0
                            ? theme.scaffoldBackgroundColor
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 22,
                      ),
                      decoration: BoxDecoration(
                        color: tabController.index == 1
                            ? theme.primaryColor.withValues(alpha: 0.87)
                            : null,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        S.current.active,
                        style: TextStyle(
                          color: tabController.index == 1
                              ? theme.scaffoldBackgroundColor
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                ChatList(
                  status: 'pending',
                ),
                ChatList(
                  status: 'active',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
