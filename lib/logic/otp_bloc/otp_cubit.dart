import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_states.dart';

class OtpCubit extends Cubit<OtpStates> {
  OtpCubit() : super(OtpInitialState());
  late String verificationId;

  static OtpCubit get(context) => BlocProvider.of(context);

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(OtpLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+996$phoneNumber',
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout');
  }

  void codeSent(String verificationId, int? resendToken) {
    print('code sent');
    this.verificationId = verificationId;
    emit(PhoneNumberSubmittedState());
  }

  void verificationFailed(FirebaseAuthException error) {
    emit(OtpErrorState(error.toString()));
    print('error occurred: ${error.toString()}');
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('PhoneAuthCompleted');
    await SignIn(credential);
  }

  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: this.verificationId,
      smsCode: otpCode,
    );
    await SignIn(credential);
  }

  Future<void> SignIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(OTPVerifiedState());
    } catch (error) {
      emit(OtpErrorState(error.toString()));
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    return FirebaseAuth.instance.currentUser!;
  }
}
