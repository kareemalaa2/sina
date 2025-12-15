  import 'package:flutter/material.dart';
  import 'package:mycar/generated/l10n.dart';
  import 'package:mycar/models/chat.dart';
  import 'package:mycar/models/service_style.dart.dart';
  import 'package:mycar/providers/auth_provider.dart';
  import 'package:mycar/services/api_service.dart';
  import 'package:mycar/widgets/elevated_button_widget.dart';
  import 'package:provider/provider.dart';

  import '../../../models/response_model.dart';

  class AcceptOffer extends StatefulWidget {
    final Chat chat;
    const AcceptOffer({
      super.key,
      required this.chat,
    });

    @override
    State<AcceptOffer> createState() => _AcceptOfferState();
  }

  class _AcceptOfferState extends State<AcceptOffer> {
    late AuthProvider auth;
    bool accepting = false;

    @override
    void initState() {
      super.initState();
    }

    acceptOffer() async {
      if (!accepting) {
        setState(() {
          accepting = true;
        });
        late ResponseModel resp;
        if (auth.user?.serviceStyle is ServiceStyle) {
          resp = await ApiService.put(
            "/orders/offers",
            {
              "id": widget.chat.id,
            },
            token: auth.token,
          );
        } else {
      

    resp = await ApiService.post(
            "/orders/offers",
            {
              "id": widget.chat.id,
            },
            token: auth.token,
          );
        }
        if (resp.success && mounted) {
          Navigator.pop(context, true);
        } else {
          if (mounted) {
            setState(() {
              accepting = false;
            });
          }
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      auth = Provider.of<AuthProvider>(context);
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Text(
            //           auth.user?.serviceStyle is ServiceStyle
            //               ? S.current.changeOrderStatus
            //               : S.current.jobCompleted,
            //           textAlign: TextAlign.center,
            //           style: const TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      auth.user?.serviceStyle is ServiceStyle
                          ? S.current.changeOrderStatus
                          : S.current.jobCompleted,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
              Expanded(
  child: ElevatedButtonWidget(
    color: Colors.red,
    height: 38,
    textColor: Colors.white,
    title: S.current.close,
    onPressed: () => Navigator.pop(context),
  ),
),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButtonWidget(
                      color: Colors.green,
                      height: 38,
                      onPressed: acceptOffer,
                      isLoading: accepting,
                      textColor: Colors.white,
                      title: auth.user?.serviceStyle is ServiceStyle
                          ? S.current.accept
                          : S.current.completed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
