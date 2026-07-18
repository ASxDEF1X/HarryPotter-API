import 'package:flutter/material.dart';

import '../../domain/entities/character_entity.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({required this.character, super.key});

  final CharacterEntity character;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE0E5E2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CharacterImage(imageUrl: character.image),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          character.displayName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF16201C),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _HouseBadge(house: character.displayHouse),
                    ],
                  ),
                  if (character.nickname.isNotEmpty &&
                      character.nickname != character.fullName) ...[
                    const SizedBox(height: 4),
                    Text(
                      character.nickname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF5B635F),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _MetaRow(
                    icon: Icons.theater_comedy_outlined,
                    text: character.interpretedBy.isEmpty
                        ? 'Actor unknown'
                        : character.interpretedBy,
                  ),
                  if (character.birthdate.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _MetaRow(
                      icon: Icons.cake_outlined,
                      text: character.birthdate,
                    ),
                  ],
                  if (character.children.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _MetaRow(
                      icon: Icons.family_restroom_outlined,
                      text: character.children.join(', '),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterImage extends StatelessWidget {
  const _CharacterImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 88,
        height: 112,
        child: imageUrl.isEmpty
            ? const _ImagePlaceholder()
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _ImagePlaceholder(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }

                  return const _ImagePlaceholder(showProgress: true);
                },
              ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.showProgress = false});

  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8ECE9),
      child: Center(
        child: showProgress
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.person_outline, color: Color(0xFF6B756F)),
      ),
    );
  }
}

class _HouseBadge extends StatelessWidget {
  const _HouseBadge({required this.house});

  final String house;

  @override
  Widget build(BuildContext context) {
    final color = _houseColor(house);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          house,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Color _houseColor(String value) {
    switch (value.toLowerCase()) {
      case 'gryffindor':
        return const Color(0xFF8D2731);
      case 'slytherin':
        return const Color(0xFF226B4D);
      case 'ravenclaw':
        return const Color(0xFF2E5C88);
      case 'hufflepuff':
        return const Color(0xFF8A690E);
      default:
        return const Color(0xFF5B635F);
    }
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF6B756F)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF3E4742)),
          ),
        ),
      ],
    );
  }
}
