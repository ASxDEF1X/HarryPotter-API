import '../entities/character_entity.dart';
import '../repositories/characters_repository.dart';

class GetCharacters {
  const GetCharacters(this.repository);

  final CharactersRepository repository;

  Future<List<CharacterEntity>> call({String language = 'en'}) {
    return repository.getCharacters(language: language);
  }
}
