import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movrev/core/config/app_config.dart';
import 'package:movrev/core/routes/app_router.dart';
import 'package:movrev/domain/entities/genre.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/presentation/shared/widgets/rating_badge.dart';
import 'package:movrev/presentation/shared/widgets/poster_shimmer.dart';

class ItemNowPlaying extends StatelessWidget {
  final Movie movie;
  final List<Genre> genres;

  const ItemNowPlaying({super.key, required this.movie, required this.genres});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRouter.movieDetail,
          arguments: movie.id,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card: only poster and badge
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorScheme.surfaceContainerHigh,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Poster
                    Hero(
                      tag: 'movie-poster-${movie.id}',
                      child: CachedNetworkImage(
                        imageUrl:
                            '${AppConfig.baseImageUrl200}${movie.posterPath}',
                        fit: BoxFit.cover,
                        memCacheWidth: 200,
                        errorWidget: (context, _, _) =>
                            const Icon(Icons.movie_outlined),
                        placeholder: (context, _) => const PosterShimmer(),
                      ),
                    ),

                    // Rating badge
                    if (movie.voteAverage != null)
                      Positioned(top: 8, right: 8, child: RatingBadge(movie)),
                  ],
                ),
              ),
            ),

            // Title + release date — outside card
            const SizedBox(height: 8),
            Text(
              movie.title ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (movie.genreIds != null && movie.genreIds!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                genres
                    .where((g) => movie.genreIds!.contains(g.id))
                    .map((g) => g.name ?? '')
                    .firstWhere((name) => name.isNotEmpty, orElse: () => ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                DateFormat(
                  "dd MMM yyyy",
                ).format(DateTime.parse(movie.releaseDate!)),
                maxLines: 1,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
