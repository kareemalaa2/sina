import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/order.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';

class CancelOrderAlertDialog extends StatefulWidget {
  final Order order;
  const CancelOrderAlertDialog({
    super.key,
    required this.order,
  });

  @override
  State<CancelOrderAlertDialog> createState() => _CancelOrderAlertDialogState();
}

class _CancelOrderAlertDialogState extends State<CancelOrderAlertDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text.rich(
        TextSpan(
          text: widget.order.serviceStyle?.name,
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          S.current.doYouWantToCancelOrder,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: theme.colorScheme.error,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButtonWidget(
                height: 35,
                color: theme.colorScheme.error,
                textColor: theme.scaffoldBackgroundColor,
                title: S.current.no,
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
            const Gap(10),
            Expanded(
              child: ElevatedButtonWidget(
                height: 35,
                color: Colors.green,
                textColor: theme.scaffoldBackgroundColor,
                title: S.current.yes,
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
