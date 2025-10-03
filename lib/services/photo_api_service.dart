import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/photo.dart';

class PhotoApiService {
  Future<List<Photo>> fetchArtPhotos() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/gallery_arts.json',
      );
      return compute(parsePhotos, jsonString);
    } catch (e) {
      return [];
    }
  }

  Future<List<Photo>> fetchBuildingPhotos() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/gallery_buildings.json',
      );
      return compute(parsePhotos, jsonString);
    } catch (e) {
      return [];
    }
  }

  Future<List<Photo>> fetchDancePhotos() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/gallery_dances.json',
      );
      return compute(parsePhotos, jsonString);
    } catch (e) {
      return [];
    }
  }

  Future<List<Photo>> fetchOtherPhotos() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/gallery_others.json',
      );
      return compute(parsePhotos, jsonString);
    } catch (e) {
      return [];
    }
  }

  Future<List<Photo>> parsePhotos(String jsonString) async {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Photo.fromJson(json)).toList();
  }

}
