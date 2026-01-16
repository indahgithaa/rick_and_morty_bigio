import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final Location origin;
  final Location location;
  final List<String> episode;
  final String url;
  final DateTime created;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.origin,
    required this.location,
    required this.episode,
    required this.url,
    required this.created,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    type,
    gender,
    image,
    origin,
    location,
    episode,
    url,
    created,
  ];
}

class Location extends Equatable {
  final String name;
  final String url;

  const Location({required this.name, required this.url});

  @override
  List<Object?> get props => [name, url];
}
