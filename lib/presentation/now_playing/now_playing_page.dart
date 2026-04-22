// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:movrev/core/routes/app_router.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/presentation/now_playing/now_playing_bloc.dart';
import 'package:movrev/presentation/now_playing/now_playing_event.dart';
import 'package:movrev/presentation/now_playing/now_playing_state.dart';
import 'package:movrev/presentation/now_playing/widgets/item_now_playing.dart';
import 'package:movrev/presentation/now_playing/widgets/item_now_playing_featured.dart';
import 'package:movrev/presentation/shared/widgets/empty_message.dart';
import 'package:movrev/presentation/shared/widgets/error_message.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      context.read<NowPlayingBloc>().add(NowPlayingLoadMore());
    }

    // Update AppBar background opacity based on scroll
    final offset = _scrollController.offset;
    final newOpacity = (offset / 150).clamp(0.0, 1.0);
    if (newOpacity != _appBarOpacity) {
      setState(() {
        _appBarOpacity = newOpacity;
      });
    }
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<NowPlayingBloc>();
    bloc.add(NowPlayingRefresh());
    // Wait until loading finishes so the RefreshIndicator spinner stays visible
    await bloc.stream.firstWhere((s) => !s.isLoading);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final scaffoldBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocBuilder<NowPlayingBloc, NowPlayingState>(
        builder: (context, state) {
          // Initial loading (no data yet)
          if (state.isLoading && state.movies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error with no data
          if (state.errorMessage != null && state.movies.isEmpty) {
            return ErrorMessage(
              state.errorMessage ?? "",
              () => context.read<NowPlayingBloc>().add(NowPlayingRefresh()),
            );
          }

          // Empty state
          if (!state.isLoading && state.movies.isEmpty) {
            return EmptyMessage("No movies playing right now");
          }

          // Data available – featured first item + grid
          final gridMovies = state.movies.length > 1
              ? state.movies.sublist(1)
              : <Movie>[];

          final expandedHeight = MediaQuery.of(context).size.height / 2.1;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryColor,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              cacheExtent: 1000,
              slivers: [
                // Parallax Header with dynamic AppBar
                SliverAppBar(
                  floating: true,
                  expandedHeight: expandedHeight,
                  pinned: true,
                  stretch: true,
                  backgroundColor: scaffoldBg,
                  elevation: 0,
                  centerTitle: false,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.allMovie,
                          arguments: 'search',
                        );
                      },
                      icon: Icon(
                        Icons.search,
                        color: theme.colorScheme.onSurface,
                        size: 36,
                      ),
                    ),
                  ],
                  scrolledUnderElevation: 0,
                  leadingWidth: 0,
                  leading: const SizedBox.shrink(),
                  titleSpacing: 1,
                  title: Opacity(
                    opacity: _appBarOpacity,
                    child: _buildAppBarTitle(primaryColor),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        ItemNowPlayingFeatured(
                          movie: state.movies.first,
                          genres: state.genres,
                        ),
                      ],
                    ),
                  ),
                ),

                // Remaining movies in grid
                if (gridMovies.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 3,
                            childAspectRatio: 0.55,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= gridMovies.length) {
                            return _buildLoadingMoreTile();
                          }
                          return ItemNowPlaying(
                            movie: gridMovies[index],
                            genres: state.genres,
                          );
                        },
                        childCount:
                            gridMovies.length + (state.isLoadingMore ? 2 : 0),
                      ),
                    ),
                  ),

                // Loading-more indicator when grid is empty but loading
                if (gridMovies.isEmpty && state.isLoadingMore)
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
  }

  Widget _buildAppBarTitle(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            primaryColor.withOpacity(0.15),
            primaryColor.withOpacity(0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'MOVREV',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/logo/tmdb.svg',
                    cacheColorFilter: true,
                    width: 48,
                    colorFilter: ColorFilter.mode(
                      primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreTile() {
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
