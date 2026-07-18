import 'package:equatable/equatable.dart';

import '../entities/character_entity.dart';
import '../repositories/characters_repository.dart';

class SearchCharacters {
  const SearchCharacters(this.repository);

  final CharactersRepository repository;

  Future<List<CharacterEntity>> call(SearchCharactersParams params) {
    final search = params.search.trim();

    if (search.isEmpty) {
      return repository.getCharacters(language: params.language);
    }

    return repository.searchCharacters(
      search: search,
      language: params.language,
    );
  }
}

class SearchCharactersParams extends Equatable {
  const SearchCharactersParams({required this.search, this.language = 'en'});

  final String search;
  final String language;

  @override
  List<Object?> get props => [search, language];
}
