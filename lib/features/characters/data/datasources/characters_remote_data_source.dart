import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/character_model.dart';

abstract class CharactersRemoteDataSource {
  Future<List<CharacterModel>> getCharacters({
    String language = ApiConstants.defaultLanguage,
    String? search,
  });
}

class CharactersRemoteDataSourceImpl implements CharactersRemoteDataSource {
  const CharactersRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<CharacterModel>> getCharacters({
    String language = ApiConstants.defaultLanguage,
    String? search,
  }) async {
    final uri = ApiConstants.charactersUri(language: language, search: search);
    final response = await apiClient.getJson(uri);

    if (response is List) {
      return response.map(_mapCharacter).toList(growable: false);
    }

    if (response is Map<String, dynamic>) {
      return [CharacterModel.fromJson(response)];
    }

    throw const ParseException('Potter API returned an unexpected response.');
  }

  CharacterModel _mapCharacter(Object? value) {
    if (value is Map<String, dynamic>) {
      return CharacterModel.fromJson(value);
    }

    if (value is Map) {
      return CharacterModel.fromJson(Map<String, dynamic>.from(value));
    }

    throw const ParseException('Potter API character item is invalid.');
  }
}
