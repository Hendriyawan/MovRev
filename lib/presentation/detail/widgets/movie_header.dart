// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:movrev/core/routes/app_router.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/domain/entities/video.dart';
import 'package:movrev/presentation/favorite/favorite_bloc.dart';
import 'package:movrev/presentation/favorite/favorite_event.dart';
import 'package:movrev/presentation/favorite/favorite_state.dart';
import 'package:movrev/core/config/app_config.dart';
import 'package:movrev/core/utils/utils.dart';
import 'package:movrev/domain/entities/movie_detail.dart';
import 'package:movrev/presentation/detail/widgets/header_gradient.dart';
import 'package:movrev/presentation/shared/widgets/poster_place_holder.dart';
import 'package:movrev/presentation/shared/widgets/poster_shimmer.dart';

class MovieHeader extends StatelessWidget {
  final MovieDetail movie;
  final List<Video> videos;
  const MovieHeader({super.key, required this.movie, required this.videos});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expandedHeight = MediaQuery.of(context).size.height / 1.7;

    return Stack(
      children: [
        // Background Image
        SizedBox(
          height: expandedHeight,
          width: double.infinity,
          child: Hero(
            tag: 'movie-poster-${movie.id}',
            child: (movie.backdropPath ?? movie.posterPath) != null
                ? CachedNetworkImage(
                    imageUrl:
                        '${AppConfig.baseImageUrlOri}${movie.backdropPath ?? movie.posterPath}',
                    fit: BoxFit.cover,
                    errorWidget: (context, _, _) =>
                        const Icon(Icons.movie_outlined),
                    placeholder: (context, _) => const PosterShimmer(),
                  )
                : const PosterPlaceHolder(),
          ),
        ),

        // Gradient overlay
        Positioned.fill(
          child: SizedBox(
            height: expandedHeight,
            child: const HeaderGradient(),
          ),
        ),

        // Back Button
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(backgroundColor: Colors.black26),
            ),
          ),
        ),

        // Movie Info Content Overlay
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie.genres != null && movie.genres!.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: movie.genres!
                      .map(
                        (genre) => Chip(
                          label: Text(
                            genre.name ?? '',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          side: BorderSide.none,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.black45,
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: 8),
              Text(
                movie.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: theme.colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${movie.voteAverage?.toStringAsFixed(1)}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formatRuntime(movie.runtime ?? 0),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat(
                      "dd MMM yyyy",
                    ).format(DateTime.parse(movie.releaseDate ?? "2000-01-01")),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons with previous gradient style
              if (movie.productionCompanies != null &&
                  movie.productionCompanies!.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Watch Trailer Button
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          if (videos.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: theme.colorScheme.secondary,
                                content: Text(
                                  "Trailer is not available on YouTube",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.surface,
                                  ),
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            );
                          } else {
                            final video = videos.firstWhere(
                              (element) => element.type == "Trailer",
                            );
                            if (video.site != null &&
                                video.site!.contains("YouTube")) {
                              Navigator.pushNamed(
                                context,
                                AppRouter.videoTrailer,
                                arguments: video.key,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: theme.colorScheme.secondary,
                                  content: Text(
                                    "Trailer is not available on YouTube",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.surface,
                                    ),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_arrow, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "Watch Trailer",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Add To Favorites Button
                    BlocBuilder<FavoriteBloc, FavoriteState>(
                      builder: (context, state) {
                        final isFavorite = state.isFavorite;
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isFavorite
                                  ? [
                                      Colors.redAccent.withValues(alpha: 0.8),
                                      Colors.red.shade900.withValues(
                                        alpha: 0.8,
                                      ),
                                    ]
                                  : [
                                      theme.colorScheme.surface,
                                      theme.colorScheme.surface,
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isFavorite
                                ? [
                                    BoxShadow(
                                      color: Colors.redAccent.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                : null,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: isFavorite
                                  ? Colors.white
                                  : theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              final movieToFavorite = Movie(
                                id: movie.id,
                                title: movie.title,
                                posterPath: movie.posterPath,
                                backdropPath: movie.backdropPath,
                                voteAverage: movie.voteAverage,
                                overview: movie.overview,
                                releaseDate: movie.releaseDate,
                              );
                              context.read<FavoriteBloc>().add(
                                ToggleFavorite(movieToFavorite),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 24,
                                  color: isFavorite
                                      ? Colors.white
                                      : theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isFavorite ? "Favorited" : "Add To Favorite",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: isFavorite
                                        ? Colors.white
                                        : theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
