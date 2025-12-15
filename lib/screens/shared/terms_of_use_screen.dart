import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/models/user.dart';
import 'package:mycar/providers/auth_provider.dart';
import 'package:mycar/widgets/elevated_button_widget.dart';
import 'package:provider/provider.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/app_text_styles.dart';
import '../../core/widgets/custom_text.dart';
import '../../core/widgets/small_header.dart';
import '../../generated/l10n.dart';
import '../../models/config.dart';
import '../../services/api_service.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SmallHeader(
              color: AppColors.primary,
              child: Row(
                children: [
                  const BackButton(
                    color: AppColors.white,
                  ),
                  const Spacer(),
                  CustomText(
                    text: S.current.termsOfUse,
                    style: AppTextStyles.medium14.copyWith(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  const Gap(30),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: FutureBuilder(
                  future: ApiService.get(
                    "/configs",
                    queryParams: {
                      "configKey": "termsOfUse",
                    },
                  ),
                  builder: (context, snap) {
                    List<String> list = [];
                    if (snap.hasData) {
                      const splitter = LineSplitter();
                      Config? config = List.generate(snap.data?.data.length,
                              (j) => Config.fromMap(snap.data?.data[j]))
                          .firstOrNull;
                      list = splitter.convert(config?.desc ?? "");
                    }
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        RegExp regExp = RegExp(r"^\d.*");
                        bool isNum = regExp.hasMatch(list[i]);
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: S.current.locale == "en" && !isNum
                                        ? 17
                                        : 0,
                                    right: S.current.locale == "ar" && !isNum
                                        ? 17
                                        : 0,
                                  ),
                                  child: Text(
                                    list[i],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: auth.user is! User,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: Platform.isIOS ? 8.0 : 0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButtonWidget(
                        height: 48,
                        radius: 1,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        color: theme.primaryColor,
                        textColor: theme.scaffoldBackgroundColor,
                        title: S.current.accept,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
