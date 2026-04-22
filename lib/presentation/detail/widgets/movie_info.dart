import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/entities/movie_detail.dart';
import 'package:movrev/presentation/detail/movie_detail_bloc.dart';
import 'package:movrev/presentation/detail/movie_detail_state.dart';
import 'package:movrev/presentation/detail/widgets/cast_card.dart';
import 'package:movrev/presentation/shared/widgets/poster_shimmer.dart';

class MovieInfo extends StatelessWidget {
  final MovieDetail movie;
  const MovieInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Synopsis Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Synopsis",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  movie.overview ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Cast Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Top Cast",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Horizontal Cast List
          BlocBuilder<MovieDetailBloc, MovieDetailState>(
            builder: (context, state) {
              if (state.isCastLoading) {
                return SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: 5,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: PosterShimmer(),
                    ),
                  ),
                );
              }

              if (state.casts.isEmpty) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 12),
                  itemCount: state.casts.length,
                  itemBuilder: (context, index) {
                    final cast = state.casts[index];
                    return CastCard(cast: cast);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
