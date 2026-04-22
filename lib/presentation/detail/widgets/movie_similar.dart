import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/core/routes/app_router.dart';
import 'package:movrev/presentation/detail/movie_similar_bloc.dart';
import 'package:movrev/presentation/detail/movie_similar_state.dart';
import 'package:movrev/presentation/popular/widgets/item_top_rated_week.dart';
import 'package:movrev/presentation/shared/widgets/empty_message.dart';

class MovieSimilar extends StatelessWidget {
  final int movieId;
  final PageController pageController;

  const MovieSimilar(this.movieId, {super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 12),
          child: Text(
            "Similar Movies",
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 12, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Curated picks based on your taste",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.allMovie,
                    arguments: {'type': 'similar', 'movieId': movieId},
                  );
                },
                child: Text(
                  "See All",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400,
          child: BlocBuilder<MovieSimilarBloc, MovieSimilarState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.movies.isEmpty) {
                return const Center(
                  child: EmptyMessage("No similar movies found"),
                );
              }
              return PageView.builder(
                itemCount: state.movies.take(5).toList().length,
                controller: pageController,
                scrollDirection: Axis.horizontal,
                padEnds: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ItemTopRatedWeek(
                      movie: state.movies[index],
                      genres: state.genres,
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
