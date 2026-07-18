import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/characters_bloc.dart';
import '../widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    context.read<CharactersBloc>().add(
      CharactersSearchSubmitted(_searchController.text),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<CharactersBloc>().add(const CharactersRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Potter Characters')),
      body: BlocConsumer<CharactersBloc, CharactersState>(
        listenWhen: (previous, current) =>
            current.status == CharactersStatus.failure &&
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          final message = state.errorMessage;
          if (message == null) {
            return;
          }

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        },
        builder: (context, state) {
          return Column(
            children: [
              _SearchHeader(
                controller: _searchController,
                isLoading: state.isLoading,
                onClear: _clearSearch,
                onSearch: _submitSearch,
              ),
              Expanded(child: _CharactersContent(state: state)),
            ],
          );
        },
      ),
    );
  }
}

class _SearchHeader extends StatefulWidget {
  const _SearchHeader({
    required this.controller,
    required this.isLoading,
    required this.onClear,
    required this.onSearch,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onClear;
  final VoidCallback onSearch;

  @override
  State<_SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<_SearchHeader> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant _SearchHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }

    oldWidget.controller.removeListener(_onTextChanged);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                enabled: !widget.isLoading,
                onSubmitted: (_) => widget.onSearch(),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search character',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: hasText
                      ? IconButton(
                          tooltip: 'Clear',
                          onPressed: widget.isLoading ? null : widget.onClear,
                          icon: const Icon(Icons.close),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox.square(
              dimension: 56,
              child: FilledButton(
                onPressed: widget.isLoading ? null : widget.onSearch,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: widget.isLoading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharactersContent extends StatelessWidget {
  const _CharactersContent({required this.state});

  final CharactersState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.characters.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CharactersStatus.failure && state.characters.isEmpty) {
      return _StateMessage(
        icon: Icons.cloud_off_outlined,
        title: 'Could not load characters',
        message: state.errorMessage ?? 'Please try again.',
      );
    }

    if (state.characters.isEmpty) {
      return _StateMessage(
        icon: Icons.search_off,
        title: state.hasQuery ? 'No matches found' : 'No characters found',
        message: state.hasQuery ? '"${state.query}" returned no results.' : '',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: state.characters.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return CharacterCard(character: state.characters[index]);
      },
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF5B635F),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
