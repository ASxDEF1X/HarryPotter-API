import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

class ApiClient {
  const ApiClient({required this.client});

  final http.Client client;

  Future<dynamic> getJson(Uri uri) async {
    try {
      final response = await client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerException(
          'Potter API returned ${response.statusCode}.',
          statusCode: response.statusCode,
        );
      }

      return jsonDecode(utf8.decode(response.bodyBytes));
    } on TimeoutException {
      throw const ServerException('Potter API request timed out.');
    } on http.ClientException catch (error) {
      throw ServerException(error.message);
    } on FormatException {
      throw const ParseException('Potter API returned invalid JSON.');
    }
  }
}
