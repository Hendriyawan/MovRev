import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movrev/domain/usecases/add_favorite_use_case.dart';
import 'package:movrev/domain/usecases/get_favorites_use_case.dart';
import 'package:movrev/domain/usecases/is_favorite_use_case.dart';
import 'package:movrev/domain/usecases/remove_favorite_use_case.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  final IsFavoriteUseCase isFavoriteUseCase;

  FavoriteBloc({
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.getFavoritesUseCase,
    required this.isFavoriteUseCase,
  }) : super(const FavoriteState()) {
    on<FetchFavorites>(_onFetchFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<CheckFavoriteStatus>(_onCheckFavoriteStatus);
  }

  Future<void> _onFetchFavorites(
    FetchFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final favorites = await getFavoritesUseCase();
      emit(state.copyWith(isLoading: false, favorites: favorites));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final isFav = await isFavoriteUseCase(event.movie.id!);
      if (isFav) {
        await removeFavoriteUseCase(event.movie.id!);
      } else {
        await addFavoriteUseCase(event.movie);
      }
      
      // Update check status
      final newStatus = !isFav;
      
      // Refresh list if we are on favorites page
      final favorites = await getFavoritesUseCase();
      
      emit(state.copyWith(
        favorites: favorites,
        isFavorite: newStatus,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatus event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final isFav = await isFavoriteUseCase(event.id);
      emit(state.copyWith(isFavorite: isFav));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}

