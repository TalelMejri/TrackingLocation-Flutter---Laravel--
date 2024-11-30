import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:track_test/global/env.dart';
import 'package:track_test/model/BikeModel.dart';

class BusService {
  Future<List<BikeModel>> getBikes() async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL_BACKEND/getBikes"));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        var bikes =
            jsonData.map<BikeModel>((json) => BikeModel.fromJson(json)).toList();
        return bikes;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<BikeModel> getBikeById(id) async {
    var bikes;
    try {
      final response =
          await http.get(Uri.parse("$BASE_URL_BACKEND/getBikeById/$id"));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        var bikes = BikeModel.fromJson(jsonData);
        return bikes;
      } else {
        return bikes;
      }
    } catch (e) {
      return bikes;
    }
  }
}
