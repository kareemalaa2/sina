// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:mycar/models/config.dart';
import 'package:mycar/services/api_service.dart';
import 'package:mycar/services/payment_service.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/styles/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/elevated_button_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late AuthProvider auth;
  bool isLightTheme = false;
  WebViewController? webViewController;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  bool isLoading = false;
  bool done = false;
  bool failed = false;
  bool isLoadingKey = true;
  String? moyasarPK;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withValues(alpha: 0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ApiService.get(
        "/configs",
        queryParams: {"configKey": "moyasarPK"},
      ).then((res) {
        if (res.success) {
          List<Config> configs = List.generate(
            res.data.length,
            (i) => Config.fromMap(
              res.data[i],
            ),
          );
          if (configs.isNotEmpty && mounted) {
            setState(() {
              moyasarPK = configs.firstOrNull?.descAr;
              isLoadingKey = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoadingKey = false;
            });
          }
        }
      });
    });
    super.initState();
  }

  generatePaymentLink(double amount) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final resp = await PaymentService.generatePaymentLink(
      userId: auth.user!.id,
      countryId: auth.user!.country.id,
      currency: auth.user!.country.currency,
      moyasarPK: moyasarPK!,
      cardHolderName: cardHolderName,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvvCode: cvvCode,
      amount: amount,
    );
    if (resp.success && mounted) {
      setState(() {
        webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains("status=paid") ||
                    request.url.contains("status=authorized") ||
                    request.url.contains("status=failed")) {
                      if (request.url.contains("status=failed")) {
                            setState(() {
                              failed = true;
                            });
                          } else {
                            setState(() {
                              done = true;
                            });
                          }
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  });
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(resp.data));
        isLoading = false;
      });
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    if (auth.user!.validUntil.isAfter(DateTime.now())) {
      Future.delayed(const Duration(seconds: 3)).then((v) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: BackButton(
          color: theme.scaffoldBackgroundColor,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        title: Text(
          S.current.renew,
          style: TextStyle(
            color: theme.scaffoldBackgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          if (isLoadingKey) {
            return Center(
              child: SizedBox(
                width: 55,
                height: 55,
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              ),
            );
          } else {
            if (webViewController is WebViewController) {
              if (failed) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.current.paymentFailed,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (done) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.current.subscriptionRenewed,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
                return Column(
                  children: [
                    Expanded(
                      child: WebViewWidget(
                        controller: webViewController!,
                      ),
                    ),
                  ],
                );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: S.current.subscriptionFees(
                              (auth.user?.country.currencyAmount ?? 0) *
                                  (auth.user?.serviceStyle?.subscriptionFee ??
                                      0)),
                          children: [
                            const TextSpan(
                              text: "  ",
                            ),
                            TextSpan(
                              text: auth.user?.country.currency,
                              style: TextStyle(
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                        ),
                        child: CreditCardWidget(
                          enableFloatingCard: useFloatingAnimation,
                          // glassmorphismConfig: _getGlassmorphismConfig(),
                          cardNumber: cardNumber,
                          expiryDate: expiryDate,
                          cardHolderName: cardHolderName,
                          cvvCode: cvvCode,
                          bankName: " ",
                          frontCardBorder: useGlassMorphism
                              ? null
                              : Border.all(
                                  color: Colors.grey,
                                ),
                          backCardBorder: useGlassMorphism
                              ? null
                              : Border.all(
                                  color: Colors.grey,
                                ),
                          showBackView: isCvvFocused,
                          obscureCardNumber: false,
                          obscureCardCvv: true,
                          isHolderNameVisible: true,
                          cardBgColor: AppColors.primary,
                          backgroundImage: 'assets/card_bg.png',
                          isSwipeGestureEnabled: true,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          onCreditCardWidgetChange:
                              (CreditCardBrand creditCardBrand) {},
                          customCardTypeIcons: <CustomCardTypeIcon>[
                            CustomCardTypeIcon(
                              cardType: CardType.mastercard,
                              cardImage: Image.asset(
                                'assets/mastercard.png',
                                height: 48,
                                width: 48,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: false,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          cardHolderValidator: (p0) {
                            if (p0 is String && p0.isNotEmpty) {
                              return null;
                            } else {
                              return S.current.fieldRequired;
                            }
                          },
                          cvvValidator: (p0) {
                            if (p0 is String && p0.isNotEmpty) {
                              return null;
                            } else {
                              return S.current.fieldRequired;
                            }
                          },
                          cardNumberValidator: (p0) {
                            if (p0 is String && p0.isNotEmpty) {
                              return null;
                            } else {
                              return S.current.fieldRequired;
                            }
                          },
                          expiryDateValidator: (p0) {
                            if (p0 is String && p0.isNotEmpty) {
                              return null;
                            } else {
                              return S.current.fieldRequired;
                            }
                          },
                          inputConfiguration: InputConfiguration(
                            cardNumberDecoration: InputDecoration(
                              labelText: S.current.cardNumber,
                              hintText: 'XXXX XXXX XXXX XXXX',
                              border: const OutlineInputBorder(),
                            ),
                            expiryDateDecoration: InputDecoration(
                              labelText: S.current.expiredDate,
                              hintText: 'MM/YY',
                              border: const OutlineInputBorder(),
                            ),
                            cvvCodeDecoration: const InputDecoration(
                              labelText: 'CVV',
                              hintText: 'XXX',
                              border: OutlineInputBorder(),
                            ),
                            cardHolderDecoration: InputDecoration(
                              labelText: S.current.cardHolder,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          onCreditCardModelChange: (p0) {
                            setState(() {
                              cardHolderName = p0.cardHolderName;
                              cardNumber = p0.cardNumber;
                              expiryDate = p0.expiryDate;
                              cvvCode = p0.cvvCode;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: ElevatedButtonWidget(
                          radius: 15,
                          icon: Icons.credit_card,
                          title: S.current.renew,
                          textColor: theme.scaffoldBackgroundColor,
                          color: theme.primaryColor,
                          isLoading: isLoading,
                          onPressed: () {
                            if (!isLoading) {
                              generatePaymentLink(
                                  (auth.user?.country.currencyAmount ?? 0) *
                                      (auth.user?.serviceStyle
                                              ?.subscriptionFee ??
                                          0));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
