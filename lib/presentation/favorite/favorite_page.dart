import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/presentation/favorite/favorite_bloc.dart';
import 'package:movrev/presentation/favorite/favorite_state.dart';
import 'package:movrev/presentation/now_playing/widgets/item_now_playing.dart';
import 'package:movrev/presentation/shared/widgets/empty_message.dart';
import 'package:movrev/presentation/now_playing/now_playing_bloc.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final genres = context.select((NowPlayingBloc bloc) => bloc.state.genres);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Movies"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state.isLoading && state.favorites.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.favorites.isEmpty) {
            return const Center(
              child: EmptyMessage("You don't have any favorite movies yet."),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.55,
              ),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final movie = state.favorites[index];
                return ItemNowPlaying(
                  movie: movie,
                  genres: genres,
                );
              },
            ),
          );
        },
      ),
    );
  }
}