import 'package:flutter/material.dart';
import 'package:movrev/core/routes/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/presentation/popular/popular_bloc.dart';
import 'package:movrev/presentation/popular/popular_event.dart';
import 'package:movrev/presentation/popular/popular_state.dart';
import 'package:movrev/presentation/popular/top_rated_bloc.dart';
import 'package:movrev/presentation/popular/top_rated_event.dart';
import 'package:movrev/presentation/popular/top_rated_state.dart';
import 'package:movrev/presentation/popular/widgets/item_top_rated_week.dart';
import 'package:movrev/presentation/popular/widgets/stacked_poster.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/presentation/shared/widgets/empty_message.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  final _pageViewController = PageController(viewportFraction: 0.7);

  Future<void> _onRefresh() async {
    final popularBloc = context.read<PopularBloc>();
    final topRatedBloc = context.read<TopRatedBloc>();

    popularBloc.add(PopularRefresh());
    topRatedBloc.add(TopRatedRefresh());

    await Future.wait([
      popularBloc.stream.firstWhere((s) => !s.isLoading),
      topRatedBloc.stream.firstWhere((s) => !s.isLoading),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: BlocBuilder<PopularBloc, PopularState>(
        builder: (context, state) {
          final groupedData = state.genreGroups;
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Top Rated This Week",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.allMovie,
                                arguments: 'top_rated',
                              );
                            },
                            child: Text(
                              "See All",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                      child: SizedBox(
                        height: 400,
                        child: BlocBuilder<TopRatedBloc, TopRatedState>(
                          builder: (context, topRatedState) {
                            if (topRatedState.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (topRatedState.movies.isEmpty) {
                              return const Center(
                                child: EmptyMessage("No movies found"),
                              );
                            }
                            return PageView.builder(
                              itemCount: topRatedState.movies
                                  .take(5)
                                  .toList()
                                  .length,
                              controller: _pageViewController,
                              scrollDirection: Axis.horizontal,
                              padEnds: false,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: ItemTopRatedWeek(
                                    movie: topRatedState.movies[index],
                                    genres: topRatedState.genres,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Text(
                        "Popular By Genre",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ///Popular By Genre UI
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 6,
                      itemBuilder: (context, index) {
                        final group = groupedData[index];
                        final genreName = group['name'] as String;
                        final movies = group['movies'] as List<Movie>;
                        final score = group['score'] as int;

                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRouter.allMovie,
                              arguments: {
                                'type': 'movie_by_genre',
                                'movieId': group['id'],
                                'title': genreName,
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background Posters
                                Transform.scale(
                                  scale: 1.2,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: StackedPoster(movies),
                                  ),
                                ),

                                // Dark Overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                                    ),
                                  ),
                                ),

                                // Genre Title & Score
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        genreName,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${movies.length} Movies",
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      Text(
                                        "Score: $score",
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: groupedData.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
