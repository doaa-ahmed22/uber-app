
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_application/business_logic_layer/phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verificationId;

  PhoneAuthCubit() : super(PhoneAuthInitial());

//enter the correct number
  Future<void> submittedPhoneNumber(String phoneNumber) async {
    emit(Loading());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2 $phoneNumber',
      timeout: const Duration(seconds: 14),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  //the device enter the code Automatic
  void verificationCompleted(PhoneAuthCredential credential) async {
    print(verificationCompleted);
    await signIn(credential);
  }

//invalid phone numbers or whether the SMS quota
  void verificationFailed(FirebaseException exception) {
    emit(ErrorOccurred(errorMessage: exception.toString()));
    print(verificationFailed);
    print(exception.toString());
  }

  //when a code has been sent to the device from Firebase
  void codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    print(codeSent);
    emit(PhoneNumberSubmitted());
  }

//Handle a timeout of when automatic SMS code handling fails
  void codeAutoRetrievalTimeout(String verificationId) {
    print(codeAutoRetrievalTimeout);
  }

  //the code coming
  Future<void> submittedOtp(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId:this.verificationId, smsCode: otpCode);
    await signIn(credential);
  }

//the user enter the correct SMS
  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOTPVerified());
    } catch (error) {
      emit(ErrorOccurred(errorMessage: error.toString()));
      print(error.toString());
    }
  }

  //the user want to sign out
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
//the currentUser
 User currentUser(){
   return FirebaseAuth.instance.currentUser!;
 }
}
