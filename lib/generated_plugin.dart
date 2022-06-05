import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_application/business_logic_layer/phone_auth_cubit.dart';
import 'package:uber_application/presentation_layer/login_screen.dart';
import 'package:uber_application/presentation_layer/maps.dart';
import 'package:uber_application/presentation_layer/otp_screen.dart';

import 'constans/strings.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case logicScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
          ),
        );
      case otp:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(phoneNumber: phoneNumber),
          ),
        );
      case mapRoad:
        return MaterialPageRoute(builder: (_)=>Maps());
    }
  }
}
