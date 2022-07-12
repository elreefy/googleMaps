part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class Loading extends AuthState {}
class AuthErrorOccur extends AuthState {
final String error;
  AuthErrorOccur(this.error);
}
class PhoneNumberSubmitted extends AuthState {}
class OtpVerified extends AuthState {}
class OTPLoading extends AuthState {}
