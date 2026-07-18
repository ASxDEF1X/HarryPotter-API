import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'features/characters/data/datasources/characters_remote_data_source.dart';
import 'features/characters/data/repositories/characters_repository_impl.dart';
import 'features/characters/domain/repositories/characters_repository.dart';
import 'features/characters/domain/usecases/get_characters.dart';
import 'features/characters/domain/usecases/search_characters.dart';
import 'features/characters/presentation/bloc/characters_bloc.dart';
import 'features/characters/presentation/pages/characters_page.dart';

class PotterApiApp extends StatelessWidget {
  const PotterApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<http.Client>(
          create: (_) => http.Client(),
          dispose: (client) => client.close(),
        ),
        RepositoryProvider<ApiClient>(
          create: (context) => ApiClient(client: context.read<http.Client>()),
        ),
        RepositoryProvider<CharactersRemoteDataSource>(
          create: (context) => CharactersRemoteDataSourceImpl(
            apiClient: context.read<ApiClient>(),
          ),
        ),
        RepositoryProvider<CharactersRepository>(
          create: (context) => CharactersRepositoryImpl(
            remoteDataSource: context.read<CharactersRemoteDataSource>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final repository = context.read<CharactersRepository>();

          return BlocProvider(
            create: (_) => CharactersBloc(
              getCharacters: GetCharacters(repository),
              searchCharacters: SearchCharacters(repository),
            )..add(const CharactersRequested()),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Potter Characters',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF2E7D5B),
                ),
                scaffoldBackgroundColor: const Color(0xFFF6F7F9),
                appBarTheme: const AppBarTheme(
                  centerTitle: false,
                  backgroundColor: Color(0xFFF6F7F9),
                  foregroundColor: Color(0xFF16201C),
                  surfaceTintColor: Colors.transparent,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2E7D5B)),
                  ),
                ),
              ),
              home: const CharactersPage(),
            ),
          );
        },
      ),
    );
  }
}
