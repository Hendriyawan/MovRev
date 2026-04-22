import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/app/injection.dart';
import 'package:movrev/core/theme/app_theme.dart';
import 'package:movrev/presentation/now_playing/now_playing_bloc.dart';
import 'package:movrev/presentation/now_playing/now_playing_event.dart';
import 'package:movrev/presentation/popular/popular_bloc.dart';
import 'package:movrev/presentation/popular/popular_event.dart';
import 'package:movrev/presentation/popular/top_rated_bloc.dart';
import 'package:movrev/presentation/popular/top_rated_event.dart';
import 'package:movrev/presentation/upcoming/upcoming_bloc.dart';
import 'package:movrev/presentation/upcoming/upcoming_event.dart';
import 'package:movrev/presentation/favorite/favorite_bloc.dart';
import 'package:movrev/core/routes/app_router.dart';

class MovRevApp extends StatelessWidget {
  const MovRevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingBloc>(
          create: (context) =>
              locator<NowPlayingBloc>()..add(NowPlayingInitial()),
        ),
        BlocProvider<UpcomingBloc>(
          create: (context) => locator<UpcomingBloc>()..add(UpcomingInitial()),
        ),
        BlocProvider<PopularBloc>(
          create: (context) => locator<PopularBloc>()..add(PopularInitial()),
        ),
        BlocProvider<TopRatedBloc>(
          create: (context) => locator<TopRatedBloc>()..add(TopRatedInitial()),
        ),
        BlocProvider<FavoriteBloc>(
          create: (context) => locator<FavoriteBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'MovRev - TMDB',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.root,
      ),
    );
  }
}
