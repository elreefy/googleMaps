import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/business_logic/auth_cubit.dart';
import 'package:maps/business_logic/map_cubit.dart';
import 'package:maps/constants/components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../../constants/constants.dart';
import '../../helper/locationHelper.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  //set of _markers

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
//   static Position? currentLocation;
//intialize FloatingSearchBar Controller
  final searchBarController = FloatingSearchBarController();
  static final Set<Marker> _markers = <Marker>{};

  // FloatingSearchBarController? searchBarController;
  late GoogleMapController _controller;
  static Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  bool timeAndDistanceVisible = false;

  // PolylinePoints polylinePoints = PolylinePoints();

  //var _markers;
  initState() {
    // this is called when the class is initialized or called for the first time

    MapCubit.get(context).getLocation();
    MapCubit.get(context).search('', Uuid().v4());
    super
        .initState(); //  this is the material super constructor for init state to link your instance initState to the global initState context
    /// origin marker
    //   _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
    //       BitmapDescriptor.defaultMarker);

    /// destination marker
//    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
//        BitmapDescriptor.defaultMarkerWithHue(90));
//    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapState>(
      listener: (context, state) {
        if (state is UserSignoutLoaded) {
          Navigator.of(context).pushReplacementNamed('/loginScreen');
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
            //or case
            condition: state is MapLoading

                // ||  state is SearchLoading
                ||
                MapCubit.myCameraLocation == null,

            //  MapCubit.get(context).searchResults == null,
            builder: (context) => Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            fallback: (context) => Scaffold(
                  //show time and distance
                  drawer: myDrawer(context, state),
                  body: Stack(
                    //show time and distance
                    fit: StackFit.expand,
                    children: [
                      GoogleMap(
                        polylines: polylinePoints != null &&
                                MapCubit.get(context).placesDirectionsModel !=
                                    null
                            ? {
                                Polyline(
                                  polylineId: const PolylineId('my_polyline'),
                                  color: Colors.black,
                                  width: 2,
                                  points: polylinePoints!,
                                ),
                              }
                            : {},
                        markers: _markers,
                        initialCameraPosition: MapCubit.myCameraLocation!,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        compassEnabled: false,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              MapCubit.myCameraLocation!,
                            ),
                          );
                        },
                      ),

                      //  buildSearchResults(context,state),
                      _buildFloatingSearchBar(context, state),
                      //show time and distance by using cards
                      timeAndDistanceVisible
                          ? showTimeAndDistance(context)
                          : Container(),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      _controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          MapCubit.myCameraLocation!,
                        ),
                      );
                      // _goToMyCurrentLocation(
                      //     context,
                      //     MapCubit.get(context).myCameraLocation.target);
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ));
      },
    );
  }

// void _goToMyCurrentLocation(BuildContext context, LatLng target) {
//   MapCubit.myCameraLocation = CameraPosition(
//     target: target,
//     zoom: 14,
//   );
//   MapCubit.get(context).getLocation();
// }

