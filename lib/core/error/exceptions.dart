class ServerException implements Exception {
  const ServerException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ParseException implements Exception {
  const ParseException(this.message);

  final String message;

  @override
  String toString() => message;
}
