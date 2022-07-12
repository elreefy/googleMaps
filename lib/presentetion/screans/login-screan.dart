import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/constants/components.dart';
import 'package:maps/constants/constants.dart';
import '../../business_logic/auth_cubit.dart';

class LoginScrean extends StatelessWidget {

  LoginScrean({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PhoneNumberSubmitted) {
          Navigator.pushNamed(context, '/otp',
              arguments: phoneNumber);
        }
        else if (state is Loading && state is AuthInitial) {
          //widget for progress indicator
          _showProgressIndicator(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 88),
                child: SingleChildScrollView(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildIntroText(),
                      const SizedBox(height: 50),
                      _buildPhoneFormField(context),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          primaryButton(text: 'NEXT', onPressed: () {
                            AuthCubit.get(context).phoneNumberSubmitted();
                          }),
                        ],
                      ),
                      // _buildPhoneNumberSubmittedBloc()
                    ],
                  ),
                ),
              ),
            )
        );
      },
    );
  }

  Widget _buildPhoneFormField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .width / 7,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.lightGrey),
              //color: Colors.grey[400],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(generateCountryFlag() +
                  '  ' +
                  '+20',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: myTextFormField(


            context: context,
            isEmail: true,
            isPassword: false,
          ),
        ),
      ],
    );
  }

  Widget _buildIntroText() {
    return Column(
      children: [
        const Text(
          'what is your phone number plz',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30,
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: const Text(
            'input your phone number plz',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String generateCountryFlag() {
    //return palastine
    return '🇵🇸';
  }

  Widget _showProgressIndicator(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  Widget _buildPhoneNumberSubmittedBloc() {
    return BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => current != previous,
        listener: (context, state) {
          if (state is PhoneNumberSubmitted) {
            print('phoneNumber in compenents is $phoneNumber');
            Navigator.pushNamed(context, '/otp', arguments: phoneNumber);
          }
          else if (state is AuthErrorOccur) {
            print('error in compenents is ${state.error}');
          }
          else if (state is Loading) {
            _showProgressIndicator(context);
          }
        }
    );
  }
}


