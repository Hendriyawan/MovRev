// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movrev/core/config/app_config.dart';
import 'package:movrev/domain/entities/cast.dart';

class CastCard extends StatelessWidget {
  final Cast cast;
  const CastCard({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          // Avatar Image
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: cast.profilePath != null
                  ? CachedNetworkImage(
                      imageUrl:
                          "${AppConfig.baseImageUrl200}${cast.profilePath}",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.white10,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.white10,
                        child: const Icon(Icons.person, color: Colors.white54),
                      ),
                    )
                  : Container(
                      color: Colors.white10,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          // Actor Name
          Text(
            cast.name ?? '',
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          // Character Name
          Text(
            cast.character ?? '',
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}