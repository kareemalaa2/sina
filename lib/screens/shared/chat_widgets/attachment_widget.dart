// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:mycar/core/extensions/build_context_extensions.dart';
import 'package:mycar/providers/app_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as p;
import 'package:voice_message_package/voice_message_package.dart';

extension StringExt on String {
  bool get isImage => [
        "jpg",
        "jpeg",
        "webp",
        "png",
        "tiff",
        "psd",
        "pdf",
        "eps",
        "ai",
        "indd",
        "raw"
      ].contains(toLowerCase());

  bool get isVideo => ["mp4","mov"].contains(toLowerCase());

  bool get isAudio => ["m4a"].contains(toLowerCase());

  bool get isLocal => !contains("https");
}

class AttachmentWidget extends StatelessWidget {
  final String attachment;
  final String attachmentType;
  final bool isMine;
  const AttachmentWidget({
    super.key,
    required this.attachment,
    required this.attachmentType,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: context.width * 0.50,
      ),
      child: Builder(
        builder: (context) {
          if (attachmentType.isVideo) {
            return VideoAttachment(
              attachment: attachment,
            );
          } else {
            if (attachmentType.isAudio) {
              return SizedBox(
                height: 85,
                child: VoiceMessageView(
                  controller: VoiceController(
                    audioSrc: attachment,
                    maxDuration: const Duration(seconds: 10),
                    isFile: false,
                    onComplete: () {
                      /// do something on complete
                    },
                    onPause: () {
                      /// do something on pause
                    },
                    onPlaying: () {
                      /// do something on playing
                    },
                    onError: (err) {
                      /// do somethin on error
                    },
                  ),
                  innerPadding: 12,
                  cornerRadius: 20,
                ),
              );
            } else {
              return ImageAttachment(
                attachment: attachment,
              );
            }
          }
        },
      ),
    );
  }
}

class ImageAttachment extends StatefulWidget {
  final String attachment;
  const ImageAttachment({super.key, required this.attachment});

  @override
  State<ImageAttachment> createState() => _ImageAttachmentState();
}

class _ImageAttachmentState extends State<ImageAttachment> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: () {
        showImageViewer(
          context,
          widget.attachment.contains("https")
              ? CachedNetworkImageProvider(widget.attachment)
              : Image.file(File(widget.attachment)).image,
          backgroundColor: theme.primaryColor,
          useSafeArea: true,
          doubleTapZoomable: true,
          swipeDismissible: true,
          immersive: false,
          barrierColor: Colors.transparent,
          onViewerDismissed: () {},
        );
      },
      child: SizedBox(
        width: size.width * 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Builder(
            builder: (context) {
              if (widget.attachment.contains("https")) {
                return CachedNetworkImage(
                  imageUrl: widget.attachment,
                  width: size.width,
                  fit: BoxFit.cover,
                );
              } else {
                return Image.file(
                  File(widget.attachment),
                  width: size.width,
                  fit: BoxFit.cover,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class VideoAttachment extends StatefulWidget {
  final String attachment;
  const VideoAttachment({super.key, required this.attachment});

  @override
  State<VideoAttachment> createState() => _VideoAttachmentState();
}

class _VideoAttachmentState extends State<VideoAttachment> {
  late AppProvider app;
  var dl = DownloadManager();
  DownloadTask? dw;

  download() async {
    if (dw is! DownloadTask) {
      dw = await dl.addDownload(widget.attachment, app.downloadDir.path);
      dw!.whenDownloadComplete().then((value) async {
        OpenFilex.open(dw!.request.path);
      });
      setState(() {});
    }
  }

  open(String path) async {
    OpenFilex.open(path);
  }

  @override
  Widget build(BuildContext context) {
    app = Provider.of<AppProvider>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size.width * 0.5,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.primaryColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            FutureBuilder(
              future: File(widget.attachment.contains("https")
                      ? p.join(app.downloadDir.path,
                          widget.attachment.split("/").last)
                      : widget.attachment)
                  .exists(),
              builder: (context, snap) {
                if (snap.hasData) {
                  switch (widget.attachment.contains("https")) {
                    case true:
                      return InkWell(
                        onTap: () => snap.data == true
                            ? open(p.join(app.downloadDir.path,
                                widget.attachment.split("/").last))
                            : download(),
                        child: FutureBuilder(
                          future: VideoThumbnail.thumbnailFile(
                            video: p.join(app.downloadDir.path,
                                widget.attachment.split("/").last),
                            thumbnailPath: app.temp.path,
                            imageFormat: ImageFormat.JPEG,
                            maxHeight: 100,
                            quality: 75,
                          ),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: size.width * 0.5,
                                  // height: size.width / 2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: Image.file(
                                        File(
                                          snap.data!,
                                        ),
                                      ).image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: theme.primaryColor,
                                      child: Icon(
                                        Icons.play_arrow_outlined,
                                        color: theme.scaffoldBackgroundColor,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                width: size.width * 0.5,
                                child: Center(
                                  child: SizedBox(
                                    width: 75,
                                    height: 75,
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Icon(
                                          Icons.video_collection_rounded,
                                          color: theme.primaryColor,
                                          size: 45,
                                        ),
                                        Positioned(
                                          child: SizedBox(
                                            width: 75,
                                            height: 75,
                                            child: CircularProgressIndicator(
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    default:
                      return InkWell(
                        onTap: () => open(widget.attachment),
                        child: FutureBuilder(
                          future: VideoThumbnail.thumbnailFile(
                            video: widget.attachment,
                            thumbnailPath: app.temp.path,
                            imageFormat: ImageFormat.JPEG,
                            maxHeight: 100,
                            quality: 75,
                          ),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: size.width * 0.5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: Image.file(
                                        File(
                                          snap.data!,
                                        ),
                                      ).image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: theme.primaryColor,
                                      child: Icon(
                                        Icons.play_arrow_outlined,
                                        color: theme.scaffoldBackgroundColor,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                width: size.width * 0.5,
                                child: Center(
                                  child: SizedBox(
                                    width: 75,
                                    height: 75,
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Icon(
                                          Icons.video_collection_rounded,
                                          color: theme.primaryColor,
                                          size: 45,
                                        ),
                                        Positioned(
                                          child: SizedBox(
                                            width: 75,
                                            height: 75,
                                            child: CircularProgressIndicator(
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                  }
                } else {
                  return LinearProgressIndicator(
                    color: theme.primaryColor,
                  );
                }
              },
            ),
            Positioned(
              bottom: 3,
              right: 3,
              child: dw is DownloadTask
                  ? ValueListenableBuilder(
                      valueListenable: dw!.progress,
                      builder: (context, val, e) {
                        return Visibility(
                          visible: val > 0 && val < 1,
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                CircularProgressIndicator(
                                  color: theme.scaffoldBackgroundColor,
                                  value: val,
                                ),
                                Positioned(
                                  child: Text(
                                    (val * 100).toStringAsFixed(0),
                                    style: TextStyle(
                                      color: theme.scaffoldBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Text(""),
            ),
          ],
        ),
      ),
    );
  }
}
