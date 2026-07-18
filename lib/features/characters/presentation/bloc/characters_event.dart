part of 'characters_bloc.dart';

sealed class CharactersEvent extends Equatable {
  const CharactersEvent();

  @override
  List<Object?> get props => const [];
}

final class CharactersRequested extends CharactersEvent {
  const CharactersRequested({this.language = 'en'});

  final String language;

  @override
  List<Object?> get props => [language];
}

final class CharactersSearchSubmitted extends CharactersEvent {
  const CharactersSearchSubmitted(this.query, {this.language = 'en'});

  final String query;
  final String language;

  @override
  List<Object?> get props => [query, language];
}
