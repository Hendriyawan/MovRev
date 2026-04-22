// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movrev/core/config/app_config.dart';
import 'package:movrev/core/routes/app_router.dart';
import 'package:movrev/domain/entities/genre.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/presentation/shared/widgets/rating_badge.dart';
import 'package:movrev/presentation/shared/widgets/poster_place_holder.dart';
import 'package:movrev/presentation/shared/widgets/poster_shimmer.dart';

class ItemNowPlayingFeatured extends StatelessWidget {
  final Movie movie;
  final List<Genre> genres;

  const ItemNowPlayingFeatured({
    super.key,
    required this.movie,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use backdropPath for wide featured card, fallback to posterPath
    final imagePath = movie.backdropPath ?? movie.posterPath;

    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Cover image
          Hero(
            tag: 'movie-poster-${movie.id}',
            child: imagePath != null
                ? CachedNetworkImage(
                    imageUrl: '${AppConfig.baseImageUrl500}$imagePath',
                    fit: BoxFit.cover,
                    memCacheHeight: (MediaQuery.of(context).size.height / 1.6)
                        .toInt(),
                    errorWidget: (context, _, _) =>
                        const Icon(Icons.movie_outlined),
                    placeholder: (context, _) => const PosterShimmer(),
                  )
                : const PosterPlaceHolder(),
          ),
          // Gradient overlay – fades to scaffold background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    scaffoldBg.withOpacity(0.4),
                    scaffoldBg.withOpacity(0.85),
                    scaffoldBg,
                  ],
                  stops: const [0.25, 0.55, 0.8, 1.0],
                ),
              ),
            ),
          ),

          // Title + release date — bottom left, inside card
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).size.height / 13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Must Watch',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (movie.genreIds != null &&
                        movie.genreIds!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          genres
                              .where((g) => movie.genreIds!.contains(g.id))
                              .map((g) => g.name ?? '')
                              .firstWhere(
                                (name) => name.isNotEmpty,
                                orElse: () => '',
                              ),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    // Rating badge
                    if (movie.voteAverage != null) ...[
                      const SizedBox(width: 8),
                      RatingBadge(movie),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  movie.title ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (movie.releaseDate != null &&
                    movie.releaseDate!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      "dd MMM yyyy",
                    ).format(DateTime.parse(movie.releaseDate!)),
                    maxLines: 1,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: const ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.movieDetail,
                        arguments: movie.id,
                      );
                    },
                    child: Text(
                      'View Detail',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Now Playing',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recently released in the theaters ',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
