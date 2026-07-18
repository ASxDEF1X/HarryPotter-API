class ApiConstants {
  const ApiConstants._();

  static const host = 'potterapi-fedeperin.vercel.app';
  static const defaultLanguage = 'en';

  static Uri charactersUri({
    String language = defaultLanguage,
    String? search,
  }) {
    final trimmedSearch = search?.trim();
    final query = <String, String>{};

    if (trimmedSearch != null && trimmedSearch.isNotEmpty) {
      query['search'] = trimmedSearch;
    }

    return Uri.https(
      host,
      '/$language/characters',
      query.isEmpty ? null : query,
    );
  }
}
