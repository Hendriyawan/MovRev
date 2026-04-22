import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/app/injection.dart';
import 'package:movrev/presentation/all/all_movie_bloc.dart';
import 'package:movrev/presentation/all/all_movie_event.dart';
import 'package:movrev/presentation/all/all_movie_state.dart';
import 'package:movrev/presentation/now_playing/widgets/item_now_playing.dart';
import 'package:movrev/presentation/shared/widgets/empty_message.dart';
import 'package:movrev/presentation/shared/widgets/error_message.dart';

class AllMoviePage extends StatefulWidget {
  final String type;
  final int? movieId;
  final String? title;
  const AllMoviePage(this.type, {super.key, this.movieId, this.title});

  @override
  State<AllMoviePage> createState() => _AllMoviePageState();
}

class _AllMoviePageState extends State<AllMoviePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AllMovieBloc>().add(AllMovieLoadMore());
    }
  }

  void _onSearchChanged(String query, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<AllMovieBloc>().add(
        AllMovieFetch(type: 'search', query: query),
      );
    });
  }

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<AllMovieBloc>();
    bloc.add(
      AllMovieFetch(
        type: widget.type,
        query: _searchController.text,
        movieId: widget.movieId,
        isRefresh: true,
      ),
    );
    await bloc.stream.firstWhere((s) => !s.isLoading);
  }

  String _getTitle() {
    if (widget.title != null) return widget.title!;
    switch (widget.type) {
      case 'top_rated':
        return 'Top Rated Movies';
      case 'similar':
        return 'Similar Movies';
      case 'search':
        return 'Search Movies';
      case 'movie_by_genre':
      return 'Movies by Genre';
      default:
        return 'Movies';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          locator<AllMovieBloc>()
            ..add(AllMovieFetch(type: widget.type, movieId: widget.movieId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_getTitle()),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: BlocBuilder<AllMovieBloc, AllMovieState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (widget.type == 'search')
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverSearchDelegate(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (v) => _onSearchChanged(v, context),
                                decoration: InputDecoration(
                                  hintText: 'Search for movies...',
                                  prefixIcon: const Icon(Icons.search),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHigh,
                                ),
                              ),
                            ),
                          ),
                        ),

                      if (state.isLoading && state.movies.isEmpty)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        ),

                      if (state.errorMessage != null && state.movies.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: ErrorMessage(state.errorMessage!, () {
                            context.read<AllMovieBloc>().add(
                              AllMovieFetch(
                                type: widget.type,
                                movieId: widget.movieId,
                                query: _searchController.text,
                              ),
                            );
                          }),
                        ),

                      if (state.movies.isEmpty &&
                          !state.isLoading &&
                          state.errorMessage == null)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: EmptyMessage("No movies found")),
                        ),

                      if (state.movies.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.55,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= state.movies.length) {
                                  return _buildLoadingMoreTile(context);
                                }
                                return ItemNowPlaying(
                                  movie: state.movies[index],
                                  genres: state.genres,
                                );
                              },
                              childCount:
                                  state.movies.length +
                                  (state.isLoadingMore ? 2 : 0),
                            ),
                          ),
                        ),

                      if (state.movies.isEmpty && state.isLoadingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingMoreTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _SliverSearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverSearchDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: maxExtent,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant _SliverSearchDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
