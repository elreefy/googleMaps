import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/data/PlaceDetails.dart';
import 'package:meta/meta.dart';
import '../constants/constants.dart';
import '../data/PlacesAutoComplete.dart';
import '../data/PlacesDirectiosModel.dart';
import '../data/webservices.dart';
import '../helper/locationHelper.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  static MapCubit get(context) => BlocProvider.of(context);
  static Position? currentLocation;

  static CameraPosition? myCameraLocation;
  Future<void> getLocation() async {
    emit(MapLoading());
    currentLocation = await LocationService.getLocation().then((value){
      myCameraLocation =  CameraPosition(
        tilt: 0,
        bearing: 0,
        //TODO: My Location
        //  target: LatLng(31.2410354,29.971369),

        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      emit(MapLoaded());
      return value;
    }).catchError((error) {
      emit(MapError(error.toString()));
    });
    print('currentLocation lang: ${currentLocation!.longitude}');
    print('currentLocation lat: ${currentLocation!.latitude}');
  }
  logout(){
    emit(UserSignoutLoading());
    FirebaseAuth.instance.signOut();
    emit(UserSignoutLoaded());
  }
//get autocomplete place from google developer api with dio instance
//   Future<List<Prediction>> getAutoComplete(String input) async {
//     try {
//       Response response = await dio.get(
//         '/autocomplete/json',
//         queryParameters: {
//           'input': input,
//           'key': baseUrl,
//         },
//       );
//       return (response.data['predictions'] as List)
//           .map((e) => Prediction.fromJson(e))
//           .toList();
//     } catch (e) {
//       print(e.toString());
//       return [];
//     }
//   }

  PlacesModel? searchResults;
  List placeDescription= [];
  void search(String query,String sessionToken) async {
    emit(SearchLoading());
    DioHelper.getData(input: query
        ,sessiontoken: sessionToken).then((json) {
      searchResults = PlacesModel.fromJson(json);
     print('placesModel description: ${searchResults!.predictions![0].description}');
     print('place id : ${searchResults!.predictions![0].placeId}');
         searchResults!.predictions!.forEach((element) {
        placeDescription[element.hashCode] = element.description;
   //       productsQuantity[element.product.id] = element.quantity;
      }
      );
    //  cartItemsIds.addAll(productCartIds.values);
      emit(SearchLoaded(searchResults!));
    //  getQuantities();
    }).catchError((error) {
      print('GET placeeees Data ERROR');
      print(error.toString());
      emit(SearchLoaded(searchResults!));
     // emit(ShopErrorCartDataState(error));
    });
  }
  //get place details from google developer api with dio instance
  PlaceDetails? placeDetails;
  Future<void> getPlaceDetails(String placeId,String sessionToken) async {
    emit(DetailsLoading());
    DioHelper.getPlaceDetails(placeId: placeId
        ,sessiontoken: sessionToken).then((json) {
      placeDetails = PlaceDetails.fromJson(json);
      print('MMMMMMMMMY placeDetails Lat: ${placeDetails!.result!.geometry!.location!.lat}');
      print('MMMMMMMMMY placeDetails Lng: ${placeDetails!.result!.geometry!.location!.lng}');
      emit(DetailsLoaded());
      //  cartItemsIds.addAll(productCartIds.values);
      //  getQuantities();
    }).catchError((error) {
      print('Detailssss ERRRRROR');
      print(error.toString());
      emit(DetailsError(error));
      // emit(ShopErrorCartDataState(error));
    });
  }
  //Decode an encoded google polyline string
  // List<LatLng>? polyline;
  // Future<void> getPolyline(String encodedPolyline) async {
  //   emit(DirectionsLoading());
  //   DioHelper.getPolyline(encodedPolyline: encodedPolyline).then((json) {
  //     polylinePoints = PlaceDirections.fromJson(json).polylinePoints as PolylinePoints ;
  //     //polylinePointszzz.decode(json['routes'][0]['overview_polyline']['points']);
  //     //['routes'][0]['overview_polyline']['points']);
  //     // decodePolyline(json['points']);
  //     emit(DirectionsLoaded());
  //     //  cartItemsIds.addAll(productCartIds.values);
  //     //  getQuantities();
  //   }).catchError((error) {
  //     print('Polyline ERRRRROR');
  //     print(error.toString());
  //     emit(DirectionsError(error));
  //     // emit(ShopErrorCartDataState(error));
  //   });
  // }

  //get place direction from google developer api with dio instance

  PlaceDirections? placesDirectionsModel;
Future<void> getPlaceDirection(LatLng origin,LatLng destination,String sessionToken)
async {

    emit(DirectionsLoading());
    DioHelper.getPlacesDirections(
        origin:  origin,
        destination: destination,
        sessiontoken: sessionToken).then((json) {
      placesDirectionsModel = PlaceDirections.fromJson(json);
      print('MMMMMMMMMY placesDirectionsModel Lat: ${placesDirectionsModel!.totalDistance}');
      print('MMMMMMMMMY placesDirectionsModel Lng: ${placesDirectionsModel!.totalDuration}');
      emit(DirectionsLoaded());
      //  cartItemsIds.addAll(productCartIds.values);
      //  getQuantities();
    }).catchError((error) {
      print('Detailssss ERRRRERROR');
      print(error.toString());
    emit(DirectionsError(error));
      // emit(ShopErrorCartDataState(error));
    });
  }
  //todo
//draw line between two markers using flutter polly line directions
//   Polyline? polyline;
//   void drawLine(LatLng origin, LatLng destination) {
//     emit(DrawLineLoading());
//     polyline = Polyline(
//       polylineId: PolylineId('poly'),
//       color: Colors.red,
//       points: [origin, destination],
//       width: 5,
//     );
//     emit(DrawLineLoaded());
//   }






  // Future<void> getPlaceDetails(String placeId) async {
  //   DioHelper.getData(input: input,
  //       sessiontoken: sessiontoken
  //   )
  //   try {
  //     Response response = await dio.get(
  //       '/place/details/json',
  //       queryParameters: {
  //         'place_id': placeId,
  //         'key': baseUrl,
  //       },
  //     );
  //     return PlacesModel.fromJson(response.data);
  //   } catch (e) {
  //     print(e.toString());
  //     return PlacesModel();
  //   }
  // }

}

