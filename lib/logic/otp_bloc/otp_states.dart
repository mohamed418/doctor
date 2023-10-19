abstract class OtpStates{}

class OtpInitialState extends OtpStates{}

class OtpLoadingState extends OtpStates{}

class OtpErrorState extends OtpStates{
  final String error;

  OtpErrorState(this.error);
}

class PhoneNumberSubmittedState extends OtpStates{}
class OTPVerifiedState extends OtpStates{}

// abstract class AuthStates{}
//
// class AuthInitialState extends AuthStates{}
//
// class AuthLoadingState extends AuthStates{}
//
// class AuthSuccessState extends AuthStates{}
//
// class AuthErrorState extends AuthStates{
//   final String error;
//
//   AuthErrorState(this.error);
// }
//
// class PhoneNumberSubmittedState extends AuthStates{}
// class OTPVerifiedState extends AuthStates{}
