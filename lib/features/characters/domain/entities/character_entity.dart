import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  const CharacterEntity({
    required this.fullName,
    required this.nickname,
    required this.hogwartsHouse,
    required this.interpretedBy,
    required this.children,
    required this.image,
    required this.birthdate,
    this.index,
  });

  final int? index;
  final String fullName;
  final String nickname;
  final String hogwartsHouse;
  final String interpretedBy;
  final List<String> children;
  final String image;
  final String birthdate;

  String get displayName => fullName.isEmpty ? nickname : fullName;
  String get displayHouse =>
      hogwartsHouse.isEmpty ? 'Unknown house' : hogwartsHouse;

  @override
  List<Object?> get props => [
    index,
    fullName,
    nickname,
    hogwartsHouse,
    interpretedBy,
    children,
    image,
    birthdate,
  ];
}
