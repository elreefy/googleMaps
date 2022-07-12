import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/business_logic/auth_cubit.dart';
import 'package:maps/presentetion/screans/MapScrean.dart';
import 'package:maps/presentetion/screans/login-screan.dart';
import 'package:maps/presentetion/screans/otp_Screan.dart';

import 'constants/constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case loginScrean:
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => AuthCubit(),
              child: LoginScrean(),
            ));
      case Otp:
      // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) =>
                BlocProvider(
                  create: (context) => AuthCubit(),
                  child: OtpScrean(
                    data: args,
                  ),
                ),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorOtp();
      case homeScrean:
          return MaterialPageRoute(
            builder: (_) =>
                 MapScreen(

                ),
          );

        return _errorRoute();
      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }
  static Route<dynamic> _errorOtp() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('otp'),
        ),
        body: Center(
          child: Text('otp'),
        ),
      );
    });
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}