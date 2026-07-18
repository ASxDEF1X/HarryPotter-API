import '../entities/character_entity.dart';

abstract class CharactersRepository {
  Future<List<CharacterEntity>> getCharacters({String language = 'en'});

  Future<List<CharacterEntity>> searchCharacters({
    required String search,
    String language = 'en',
  });
}
