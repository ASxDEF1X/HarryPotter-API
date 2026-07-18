class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
