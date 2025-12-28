import 'package:cached_network_image/cached_network_image.dart';
import 'package:fe/config/app_color.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? url;
  final double width;
  final double height;
  final double radius;
  final String placeholderAsset;

  const CustomImage({
    super.key,
    this.url,
    this.width = 50,
    this.height = 50,
    this.radius = 0,
    this.placeholderAsset = 'assets/logo/logo_dark.svg', // Fallback fixed
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _buildPlaceholder();
    }

    if (url!.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          imageUrl: url!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildLoading(),
          errorWidget: (context, url, error) => _buildPlaceholder(),
        ),
      );
    }

    // Local asset
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.neutral_100,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(Icons.person, color: AppColors.neutral_400, size: width * 0.5),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.neutral_100,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: SizedBox(
          width: width * 0.4,
          height: height * 0.4,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
