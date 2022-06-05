import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_application/business_logic_layer/phone_auth_cubit.dart';
import 'package:uber_application/constans/strings.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: BlocProvider<PhoneAuthCubit>(
            create: (context) => phoneAuthCubit,
            child: ElevatedButton(
              onPressed: ()async {
                await phoneAuthCubit.signOut();
                Navigator.of(context).pushReplacementNamed(logicScreen);
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(110, 50),
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
