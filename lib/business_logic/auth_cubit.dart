import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../constants/components.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
static String? verificationIdd;
static UserCredential? user;
//TODO:b7ot b edy il verification id bysht8al
//TODO:verification id not intialized
 //'AJOnW4SNznZa-v4hFItuMCERY62xGwUMLlRaKyTC7RzHxpm_6jdXUua0iVSlvkNgaR03FAaZxC9wGJDftOjQeG3vXNpamudPvpi2DfxBOYjW__xzswgH7nNQYw8ZFTpjMHTlOvOnCHSLbmLZ2YSbLHNQtgYBax_3RRicfjlCYk2ESVEaG22frWya7gCEe4bdJcQfRX7enedGUx6CaYXlqOs9NHFcEdwpOk83wfDFJCZPru-4dUZw9iQ';
 //'AJOnW4QOeiOExo9f1IEYXjxwGmr8_f0WYHWuwH-dVOCTlx0QXHQa4c8p9eqD41LCVYy-A3gIY-65yuiYOpO68RyQkb1ur6kqixVrWqGlbIz1UodL1FCjvTcWHMnZILfPGeydVpOt1nc9U-Zvu3cqrAP2MIvgtbspxW7GOVgRfxqORIkm4Z3po7oT5Y3gnEe_niLC8egOC43ex3l9jnAn3FRbiB77MFNXX0lhKFSceJH7QMLi04wBE9M';
 //   'AJOnW4TxkzmJhhdK_W8sJ64PFdq9FeWy_y4MmRvc4hkC52C5K5FRTQ8ouNEU1By1T8pWwntEf877QzZsXyIk2Z-0Af1JlIWwFW_3hyOgOurV5XGHzyvtzXluA2PCYvK2r8HgXsmrn9HxAknwRWd4_QDkBa9DLOmbXQGQRLqA33jUPVOpyrw1N1gM7mZ9IimyaluUxUgX1oNoK2s_lzOteci41bdRmjTgdhF2nTwpvooTEsRTRub7YII';
  AuthCubit() : super(AuthInitial());
static AuthCubit get(context) => BlocProvider.of(context);

Future<void> phoneNumberSubmitted()async {
  emit(Loading());
  print('ANA MOGOOOOOD');
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: '+2$phoneNumber',
    verificationCompleted:  _verificationCompleted(),
    verificationFailed:  _verificationFailed(),
    codeSent:await _codeSent(),
    codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout(),
  );
  //TODO: add state for success
  emit(PhoneNumberSubmitted());
}
Future<void> otpSubmitted (String otp) async {
  emit(OTPLoading());
  print('MY VERIFIACATION ID: $verificationIdd');
  final AuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationIdd!,
    smsCode: otp,
  );
    user = await FirebaseAuth.instance.signInWithCredential(
    credential,
  );
  emit(OtpVerified());
}
_codeSent() async{
  return   (String verificationId, [int? forceResendingToken]) {
    print('MY code sent');
    print(verificationId);
    print('MY TOKEN');
    print(forceResendingToken);
 verificationIdd=verificationId;
  };

}

  _verificationCompleted()  {
    return (AuthCredential credential) {
      print('My verification completed');
      print(credential);
      emit(OtpVerified());
    };
  }
  _verificationFailed()  {
    return (exception) {
      print('My verification failed');
      print(exception);
      emit(AuthErrorOccur(exception.message));
    };
  }
  _codeAutoRetrievalTimeout()  {
    return (String verificationId) {
      print('MY code auto retrieval timeout');
      print(verificationId);
      emit(AuthErrorOccur('MY code auto retrieval timeout'));

    };
  }
    User getloggedInUser(){
       User user=FirebaseAuth.instance.currentUser!;
        return user;
  }

}




