import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movrev/core/config/app_config.dart';
import 'package:movrev/domain/entities/movie.dart';
import 'package:movrev/presentation/shared/widgets/poster_shimmer.dart';

class StackedPoster extends StatefulWidget {
  final List<Movie> movies;
  const StackedPoster(this.movies, {super.key});

  @override
  State<StackedPoster> createState() => _StackedPosterState();
}

class _StackedPosterState extends State<StackedPoster> {
  late List<Movie> _currentDisplayMovies;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pickRandomMovies();
    // Update every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _pickRandomMovies();
        });
      }
    });
  }

  void _pickRandomMovies() {
    final allMovies = List<Movie>.from(widget.movies);
    if (allMovies.length > 5) {
      allMovies.shuffle();
      _currentDisplayMovies = allMovies.take(5).toList();
    } else {
      _currentDisplayMovies = allMovies;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 200,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        layoutBuilder: (child, previousChildren) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[...previousChildren, ?child],
          );
        },
        child: Stack(
          key: ValueKey(_currentDisplayMovies.map((m) => m.id).join(',')),
          children: _currentDisplayMovies.asMap().entries.map((entry) {
            int index = entry.key;
            String? posterPath = entry.value.posterPath;

            const posterWidth = 90.0;
            const spacing = 30.0;
            final totalStackWidth =
                (_currentDisplayMovies.length - 1) * spacing + posterWidth;
            final startPadding = (200.0 - totalStackWidth) / 2;

            return Positioned(
              left: startPadding + (index * spacing),
              child: Container(
                key: ValueKey(entry.value.id),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  
                  child: posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: "${AppConfig.baseImageUrl200}$posterPath",
                          height: 140,
                          width: 90,
                          fit: BoxFit.cover,
                          errorWidget: (context, _, _) =>
                              const Icon(Icons.movie_outlined),
                          placeholder: (context, _) => const PosterShimmer(),
                        )
                      : Container(
                          height: 140,
                          width: 90,
                          color: Colors.grey[800],
                          child: const Icon(Icons.movie_outlined),
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
