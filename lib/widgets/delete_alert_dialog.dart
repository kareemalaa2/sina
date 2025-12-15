import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';

class DeleteAlertDialog extends StatefulWidget {
  final String title;
  const DeleteAlertDialog({
    super.key,
    required this.title,
  });

  @override
  State<DeleteAlertDialog> createState() => _DeleteAlertDialogState();
}

class _DeleteAlertDialogState extends State<DeleteAlertDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Row(
        children: [
          Icon(
            Icons.delete,
            color: theme.colorScheme.error,
          ),
          Expanded(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          S.current.doYouWantToDelete,
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
                title: S.current.verify,
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
