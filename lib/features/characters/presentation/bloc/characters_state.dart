part of 'characters_bloc.dart';

enum CharactersStatus { initial, loading, success, failure }

class CharactersState extends Equatable {
  const CharactersState({
    this.status = CharactersStatus.initial,
    this.characters = const [],
    this.query = '',
    this.errorMessage,
  });

  final CharactersStatus status;
  final List<CharacterEntity> characters;
  final String query;
  final String? errorMessage;

  bool get isLoading => status == CharactersStatus.loading;
  bool get hasQuery => query.trim().isNotEmpty;

  CharactersState copyWith({
    CharactersStatus? status,
    List<CharacterEntity>? characters,
    String? query,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      query: query ?? this.query,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, characters, query, errorMessage];
}
