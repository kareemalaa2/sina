import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mycar/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Ad.dart';

class AdCard extends StatelessWidget {
  const AdCard({
    super.key,
    required this.ad,
  });
  final Ad ad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.85,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            ad.image,
          ),
          opacity: 0.75,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.scaffoldBackgroundColor,
            ),
            child: Text(
              S.current.sponsored,
              style: TextStyle(
                fontSize: 16.0,
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  ad.desc,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: theme.scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(theme.primaryColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.only(
                        left: 10,
                        right: 10,
                        // top: 5,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await launchUrl(Uri.parse(ad.link ?? ad.whatsapp ??""),mode: LaunchMode.externalApplication,);
                  },
                  child: Text(
                    S.current.requestOffer,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.scaffoldBackgroundColor,
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
