import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
const String loginScrean = '/loginScreen';
const String Otp = '/otp';
const String homeScrean = '/homeScrean';
const String apiKey = 'AIzaSyDkX6jX93isNgcXBhPvEP5qJJy9CVBgjnQ';
const String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
const String placeDetailsUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng>? polylinePoints;

class MyColors {
  static const String primary = '#2196f3';
  static const String primaryDark = '#1976d2';
  static const String primaryLight = '#e3f2fd';
  static const String accent = '#ff4081';
  static const String accentDark = '#ff4081';
  static const String accentLight = '#ff4081';
  static const String error = '#f44336';
  static const String errorDark = '#d32f2f';
  static const String errorLight = '#f8bdb0';
  static const String warning  = '#ff9800';
  static const Color myBlue    = Color(0xff0666EB);
  static const Color lightBlue = Color(0xffE5EFFD);
  static const Color lightGrey = Color(0xffE1E1E1);
}