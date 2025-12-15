import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/models/country.dart';
import 'package:mycar/models/order.dart';
import 'package:mycar/models/service_style.dart.dart';
import 'package:mycar/screens/provider_screens/widgets/provider_order_card.dart';

import '../../../models/user.dart';

class ProviderOrderLoadingList extends StatelessWidget {
  const ProviderOrderLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ProviderOrderCard(
            order: Order(
              createdAt: DateTime.now(),
              id: 'id',
              user: User(
                id: 'id',
                validUntil: DateTime.now(),
                name: 'name',
                phone: 'phone',
                country: Country(
                  id: "",
                  currency: "",
                  nameAr: "nameAr",
                  nameEn: "nameEn",
                  flag: "flag",
                  phoneCode: 966,
                ),
                serviceType: [],
              ),
              serviceStyle: ServiceStyle(
                id: 'id',
                nameAr: '',
                nameEn: '',
                subscriptionFee: 1,
                key: '',
                icon: '',
              ),
              userId: '',
              serviceProviderId: '',
              serviceStyleId: '',
              status: '',
              serviceType: '',
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Gap(10);
        },
        itemCount: 10,
        shrinkWrap: true,
      );
  }
}
