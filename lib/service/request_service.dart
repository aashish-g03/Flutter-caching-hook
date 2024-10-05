import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestCacheService<T> {
  final T Function(Map<String, dynamic>) fromJson;

  final Map<String, dynamic> Function(T) toJson;

  RequestCacheService({
    required this.fromJson,
    required this.toJson,
  });

  Stream<T> fetchData(String url) async* {
    final prefs = await SharedPreferences.getInstance();

    //? Check if the data is cached, can use local variable too in case of use case
    if (prefs.containsKey(url)) {
      final cachedDataString = prefs.getString(url);
      if (cachedDataString != null) {
        try {
          // Decode the cached data
          final cachedDataMap = jsonDecode(cachedDataString);
          cachedDataMap['source'] = 'cached';
          final cachedData = fromJson(cachedDataMap);
          yield cachedData;
        } catch (e) {
          // Remove the cached data if it fails to decode
          await prefs.remove(url);
        }
      }
    }

    //? Simulate a delay
    await Future.delayed(const Duration(seconds: 2));

    //? Fetch the data from the network
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dataMap = jsonDecode(response.body);
        dataMap['source'] = 'network';

        //? Decode the data and cache it
        final data = fromJson(dataMap);
        final dataString = jsonEncode(toJson(data));
        await prefs.setString(url, dataString);

        yield data;
      } else {
        throw Exception('Failed to load data from $url');
      }
    } catch (e) {
      yield* Stream.error(e);
    }
  }
}
