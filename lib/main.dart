import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/presentetion/screans/MapScrean.dart';
import 'package:uuid/uuid.dart';
//import 'firebase_options.dart';
import 'app-router.dart';
import 'business_logic/CubitObserver.dart';
import 'business_logic/auth_cubit.dart';
import 'business_logic/map_cubit.dart';
import 'data/webservices.dart';
late String intialRoute;
void main() async{
  //function for init firebase_core
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await Firebase.initializeApp(  );
  FirebaseAuth.instance.authStateChanges().listen((value) {
    if (value != null ) {
      intialRoute = '/homeScrean';
    } else {
      intialRoute = '/loginScreen';
    }
  });
  BlocOverrides.runZoned(() => runApp(const MyApp())
      ,blocObserver: MyBlocObserver());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
        providers: [
          BlocProvider<MapCubit>(
            create: (context) => MapCubit()
              ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(),
          ),
        ],
        child: MaterialApp(debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

      //home: MapScreen(),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: intialRoute,
        ),
      );
  }
}
