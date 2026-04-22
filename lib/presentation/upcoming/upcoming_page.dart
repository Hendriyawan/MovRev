import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/presentation/shared/widgets/error_message.dart';
import 'package:movrev/presentation/upcoming/upcoming_bloc.dart';
import 'package:movrev/presentation/upcoming/upcoming_event.dart';
import 'package:movrev/presentation/upcoming/upcoming_state.dart';
import 'package:movrev/presentation/upcoming/widgets/date_header.dart';
import 'package:movrev/presentation/upcoming/widgets/group_toggle.dart';
import 'package:movrev/presentation/upcoming/widgets/item_upcoming.dart';
import 'package:movrev/core/utils/movie_grouping_utils.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  final ScrollController _scrollController = ScrollController();

  /// Toggle between week-grouping and month-grouping
  GroupMode _groupMode = GroupMode.week;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      context.read<UpcomingBloc>().add(UpcomingLoadMore());
    }
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<UpcomingBloc>();
    bloc.add(UpcomingRefresh());
    await bloc.stream.firstWhere((s) => !s.isLoading);
  }

  // ── UI ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: BlocBuilder<UpcomingBloc, UpcomingState>(
        builder: (context, state) {
          // Initial loading (no data yet)
          if (state.isLoading && state.movies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error with no data
          if (state.errorMessage != null && state.movies.isEmpty) {
            return ErrorMessage(
              state.errorMessage ?? "",
              () => context.read<UpcomingBloc>().add(UpcomingRefresh()),
            );
          }

          final groups = MovieGroupingUtils.groupMovies(
            state.movies,
            _groupMode,
          );

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // ── Page title + group-mode toggle
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Coming\nSoon",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Week / Month toggle chip
                          GroupToggle(
                            _groupMode,
                            (mode) => setState(() => _groupMode = mode),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Date groups
                  for (final entry in groups) ...[
                    // Non-sticky section header
                    SliverToBoxAdapter(
                      child: DateHeader(
                      label: MovieGroupingUtils.groupLabel(
                          entry.key,
                          _groupMode,
                        ),
                        groupKey: entry.key,
                        mode: _groupMode,
                      ),
                    ),

                    // 2-column grid of movies in this group
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 3,
                              childAspectRatio: 0.55,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ItemUpcoming(
                            movie: entry.value[index],
                          genres: state.genres,
                          ),
                          childCount: entry.value.length,
                        ),
                      ),
                    ),
                  ],

                  // ── Loading more indicator
                  if (state.isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                      ),
                    ),

                  // // ── Bottom padding
                  // const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
