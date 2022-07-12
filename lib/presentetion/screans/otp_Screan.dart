import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../business_logic/auth_cubit.dart';
import '../../constants/components.dart';

class OtpScrean extends StatelessWidget {
  
  OtpScrean({Key? key, required this.data}) : super(key: key);
  String data;
  late String otp;
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is OtpVerified) {
      Navigator.pushNamed(context, '/homeScrean');

    }
    else if (state is OTPLoading) {
      //widget for progress indicator
      _showProgressIndicator(context);
    }
  },
  builder: (context, state) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
              ),
              Text(
                'Verify Your Phome Number',
                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
               Text(
                'Enter your 6 digit Phome Number Sent to ${data}',
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.grey),
               ),
              const SizedBox(height: 40),
               _pinCodeField(context),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  primaryButton(text: 'VERIFY', onPressed: () {
                    AuthCubit.get(context).otpSubmitted(otp);
                  }),
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Didn\'t receive the code?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Resend Code',
                      style: TextStyle(fontSize: 15,color: Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Change Number',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ],
                ),
              ),


  ],
          ),
        ),
      ),
    );
  },
);
  }

 Widget _pinCodeField(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7,
      child: PinCodeTextField(
        animationType: AnimationType.slide,
        animationCurve: Curves.linear,
        length: 6,
        onChanged: (String otp) {
          print('otp value is $otp');
          this.otp=otp;
          },
         appContext: context,
   ),
    );
 }
  Widget _showProgressIndicator(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
