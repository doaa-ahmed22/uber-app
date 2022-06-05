import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_application/business_logic_layer/phone_auth_cubit.dart';

import 'package:uber_application/business_logic_layer/phone_auth_state.dart';
import '../constans/colors.dart';
import '../constans/strings.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  late String phoneNumber;
  late GlobalKey<FormState> formKey = GlobalKey();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 88, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroText(),
                const SizedBox(
                  height: 30,
                ),
                _buildUnderIntroText(),
                const SizedBox(
                  height: 110,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildFlagFormField(),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildPhoneFormField(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                _buildNextButton(context),
                _buildPhoneNumberSubmittedBloc(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSubmittedBloc() {
    return BlocListener<PhoneAuthCubit,PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }
        if (state is ErrorOccurred) {
          Navigator.pop(context);
          String errorMes = (state).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMes),
              backgroundColor: Colors.grey,
              duration: const Duration(seconds: 5),
            ),
          );
        }
        if (state is PhoneNumberSubmitted) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(otp, arguments: phoneNumber);
        }
      },
      child: Container(),
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

  Widget _buildIntroText() {
    return const Text(
      'What is your phone number ?',
      style: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildUnderIntroText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: const Text(
        'Please enter your phone number to verify your account.',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

  Widget _buildFlagFormField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: MyPrivateColor.lightGrey),
      ),
      child: Text(
        '${generateFlagFunction()} +20',
        style: const TextStyle(
          fontSize: 18,
          letterSpacing: 2,
        ),
      ),
    );
  }

  String generateFlagFunction() {
    String countryCode = 'eg';
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));

    return flag;
  }

  Widget _buildPhoneFormField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: MyPrivateColor.blue),
      ),
      child: TextFormField(
        autofocus: true,
        style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        cursorColor: Colors.black,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your phone number';
          } else if (value.length < 11) {
            return 'Too short for a phone number';
          }
          return null;
        },
        onSaved: (value) {
          phoneNumber = value!;
        },
      ),
    );
  }
  Future<void> _register(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      formKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).submittedPhoneNumber(phoneNumber);
    }
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {

          showProgressIndicator(context);

          _register(context);

        },
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(110, 50),
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
