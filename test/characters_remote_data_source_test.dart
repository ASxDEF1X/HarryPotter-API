import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:potter_api_flutter/core/network/api_client.dart';
import 'package:potter_api_flutter/features/characters/data/datasources/characters_remote_data_source.dart';
import 'package:potter_api_flutter/features/characters/data/models/character_model.dart';

void main() {
  test('CharacterModel parses Potter API character fields', () {
    final model = CharacterModel.fromJson(const {
      'index': 0,
      'fullName': 'Harry James Potter',
      'nickname': 'Harry',
      'hogwartsHouse': 'Gryffindor',
      'interpretedBy': 'Daniel Radcliffe',
      'children': [
        'James Sirius Potter',
        'Albus Severus Potter',
        'Lily Luna Potter',
      ],
      'image': 'https://example.com/harry.png',
      'birthdate': 'Jul 31, 1980',
    });

    expect(model.index, 0);
    expect(model.fullName, 'Harry James Potter');
    expect(model.children, hasLength(3));
    expect(model.displayHouse, 'Gryffindor');
  });

  test('remote data source sends the search query to Potter API', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'potterapi-fedeperin.vercel.app');
      expect(request.url.path, '/en/characters');
      expect(request.url.queryParameters['search'], 'Weasley');

      return http.Response(
        jsonEncode([
          {
            'index': 1,
            'fullName': 'Ron Weasley',
            'nickname': 'Ron',
            'hogwartsHouse': 'Gryffindor',
            'interpretedBy': 'Rupert Grint',
            'children': <String>[],
            'image': 'https://example.com/ron.png',
            'birthdate': 'Mar 1, 1980',
          },
        ]),
        200,
        headers: const {'content-type': 'application/json'},
      );
    });

    final dataSource = CharactersRemoteDataSourceImpl(
      apiClient: ApiClient(client: client),
    );

    final characters = await dataSource.getCharacters(search: 'Weasley');

    expect(characters, hasLength(1));
    expect(characters.single.fullName, 'Ron Weasley');
  });
}
