import 'package:dio/dio.dart';
import 'package:rick_and_morty_app/src/core/network/api_exception.dart';

import '../models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharacters(int page);
  Future<CharacterModel> getCharacterDetail(int id);
  Future<List<CharacterModel>> searchCharacters(
    String query, {
    String? status,
    String? species,
    String? gender,
  });
  Future<List<CharacterModel>> filterByLocation(String location);
  Future<List<CharacterModel>> filterByEpisode(int episodeId);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CharacterModel>> getCharacters(int page) async {
    try {
      final response = await dio.get(
        '/character',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => CharacterModel.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to fetch characters');
      }
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Network error occurred');
    }
  }

  @override
  Future<CharacterModel> getCharacterDetail(int id) async {
    try {
      final response = await dio.get('/character/$id');

      if (response.statusCode == 200) {
        return CharacterModel.fromJson(response.data);
      } else {
        throw ApiException('Failed to fetch character detail');
      }
    } on DioException catch (e) {
      throw ApiException(e.message ?? 'Network error occurred');
    }
  }

  @override
  Future<List<CharacterModel>> searchCharacters(
    String query, {
    String? status,
    String? species,
    String? gender,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      if (query.isNotEmpty) {
        queryParameters['name'] = query;
      }
      if (status != null) {
        queryParameters['status'] = status;
      }
      if (species != null) {
        queryParameters['species'] = species;
      }
      if (gender != null) {
        queryParameters['gender'] = gender;
      }

      final response = await dio.get(
        '/character',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) => CharacterModel.fromJson(json)).toList();
      } else {
        throw ApiException('No characters found');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ApiException(e.message ?? 'Network error occurred');
    }
  }

  @override
  Future<List<CharacterModel>> filterByLocation(String location) async {
    try {
      final locationResponse = await dio.get(
        '/location',
        queryParameters: {'name': location},
      );

      if (locationResponse.statusCode == 200) {
        final locations = locationResponse.data['results'] as List;
        if (locations.isEmpty) return [];

        final firstLocation = locations.first;
        final residentUrls = List<String>.from(firstLocation['residents']);

        if (residentUrls.isEmpty) return [];

        final characterIds = residentUrls
            .map((url) => url.split('/').last)
            .where((id) => id.isNotEmpty)
            .toList();

        if (characterIds.isEmpty) return [];

        final response = await dio.get('/character/${characterIds.join(',')}');

        if (response.statusCode == 200) {
          if (response.data is List) {
            return (response.data as List)
                .map((json) => CharacterModel.fromJson(json))
                .toList();
          } else {
            return [CharacterModel.fromJson(response.data)];
          }
        }
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ApiException(e.message ?? 'Network error occurred');
    }
  }

  @override
  Future<List<CharacterModel>> filterByEpisode(int episodeId) async {
    try {
      final episodeResponse = await dio.get('/episode/$episodeId');

      if (episodeResponse.statusCode == 200) {
        final characterUrls = List<String>.from(
          episodeResponse.data['characters'],
        );

        if (characterUrls.isEmpty) return [];

        final characterIds = characterUrls
            .map((url) => url.split('/').last)
            .where((id) => id.isNotEmpty)
            .toList();

        if (characterIds.isEmpty) return [];

        final response = await dio.get('/character/${characterIds.join(',')}');

        if (response.statusCode == 200) {
          if (response.data is List) {
            return (response.data as List)
                .map((json) => CharacterModel.fromJson(json))
                .toList();
          } else {
            return [CharacterModel.fromJson(response.data)];
          }
        }
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw ApiException(e.message ?? 'Network error occurred');
    }
  }
}
