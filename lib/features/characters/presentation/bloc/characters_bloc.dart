import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/usecases/get_characters.dart';
import '../../domain/usecases/search_characters.dart';

part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc({required this.getCharacters, required this.searchCharacters})
    : super(const CharactersState()) {
    on<CharactersRequested>(_onCharactersRequested);
    on<CharactersSearchSubmitted>(_onCharactersSearchSubmitted);
  }

  final GetCharacters getCharacters;
  final SearchCharacters searchCharacters;

  Future<void> _onCharactersRequested(
    CharactersRequested event,
    Emitter<CharactersState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CharactersStatus.loading,
        query: '',
        clearError: true,
      ),
    );

    await _loadCharacters(
      emit,
      query: '',
      action: () => getCharacters(language: event.language),
    );
  }

  Future<void> _onCharactersSearchSubmitted(
    CharactersSearchSubmitted event,
    Emitter<CharactersState> emit,
  ) async {
    final query = event.query.trim();

    emit(
      state.copyWith(
        status: CharactersStatus.loading,
        query: query,
        clearError: true,
      ),
    );

    await _loadCharacters(
      emit,
      query: query,
      action: () => searchCharacters(
        SearchCharactersParams(search: query, language: event.language),
      ),
    );
  }

  Future<void> _loadCharacters(
    Emitter<CharactersState> emit, {
    required String query,
    required Future<List<CharacterEntity>> Function() action,
  }) async {
    try {
      final characters = await action();

      emit(
        state.copyWith(
          status: CharactersStatus.success,
          characters: characters,
          query: query,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CharactersStatus.failure,
          query: query,
          errorMessage: _errorMessage(error),
        ),
      );
    }
  }

  String _errorMessage(Object error) {
    if (error is Failure) {
      return error.message;
    }

    return 'Something went wrong while loading characters.';
  }
}
