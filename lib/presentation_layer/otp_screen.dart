import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:uber_application/constans/colors.dart';
import 'package:uber_application/constans/strings.dart';

import '../business_logic_layer/phone_auth_cubit.dart';
import '../business_logic_layer/phone_auth_state.dart';

class OtpScreen extends StatelessWidget {
 final phoneNumber;

late String otpCode;

  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 88, horizontal: 32),
          child: Column(
            children: [
              _buildIntroText(),
              const SizedBox(height: 80),
              _buildPinCodeField(context),
              const SizedBox(height: 60),
              _buildVerifyButton(context),
              buildPhoneVerificationBloc(),
            ],
          ),
        ),
      ),
    );
  }
 Widget buildPhoneVerificationBloc(){
   return BlocListener<PhoneAuthCubit,PhoneAuthState>(
     listenWhen: (previous, current) {
       return previous != current;
     },
     listener: (context, state) {
       if (state is Loading) {
         showProgressIndicator(context);
       }
       if (state is ErrorOccurred) {
         // Navigator.pop(context);
         String errorMes = (state).errorMessage;
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text(errorMes),
             backgroundColor: Colors.grey,
             duration: const Duration(seconds: 5),
           ),

         );

       }
       if (state is PhoneOTPVerified) {
         Navigator.pop(context);
         Navigator.of(context).pushReplacementNamed(mapRoad);
       }
     },
     child: Container(),
   );
 }

  Widget _buildIntroText() {
    return Column(
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
                text: 'Enter your 6 digit code numbers sent for ',
                style:
                    const TextStyle(color: Colors.black, fontSize: 18, height: 1.4),
                children: <TextSpan>[
                  TextSpan(
                      text: phoneNumber,
                      style: const TextStyle(color: MyPrivateColor.blue)),
                ]),
          ),
        ),
      ],
    );
  }
 void showProgressIndicator(BuildContext context) {
   AlertDialog alertDialog = AlertDialog(
     backgroundColor: Colors.transparent,
     elevation: 0,
     content: Center(
       child: CircularProgressIndicator(
         valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
       ),
     ),
   );

   showDialog(
     barrierColor: Colors.white.withOpacity(0),
     barrierDismissible: false,
     context: context,
     builder: (context) {
       return alertDialog;
     },
   );

 }

 void _login(BuildContext context) {
   BlocProvider.of<PhoneAuthCubit>(context).submittedOtp(otpCode);
 }

 Widget _buildVerifyButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          _login(context);

        },
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(110, 50),
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        child: const Text(
          'Verify',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPinCodeField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      autoFocus: true,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      obscureText: false,
      // show your verify numbers.
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        borderWidth: 1,
        activeColor: MyPrivateColor.lightBlue,
        inactiveColor: MyPrivateColor.lightGrey,
        activeFillColor:MyPrivateColor.lightBlue,
        inactiveFillColor:  Colors.white,
        selectedColor: MyPrivateColor.lightBlue,
        selectedFillColor: Colors.white
      ),

      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      enableActiveFill: true,

      onCompleted: (submittedCode) {
        otpCode =submittedCode;
        print("Completed");
      },
      onChanged: (value) {
        print(value);

      },

    );
  }
}
