import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/repositories/characters_repository.dart';
import '../datasources/characters_remote_data_source.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  const CharactersRepositoryImpl({required this.remoteDataSource});

  final CharactersRemoteDataSource remoteDataSource;

  @override
  Future<List<CharacterEntity>> getCharacters({String language = 'en'}) {
    return _request(() => remoteDataSource.getCharacters(language: language));
  }

  @override
  Future<List<CharacterEntity>> searchCharacters({
    required String search,
    String language = 'en',
  }) {
    return _request(
      () => remoteDataSource.getCharacters(language: language, search: search),
    );
  }

  Future<List<CharacterEntity>> _request(
    Future<List<CharacterEntity>> Function() action,
  ) async {
    try {
      return await action();
    } on ServerException catch (error) {
      throw ServerFailure(error.message, statusCode: error.statusCode);
    } on ParseException catch (error) {
      throw ParsingFailure(error.message);
    } on Failure {
      rethrow;
    } on Exception {
      throw const UnknownFailure('Could not load Potter characters.');
    }
  }
}
