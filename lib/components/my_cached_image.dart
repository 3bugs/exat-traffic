import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:exattraffic/etc/utils.dart';

enum ProgressIndicatorSize { small, large }

class MyCachedImage extends StatelessWidget {
  final String imageUrl;
  final ProgressIndicatorSize progressIndicatorSize;
  final Color errorIconColor;
  final BoxFit boxFit;

  MyCachedImage({
    @required this.imageUrl,
    @required this.progressIndicatorSize,
    this.errorIconColor = Colors.redAccent,
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final double boxSize = this.progressIndicatorSize == ProgressIndicatorSize.small ? 20.0 : 40.0;
    final double progressStrokeWidth =
        this.progressIndicatorSize == ProgressIndicatorSize.small ? 3.0 : 5.0;
    final double errorIconSize =
        this.progressIndicatorSize == ProgressIndicatorSize.small ? 30.0 : 45.0;

    return CachedNetworkImage(
      imageUrl: this.imageUrl,
      fit: this.boxFit,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: getPlatformSize(boxSize),
          height: getPlatformSize(boxSize),
          child: CircularProgressIndicator(
            strokeWidth: getPlatformSize(progressStrokeWidth),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: this.errorIconColor,
        size: getPlatformSize(errorIconSize),
      ),
    );
  }
}
