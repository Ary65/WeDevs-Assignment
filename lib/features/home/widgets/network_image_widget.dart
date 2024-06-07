import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl;
  final int placeholderIndex;

  const NetworkImageWidget(
      {super.key, this.imageUrl, required this.placeholderIndex});

  @override
  Widget build(BuildContext context) {
    final placeholderImages = [
      'https://via.placeholder.com/150/0000FF/808080?Text=Placeholder1',
      'https://via.placeholder.com/150/FF0000/FFFFFF?Text=Placeholder2',
      'https://via.placeholder.com/150/FFFF00/000000?Text=Placeholder3',
      'https://via.placeholder.com/150/00FF00/000000?Text=Placeholder4',
      'https://via.placeholder.com/150/000000/FFFFFF?Text=Placeholder5',
      'https://via.placeholder.com/150/FF00FF/000000?Text=Placeholder6',
      'https://via.placeholder.com/150/00FFFF/000000?Text=Placeholder7',
      'https://via.placeholder.com/150/FFA500/000000?Text=Placeholder8',
    ];

    final placeholderImageUrl =
        placeholderImages[placeholderIndex % placeholderImages.length];

    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) {
        debugPrint('Image loading error: $error');
        return CachedNetworkImage(
          imageUrl: placeholderImageUrl,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
