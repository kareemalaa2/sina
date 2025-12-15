import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/core/extensions/strings_extensions.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../models/support_ticket.dart';

class SupportTicketWidget extends StatelessWidget {
  const SupportTicketWidget({super.key, required this.ticket});
  final SupportTicket ticket;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              ticket.title,
              style: AppTextStyles.medium14,
            ),
            subtitle: CustomText(
              text: ticket.desc,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.zero,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 5,
            ),
            child: Divider(
              indent: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ticket.status.capitalize,
                  style: AppTextStyles.bold16
                      .copyWith(color: const Color(0xff56ab8e), fontSize: 12),
                ),
                Text(DateFormat('yyyy-MM-dd kk:mm').format(ticket.createdAt)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
