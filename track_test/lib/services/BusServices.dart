import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:track_test/global/env.dart';
import 'package:track_test/model/BusModel.dart';

class BusService {
  Future<List<BusModel>> getbuses() async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL_BACKEND/getBuses"));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        var buses =
            jsonData.map<BusModel>((json) => BusModel.fromJson(json)).toList();
        return buses;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