//use materail floating search bar to build search bar
  Widget _buildFloatingSearchBar(BuildContext context, state) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
        onFocusChanged: (isFocused) {
          setState(() {
            timeAndDistanceVisible = false;
            //clear polyLines
            polylinePoints?.clear();
          });
        },
        controller: searchBarController,
        hint: 'Search...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 500 : 400,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          final sessionToken = Uuid().v4();
          MapCubit.get(context).search(query, sessionToken);
          // Call your model, bloc, controller here.
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.place),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ConditionalBuilder(
            condition: MapCubit.get(context).searchResults?.predictions ==
                    null &&
                state is SearchLoading &&
                state is MapLoading &&
                state is MapInitial &&
                MapCubit.get(context).searchResults?.predictions?.length == 0,
            builder: (context) => Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            fallback: (context) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: MapCubit.get(context)
                      .searchResults!
                      .predictions!
                      .map((predictions) {
                    return Container(
                      height: 112,
                      child: ListTile(
                        leading: Icon(
                          Icons.place,
                          color: Colors.blue,
                        ),
                        title: Text(
                          '${predictions.description}',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () async {
                          //close floating search bar by using close controller
                          //clear map markers
                          await MapCubit.get(context)
                              .getPlaceDetails(
                                  predictions.placeId!, Uuid().v4())
                              .then((value) {
                            setState(() {
                              _markers.clear();
                              print(
                                  'PLACE ID:FL predictions dh EL mohem dh fl ON tap Lw s7 Yb2a 7lw');
                              print(predictions.placeId);
                              print(
                                  'PLACE ID:FL predictions dh EL mohem dh fl ON tap Lw s7 Yb2a 7lw');
                              print(predictions.description);
                              _controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      // predictions.lat,
                                      // predictions.lng,
                                      MapCubit.get(context)
                                          .placeDetails!
                                          .result!
                                          .geometry!
                                          .location!
                                          .lat!,
                                      MapCubit.get(context)
                                          .placeDetails!
                                          .result!
                                          .geometry!
                                          .location!
                                          .lng!,
                                      //MapCubit.get(context).searchResults!.predictions![0].geometry.location.lat,
                                      //  31.2410354,29.971369
                                      // state.searchResults.predictions[0].geometry.location.lat,
                                      // state.searchResults.predictions[0].geometry.location.lng,
                                    ),
                                    zoom: 14,
                                  ),
                                ),
                              );
                              print(
                                  ' ${MapCubit.get(context).placeDetails!.result!.geometry!.location!.lat!} ${MapCubit.get(context).placeDetails!.result!.geometry!.location!.lng!}');
                              _putMarker(
                                  predictions,
                                  context,
                                  MapCubit.get(context)
                                      .placeDetails!
                                      .result!
                                      .geometry!
                                      .location!
                                      .lat!,
                                  MapCubit.get(context)
                                      .placeDetails!
                                      .result!
                                      .geometry!
                                      .location!
                                      .lng!);

                              searchBarController.close();
                              MapCubit.get(context).getPlaceDirection(
                                  // get description of my current AutofillHints.location
                                  LatLng(MapCubit.currentLocation!.latitude,
                                      MapCubit.currentLocation!.longitude),
                                  LatLng(
                                    MapCubit.get(context)
                                        .placeDetails!
                                        .result!
                                        .geometry!
                                        .location!
                                        .lat!,
                                    MapCubit.get(context)
                                        .placeDetails!
                                        .result!
                                        .geometry!
                                        .location!
                                        .lng!,
                                  ),
                                  Uuid().v4());
                            });
                          });
                          // MapCubit.currentLocation =  await LatLng(
                          //   MapCubit.get(context).placeDetails!.result!.geometry!.location!.lat!,
                          //   MapCubit.get(context).placeDetails!.result!.geometry!.location!.lng!,
                          // ) as Position?;
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }

  myDrawer(BuildContext context,  state) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //add image here
                Text(
                  'ahmed hossam',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BlocProvider(
                  create: (context) => AuthCubit(),
                  child: Text(
                    '${AuthCubit.get(context).getloggedInUser().phoneNumber}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.home),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: buildDrawerItem(
              context: context,
              icon: Icons.history,
              text: 'places history',
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: buildDrawerItem(
              context: context,
              icon: Icons.settings,
              text: 'Settings',
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: buildDrawerItem(
              context: context,
              icon: Icons.help,
              text: 'help',
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          BlocProvider(
            create: (context) => MapCubit(),
            child: ListTile(
              title: buildDrawerItem(
                context: context,
                icon: Icons.exit_to_app,
                text: 'logout',
                tailingShown: false,
                iconColor: Colors.red,
              ),
              onTap: () async {
                await MapCubit.get(context).logout();
               // TODO:dh a5er t3deeel
                if (state is UserSignoutLoaded  ) {
                  Navigator.pop(context);
                }
                //clear polyLinesPoints
                polylinePoints?.clear();
                //clear markers
                _markers.clear();

              },
            ),
          ),
          Spacer(),
          //import url launcher to open url in browser
          //import flutter awesome to show awesome icon
          // build social media icons here
          SizedBox(
            height: 160,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              'Contact us :',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey),
            ),
          ),
          _buidSocialMediaIcons(context),
        ],
      ),
    );
  }

  Widget _buidSocialMediaIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(FontAwesomeIcons.facebook),
          onPressed: () {
            launch('https://www.facebook.com/');
          },
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.twitter),
          onPressed: () {
            launch('https://twitter.com/');
          },
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.instagram),
          onPressed: () {
            launch('https://www.instagram.com/');
          },
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.youtube),
          onPressed: () {
            launch('https://www.youtube.com/');
          },
        ),
      ],
    );
  }

  void _putMarker(prediction, BuildContext context, double d, double e) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('myMarker'),
        position: LatLng(d, e),
        infoWindow: InfoWindow(
          //max lines of text in info window
          title: '${prediction.description}',
          onTap: () {
            print(''
                ''
                ''
                'dh description bta3 marker ${prediction.description}');
            _putMarkeromCurrentLocation(prediction, context, d, e);
            _getPolyline();
            setState(() {
              timeAndDistanceVisible = true;
            });

            //  MapCubit.get(context).getPolyline(
            //     MapCubit.get(context).placesDirectionsModel!.routes![0].overviewPolyline!.points!,
            //   );
            // drawLine(LatLng origin, LatLng destination);
          },
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _putMarkeromCurrentLocation(
      prediction, BuildContext context, double d, double e) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(MapCubit.currentLocation!.latitude,
            MapCubit.currentLocation!.longitude),

        //todo: zabt kol el lat wl long
        //  LatLng(MapCubit.currentLocation!.longitude,
        //    MapCubit.currentLocation!.altitude,
        //      ),
        infoWindow: InfoWindow(
          //max lines of text in info window
          title: 'hi',
          onTap: () {},
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

//get polyline from by Decode an encoded google polyline string

// _getPolyline() async {z
//   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       apiKey,
//       PointLatLng(MapCubit.currentLocation!.latitude,
//           MapCubit.currentLocation!.longitude),
//       PointLatLng(
//         MapCubit
//             .get(context)
//             .placeDetails!
//             .result!
//             .geometry!
//             .location!
//             .lat!,
//         MapCubit
//             .get(context)
//             .placeDetails!
//             .result!
//             .geometry!
//             .location!
//             .lng!,
//       ),
//       //   PointLatLng(_originLatitude, _originLongitude),
//       //   PointLatLng(_destLatitude, _destLongitude),
//       travelMode: TravelMode.driving,
//       wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
//   if (result.points.isNotEmpty) {
//     result.points.forEach((PointLatLng point) {
//       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//     });
//   }
//   _addPolyLine();
// }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() {
    polylinePoints = MapCubit.get(context)
        .placesDirectionsModel!
        .polylinePoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  _showTimeAndDistance() {
    return Column(
      children: [
        Text(
          '${MapCubit.get(context).placesDirectionsModel!.totalDuration}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ),
        Text(
          '${MapCubit.get(context).placesDirectionsModel!.totalDistance}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  showTimeAndDistance(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        bottom: 520.0,
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.black,
                  ),
                  Text(
                    '${MapCubit.get(context).placesDirectionsModel!.totalDuration}',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    color: Colors.black,
                  ),
                  Text(
                    '${MapCubit.get(context).placesDirectionsModel!.totalDistance}',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_ShowProgressIndicator() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
