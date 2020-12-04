import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'dart:async';
import 'dart:io';

class SearchSuggestions {
  String id;
  String name;
  String address;
  String director;
  String stir;
  String ktut;
  String email;
  String phone1;
  String phone2;

  SearchSuggestions({
    this.id,
    this.name,
    this.address,
    this.director,
    this.stir,
    this.ktut,
    this.email,
    this.phone1,
    this.phone2,
  });

  factory SearchSuggestions.fromJson(Map<String, dynamic> parsedJson) {
    return SearchSuggestions(
      id: parsedJson['id'] as String,
      name: parsedJson['g1'] as String,
      address: parsedJson['g2'] as String,
      director: parsedJson['g3'] as String,
      stir: parsedJson['g4'] as String,
      ktut: parsedJson['g5'] as String,
      email: parsedJson['g6'] as String,
      phone1: parsedJson['g7'] as String,
      phone2: parsedJson['g8'] as String,
    );
  }
}

class SearchSuggestionsClass {
  static List<SearchSuggestions> searchSuggestions;

  static Future loadSearchSuggestions(int a) async {
    try {
      Dio dio = new Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      Response responseV = await dio.get(
        'https://data.gov.uz/ru/api/v1/json/dataset/' +
            a.toString() +
            '/version?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
      );

      final jsonDataV = json.decode(responseV.data);

      Response response = await dio.get(
        'https://data.gov.uz/uz/api/v1/json/dataset/' +
            a.toString() +
            '/version/' +
            jsonDataV[jsonDataV.length - 1]['id'].toString() +
            '?access_key=a8ca4fe6c9d7d91959cf56c50012eb6a',
      );
      searchSuggestions = new List<SearchSuggestions>();

      final parsedJson = json.decode(response.data);

      for (int i = 0; i < parsedJson.length; i++) {
        searchSuggestions.add(new SearchSuggestions.fromJson(parsedJson[i]));
      }
      print("AAAAAAAAAAAAAAAAAA");
    } catch (e) {
      print(e);
    }
  }
}
