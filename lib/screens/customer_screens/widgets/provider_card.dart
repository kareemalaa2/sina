import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mycar/models/user.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../../providers/app_provider.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../provider_screen.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    super.key,
    required this.user,
    this.requestService,
    this.toggleFav,
  });
  final User user;
  final Function()? requestService;
  final Function()? toggleFav;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Card(
      shadowColor: theme.primaryColor,
      color: theme.scaffoldBackgroundColor,
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(app.context, MaterialPageRoute(
            builder: (context) {
              return ProviderScreen(
                user: user,
              );
            },
          ));
        },
        child: SizedBox(
          width: size.width / 2.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    Hero(
                      tag: user.id + user.validUntil.toIso8601String(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: user.avatar is String
                            ? CachedNetworkImage(
                                imageUrl: user.avatar!,
                                width: size.width / 2.8,
                                height: size.width / 3,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: theme.primaryColor,
                                width: size.width / 2.8,
                                height: size.width / 3,
                                child: Center(
                                  child: Text.rich(
                                    TextSpan(
                                      text: user.name.characters.first
                                          .toUpperCase(),
                                    ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      color: theme.scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: user.dist,
                                  children: [
                                    const TextSpan(text: " "),
                                    TextSpan(text: S.current.km),
                                  ],
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 2.0,
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    text: user.rating,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: toggleFav,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: theme.scaffoldBackgroundColor,
                            child: Icon(
                              user.isFav
                                  ? Icons.favorite
                                  : Icons.favorite_outline_outlined,
                              color: user.isFav ? Colors.red : null,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: user.serviceStyle?.name,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                  vertical: 2.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButtonWidget(
                        color: theme.primaryColor,
                        textColor: theme.scaffoldBackgroundColor,
                        height: 35,
                        radius: 8,
                        fontSize: 11,
                        onPressed: requestService,
                        title: S.current.requestService,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
