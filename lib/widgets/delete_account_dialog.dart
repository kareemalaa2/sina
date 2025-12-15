import 'package:flutter/material.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/services/api_service.dart';
import 'package:provider/provider.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool loading = false;
  late AuthProvider auth;
  @override
  void initState() {
    super.initState();
  }

  verify() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
      final res = await ApiService.post("/users/delete-account", {},token: auth.token,);
      if (res.success && mounted) {
      Navigator.pop(context, true);
      } else {
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Icon(
              Icons.delete,
              color: theme.colorScheme.error,
              size: 40,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.deleteAccountMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        theme.colorScheme.error,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.current.no,
                      style: TextStyle(
                        color: theme.scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(
                        Colors.green,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: verify,
                    child: Builder(
                      builder: (context) {
                        if (loading) {
                          return const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: CircularProgressIndicator(),
                          );
                        } else {
                        return Text(
                          S.current.verify,
                          style: TextStyle(
                            color: theme.scaffoldBackgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                        }
                      }
                    ),
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
