import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/models/config.dart';
import 'package:mycar/services/api_service.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/app_text_styles.dart';
import '../../core/widgets/custom_text.dart';
import '../../core/widgets/small_header.dart';
import '../../generated/l10n.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    text: S.current.privacyPolicy,
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
                      "configKey": "privacyPolicy",
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
            )
          ],
        ),
      ),
    );
  }
}
