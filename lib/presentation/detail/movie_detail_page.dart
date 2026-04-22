import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/app/injection.dart';
import 'package:movrev/presentation/detail/movie_detail_bloc.dart';
import 'package:movrev/presentation/detail/movie_detail_event.dart';
import 'package:movrev/presentation/detail/movie_detail_state.dart';
import 'package:movrev/presentation/detail/movie_similar_bloc.dart';
import 'package:movrev/presentation/detail/movie_similar_event.dart';
import 'package:movrev/presentation/detail/widgets/movie_header.dart';
import 'package:movrev/presentation/detail/widgets/movie_info.dart';
import 'package:movrev/presentation/detail/widgets/movie_similar.dart';
import 'package:movrev/presentation/shared/widgets/error_message.dart';
import 'package:movrev/presentation/shared/widgets/poster_shimmer.dart';

import 'package:movrev/presentation/favorite/favorite_bloc.dart';
import 'package:movrev/presentation/favorite/favorite_event.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final _pageViewController = PageController(viewportFraction: 0.7);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteBloc>().add(CheckFavoriteStatus(widget.movieId));
    });
  }

  Future<void> _onRefresh(BuildContext blocContext) async {
    final movieDetailBloc = blocContext.read<MovieDetailBloc>();
    final movieSimilarBloc = blocContext.read<MovieSimilarBloc>();
    final favoriteBloc = blocContext.read<FavoriteBloc>();

    movieDetailBloc.add(MovieDetailLoad(widget.movieId));
    movieSimilarBloc.add(MovieSimilarInitial(widget.movieId, 1));
    favoriteBloc.add(CheckFavoriteStatus(widget.movieId));

    // Wait for both blocs to finish loading before hiding the refresh indicator
    await Future.wait([
      movieDetailBloc.stream
          .skipWhile((s) => !s.isLoading)
          .firstWhere((s) => !s.isLoading),
      movieSimilarBloc.stream
          .skipWhile((s) => !s.isLoading)
          .firstWhere((s) => !s.isLoading),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              locator<MovieDetailBloc>()..add(MovieDetailLoad(widget.movieId)),
        ),
        BlocProvider(
          create: (context) =>
              locator<MovieSimilarBloc>()
                ..add(MovieSimilarInitial(widget.movieId, 1)),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Hero(
                tag: 'movie-poster-${widget.movieId}',
                child: const PosterShimmer(),
              );
            }

            if (state.errorMessage != null) {
              return ErrorMessage(state.errorMessage ?? "", () {
                _onRefresh(context);
              });
            }

            final movie = state.detail;

            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    MovieHeader(movie: movie, videos: state.videos),
                    MovieInfo(movie: movie),
                    MovieSimilar(
                      widget.movieId,
                      pageController: _pageViewController,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
