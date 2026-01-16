import '../../domain/usecases/domain/entities/character.dart';

class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final LocationModel origin;
  final LocationModel location;
  final List<String> episode;
  final String url;
  final DateTime created;

  CharacterModel({
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

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String,
      image: json['image'] as String,
      origin: LocationModel.fromJson(json['origin'] as Map<String, dynamic>),
      location: LocationModel.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      episode: List<String>.from(json['episode'] as List),
      url: json['url'] as String,
      created: DateTime.parse(json['created'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'origin': origin.toJson(),
      'location': location.toJson(),
      'episode': episode,
      'url': url,
      'created': created.toIso8601String(),
    };
  }

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      image: image,
      origin: origin.toEntity(),
      location: location.toEntity(),
      episode: episode,
      url: url,
      created: created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'species': species,
      'gender': gender,
      'status': status,
      'origin': origin.name,
      'location': location.name,
    };
  }

  factory CharacterModel.fromMap(Map<String, dynamic> map) {
    return CharacterModel(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String? ?? '',
      species: map['species'] as String? ?? '',
      type: '',
      gender: map['gender'] as String? ?? '',
      image: map['image'] as String? ?? '',
      origin: LocationModel(name: map['origin'] as String? ?? '', url: ''),
      location: LocationModel(name: map['location'] as String? ?? '', url: ''),
      episode: [],
      url: '',
      created: DateTime.now(),
    );
  }
}

class LocationModel {
  final String name;
  final String url;

  LocationModel({required this.name, required this.url});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url};
  }

  Location toEntity() {
    return Location(name: name, url: url);
  }
}
