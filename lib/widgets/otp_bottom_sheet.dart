import 'package:flutter/material.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/utils/timer.dart';
import 'package:provider/provider.dart';

class OtpBottomSheet extends StatefulWidget {
  final String path;
  final String verificationKey;
  final Map<String, dynamic> data;
  const OtpBottomSheet({
    super.key,
    required this.data,
    required this.path,
    required this.verificationKey,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  late AuthProvider auth;
  TextEditingController otp = TextEditingController();
  FocusNode otpFocus = FocusNode();
  bool loading = false;
  bool isError = false;
  ListenableTimer timer = ListenableTimer(
    minutes: 2,
    seconds: 0,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      timer.startTimer();
    });
    super.initState();
  }

  verify() async {
    if (otp.text.length == 4 && !loading) {
      setState(() {
        loading = true;
      });
      final resp = await ApiService.post(
        widget.path,
        widget.data,
        queryParams: {
          "key": widget.verificationKey,
          "otp": otp.text,
        },
        token: auth.token,
      );
      if (resp.success && mounted) {
        Navigator.pop(
          context,
          widget.path == "/users//forgot-password" ? otp.text : resp.token,
        );
      } else {
        setState(() {
          otp.text = "";
          isError = true;
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(35.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/message.png",
                  width: 180,
                ),
              ),
              Positioned(
                bottom: -35,
                left: -25,
                child: Image.asset(
                  "assets/phone.png",
                  width: 100,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            S.current.enterOtp,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Visibility(
          visible: false,
          maintainState: true,
          child: TextFormField(
            controller: otp,
            focusNode: otpFocus,
            autofocus: true,
            onChanged: (value) {
              setState(() {
                if (value.length == 4) {
                  verify();
                }
              });
            },
            keyboardType: TextInputType.number,
            maxLength: 4,
            readOnly: loading,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 10,
          ),
          child: InkWell(
            onTap: () {
              otpFocus.requestFocus();
            },
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: otp.text.isNotEmpty ? otp.text[0] : "",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3,
                            color: otp.text.isNotEmpty
                                ? theme.primaryColor
                                : isError
                                    ? theme.colorScheme.error
                                    : Colors.grey,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: otp.text.length > 1 ? otp.text[1] : "",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3,
                            color: otp.text.length >= 2
                                ? theme.primaryColor
                                : isError
                                    ? theme.colorScheme.error
                                    : Colors.grey,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: otp.text.length > 2 ? otp.text[2] : "",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 3,
                            color: otp.text.length >= 3
                                ? theme.primaryColor
                                : isError
                                    ? theme.colorScheme.error
                                    : Colors.grey,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: otp.text.length > 3 ? otp.text[3] : "",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                S.current.didNotReceiveCode,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ValueListenableBuilder(
                  valueListenable: timer.time,
                  builder: (context, time, w) {
                    if (timer.isFinished) {
                      return TextButton(
                        onPressed: () {
                          setState(() {
                            timer.restart(
                              multiplied: true,
                            );
                          });
                        },
                        child: Text(
                          S.current.reSendCode,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return Text.rich(
                        TextSpan(
                          text:
                              "0${time.minute}:${time.second.toString().length == 1 ? '0' : ''}${time.second}",
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        theme.primaryColor,
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: theme.scaffoldBackgroundColor,
                            ),
                          );
                        } else {
                          return Text(
                            S.current.verify,
                            style: TextStyle(
                              color: theme.scaffoldBackgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
