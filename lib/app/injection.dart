import 'package:get_it/get_it.dart';
import 'package:movrev/data/datasource/api_service.dart';
import 'package:movrev/data/datasource/movie_remote_data_source.dart';
import 'package:movrev/data/repositories/movie_repository_impl.dart';
import 'package:movrev/domain/repositories/movie_repository.dart';
import 'package:movrev/domain/usecases/get_genres_use_case.dart';
import 'package:movrev/domain/usecases/get_movie_detail_use_case.dart';
import 'package:movrev/domain/usecases/get_cast_use_case.dart';
import 'package:movrev/domain/usecases/get_video_usecase.dart';
import 'package:movrev/domain/usecases/get_now_playing_movies_use_case.dart';
import 'package:movrev/domain/usecases/get_popular_movies_use_case.dart';
import 'package:movrev/domain/usecases/search_movies_use_case.dart';
import 'package:movrev/domain/usecases/get_similar_movies_use_case.dart';
import 'package:movrev/domain/usecases/get_top_rated_movies_use_case.dart';
import 'package:movrev/domain/usecases/get_upcoming_movies_use_case.dart';
import 'package:movrev/domain/usecases/get_movies_by_genre_use_case.dart';
import 'package:movrev/domain/usecases/add_favorite_use_case.dart';
import 'package:movrev/domain/usecases/remove_favorite_use_case.dart';
import 'package:movrev/domain/usecases/get_favorites_use_case.dart';
import 'package:movrev/domain/usecases/is_favorite_use_case.dart';
import 'package:movrev/data/datasource/movie_local_data_source.dart';
import 'package:movrev/presentation/favorite/favorite_bloc.dart';
import 'package:movrev/presentation/all/all_movie_bloc.dart';
import 'package:movrev/presentation/detail/movie_detail_bloc.dart';
import 'package:movrev/presentation/detail/movie_similar_bloc.dart';
import 'package:movrev/presentation/favorite/favorite_event.dart';
import 'package:movrev/presentation/now_playing/now_playing_bloc.dart';
import 'package:movrev/presentation/popular/popular_bloc.dart';
import 'package:movrev/presentation/popular/top_rated_bloc.dart';
import 'package:movrev/presentation/upcoming/upcoming_bloc.dart';

///DEPENDENCIES INJECTION WITH Get_it

final locator = GetIt.instance;

Future<void> initInjection() async {
  //Api Service
  locator.registerLazySingleton<ApiService>(() => ApiService());
  //Data Source
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(apiService: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(),
  );

  //Repostiory
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  //Usecase
  locator.registerLazySingleton<GetNowPlayingMoviesUseCase>(
    () => GetNowPlayingMoviesUseCase(locator()),
  );
  locator.registerLazySingleton<GetUpcomingMoviesUseCase>(
    () => GetUpcomingMoviesUseCase(locator()),
  );
  locator.registerLazySingleton<GetGenresUseCase>(
    () => GetGenresUseCase(locator()),
  );

  locator.registerLazySingleton<GetPopularMoviesUseCase>(
    () => GetPopularMoviesUseCase(locator()),
  );

  locator.registerLazySingleton<GetTopRatedMoviesUseCase>(
    () => GetTopRatedMoviesUseCase(locator()),
  );

  locator.registerLazySingleton<GetMovieDetailUseCase>(
    () => GetMovieDetailUseCase(locator()),
  );
  locator.registerLazySingleton<GetCastUseCase>(
    () => GetCastUseCase(locator()),
  );
  locator.registerLazySingleton<GetVideoUsecase>(
    () => GetVideoUsecase(locator()),
  );

  locator.registerLazySingleton<GetSimilarMoviesUseCase>(
    () => GetSimilarMoviesUseCase(locator()),
  );
  locator.registerLazySingleton<SearchMoviesUseCase>(
    () => SearchMoviesUseCase(locator()),
  );
  locator.registerLazySingleton<GetMoviesByGenreUseCase>(
    () => GetMoviesByGenreUseCase(locator()),
  );
  locator.registerLazySingleton<AddFavoriteUseCase>(
    () => AddFavoriteUseCase(locator()),
  );
  locator.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(locator()),
  );
  locator.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(locator()),
  );
  locator.registerLazySingleton<IsFavoriteUseCase>(
    () => IsFavoriteUseCase(locator()),
  );

  //BLoC
  locator.registerFactory(() => NowPlayingBloc(locator(), locator()));
  locator.registerFactory(() => UpcomingBloc(locator(), locator()));
  locator.registerFactory(() => PopularBloc(locator(), locator()));
  locator.registerFactory(() => TopRatedBloc(locator(), locator()));
  locator.registerFactory(() => MovieDetailBloc(locator(), locator(), locator()));
  locator.registerFactory(() => MovieSimilarBloc(locator(), locator()));
  locator.registerFactory(
    () => AllMovieBloc(
      getTopRatedMoviesUseCase: locator(),
      getSimilarMoviesUseCase: locator(),
      searchMoviesUseCase: locator(),
      getGenresUseCase: locator(),
      getMoviesByGenreUseCase: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => FavoriteBloc(
      addFavoriteUseCase: locator(),
      removeFavoriteUseCase: locator(),
      getFavoritesUseCase: locator(),
      isFavoriteUseCase: locator(),
    )..add(FetchFavorites()),
  );
}


