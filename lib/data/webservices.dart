import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/constants.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  static Map<String, dynamic> getHeaders(lang, token) => {
    'lang': lang,
    'Authorization': token ?? '',
    'Content-Type': 'application/json',
  };

  static Future<dynamic> getData({
    //String url=baseUrl,
   // Map<String, dynamic>? query,

   // String lang = 'en',
    required String input,
    required String sessiontoken,
   // String? token,
  }) async {
   // dio.options.headers = getHeaders(lang, token);
    try {
      Response response = await dio.get(baseUrl, queryParameters:{
        'input': input,
        'key': apiKey,
        'type': 'address',
        'sessiontoken': sessiontoken,
        'components': 'country:eg',
      });
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
  static Future<dynamic> getPlaceDetails({
    //String url=baseUrl,
    // Map<String, dynamic>? query,

    // String lang = 'en',
    required String placeId,
    required String sessiontoken,
    // String? token,
  }) async {
    // dio.options.headers = getHeaders(lang, token);
    try {
      Response response = await dio.get('https://maps.googleapis.com/maps/api/place/details/json', queryParameters:{
        'place_id': placeId,
        'key': apiKey,
        'sessiontoken': sessiontoken,

      });
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //get Places Directions from google developer api with dio instance
  static Future<dynamic> getPlacesDirections({
    //String url=baseUrl,
    // Map<String, dynamic>? query,

    // String lang = 'en',
    required LatLng origin,
    required LatLng destination,
    required String sessiontoken,
    // String? token,
  }) async {
    // dio.options.headers = getHeaders(lang, token);
    try {
      Response response = await dio.get('https://maps.googleapis.com/maps/api/directions/json', queryParameters:{
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': apiKey,
        'sessiontoken': sessiontoken,
      });
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = getHeaders(lang, token);
    return dio
        .post(url, queryParameters: query, data: data)
        .catchError((error) {
      print('DIO CLASS ERROR: $error');
    });
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = getHeaders(lang, token);
    return dio
        .put(
      url,
      data: data,
    )
        .catchError((error) {
      print("DIO ERROR $error");
    });
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = getHeaders(lang, token);
    return dio
        .delete(
      url,
    )
        .catchError((error) {
      print("DIO ERROR $error");
    });
  }

  // static getPolyline({required String encodedPolyline}) {
  //   List<PointLatLng> points = polylinePoints.decodePolyline(encodedPolyline);
  //   List<LatLng> result =
  //       points.map((e) => LatLng(e.latitude, e.longitude)).toList();
  //   return result;
  // }
}