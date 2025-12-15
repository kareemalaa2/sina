import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/core/styles/app_text_styles.dart';
import 'package:provider/provider.dart';
import '../../../../../generated/l10n.dart';
import '../providers/auth_provider.dart';

class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({
    super.key,
    required this.controller,
    required this.country,
    this.readOnly = false,
  });
  final TextEditingController controller;
  final TextEditingController country;
  final bool readOnly;

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (widget.country.text.isEmpty) {
      widget.country.text =
          auth.currentCountry?.id ?? auth.countries.firstOrNull?.id ?? "";
    }
    return Column(
      children: [
        Row(
          children: [
            Text(
              S.current.phoneNo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: widget.controller,
                          readOnly: widget.readOnly,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: const EdgeInsets.only(
                              top: 12,
                            ),
                            border: InputBorder.none,
                            hintText: "XXXXXXXXX",
                            hintStyle: AppTextStyles.regular12,
                            prefixIcon: ExcludeFocus(
                              child: DropdownButton<String>(
                                value: widget.country.text,
                                underline: const Text(""),
                                icon: const Text(" "),
                                items: auth.countries
                                    .map(
                                      (country) => DropdownMenuItem<String>(
                                        value: country.id,
                                        child: Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: country.flag,
                                              width: 25,
                                              height: 25,
                                            ),
                                            const Gap(5),
                                            Text(
                                              country.phoneCode.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (selectedCountry) {
                                  setState(() {
                                    widget.country.text = selectedCountry ?? "";
                                  });
                                },
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.length < 8) {
                              return S.current.phoneRequired;
                            }
                            if (widget.country.text.isEmpty) {
                              return S.current.countryRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
