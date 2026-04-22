// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movrev/core/config/app_config.dart';
import 'package:movrev/core/routes/app_router.dart';
import 'package:movrev/domain/entities/genre.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/presentation/shared/widgets/rating_badge.dart';
import 'package:movrev/presentation/shared/widgets/poster_shimmer.dart';
import 'package:movrev/presentation/shared/widgets/poster_place_holder.dart';

class ItemUpcoming extends StatelessWidget {
  final Movie movie;
  final List<Genre> genres;

  const ItemUpcoming({super.key, required this.movie, required this.genres});

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
            // Card: poster + rating badge
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
                    movie.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                '${AppConfig.baseImageUrlOri}${movie.posterPath}',
                            fit: BoxFit.cover,
                            errorWidget: (context, _, _) =>
                                const Icon(Icons.movie_outlined),
                            placeholder: (context, _) => const PosterShimmer(),
                          )
                        : const PosterPlaceHolder(),

                    // Gradient overlay at bottom
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.55, 1.0],
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //Date Release
                    if (movie.releaseDate != null &&
                        movie.releaseDate!.isNotEmpty)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            DateFormat(
                              "dd MMM",
                            ).format(DateTime.parse(movie.releaseDate!)),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Rating badge (top-right)
                    if (movie.voteAverage != null)
                      Positioned(top: 8, right: 8, child: RatingBadge(movie)),

                    // Genre chip (bottom-left inside card)
                    if (movie.genreIds != null && movie.genreIds!.isNotEmpty)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: _GenreChip(movie: movie, genres: genres),
                      ),
                  ],
                ),
              ),
            ),

            // Title — outside card
            const SizedBox(height: 8),
            Text(
              movie.title ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final Movie movie;
  final List<Genre> genres;

  const _GenreChip({required this.movie, required this.genres});

  @override
  Widget build(BuildContext context) {
    final genreName = genres
        .where((g) => movie.genreIds!.contains(g.id))
        .map((g) => g.name ?? '')
        .firstWhere((name) => name.isNotEmpty, orElse: () => '');

    if (genreName.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        genreName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
