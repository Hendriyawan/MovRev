import 'package:flutter/material.dart';
import 'package:movrev/presentation/all/all_movie_page.dart';
import 'package:movrev/presentation/detail/movie_detail_page.dart';
import 'package:movrev/presentation/detail/video_view_trailer_page.dart';
import 'package:movrev/presentation/shell/main_shell.dart';

class AppRouter {
  static const String root = '/';
  static const String movieDetail = '/movie-detail';
  static const String allMovie = '/all-movie';
  static const String videoTrailer = '/video-trailer';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(
          builder: (_) => const MainShell(),
        );

      case movieDetail:
        final movieId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MovieDetailPage(movieId: movieId),
        );

      case videoTrailer:
        final key = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VideoViewTrailerPage(videoKey: key),
        );
        
      case allMovie:
        if (settings.arguments is String) {
          return MaterialPageRoute(
            builder: (_) => AllMoviePage(settings.arguments as String),
          );
        } else {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => AllMoviePage(
              args['type'] as String,
              movieId: args['movieId'] as int?,
              title: args['title'] as String?,
            ),
          );
        }

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
