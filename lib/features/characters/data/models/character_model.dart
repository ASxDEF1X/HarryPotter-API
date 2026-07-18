import '../../domain/entities/character_entity.dart';

class CharacterModel extends CharacterEntity {
  const CharacterModel({
    required super.fullName,
    required super.nickname,
    required super.hogwartsHouse,
    required super.interpretedBy,
    required super.children,
    required super.image,
    required super.birthdate,
    super.index,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      index: _intOrNull(json['index']),
      fullName: _stringOrEmpty(json['fullName']),
      nickname: _stringOrEmpty(json['nickname']),
      hogwartsHouse: _stringOrEmpty(json['hogwartsHouse']),
      interpretedBy: _stringOrEmpty(json['interpretedBy']),
      children: _children(json['children']),
      image: _stringOrEmpty(json['image']),
      birthdate: _stringOrEmpty(json['birthdate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'fullName': fullName,
      'nickname': nickname,
      'hogwartsHouse': hogwartsHouse,
      'interpretedBy': interpretedBy,
      'children': children,
      'image': image,
      'birthdate': birthdate,
    };
  }

  static String _stringOrEmpty(Object? value) {
    return value is String ? value : '';
  }

  static int? _intOrNull(Object? value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static List<String> _children(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value
        .where((child) => child != null)
        .map((child) => child.toString())
        .toList(growable: false);
  }
}
