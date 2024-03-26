import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/text_widgets/heading_text.dart';

import '../../../../../constants/app_colors.dart';
import '../../cubit/auth_state.dart';

class EmailVerificationPage extends StatefulWidget {
  final bool isSignUp;
  const EmailVerificationPage({super.key, this.isSignUp = true});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late final OtpFieldController _otpController;
  bool resendEnabled = false;
  int _secondsRemaining = 60;
  late Timer _timer;
  String otp = "";

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          resendEnabled = true; 
        }
      });
    });
  }

  void restartTimer() {
    setState(() {
      _secondsRemaining = 60;
      resendEnabled = false;
    });
    startTimer();
  }
  @override
  void initState() {
    super.initState();
    _otpController = OtpFieldController();
    startTimer();
  }
  

  @override
  void dispose() {
    _otpController.clear();
    super.dispose();
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  HeadingText(
                    widget.isSignUp ? "verify your email" : "Verify otp",
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "We just sent you a 6 digit verification code. Enter code sent to ${state.userEmail!.replaceRange(0, 8, "********")}",
                    style: const TextStyle(
                      color: grey90,
                      fontSize: h9,
                    ),
                  ),
                  const SizedBox(height: 64.0),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: OTPTextField(
                      length: 6,
                      spaceBetween: 12.0,
                      fieldWidth: 40,
                      fieldStyle: FieldStyle.box,
                      controller: _otpController,
                      onChanged: (value) {
                        setState(() {
                          otp = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        if(widget.isSignUp) {
                          BlocProvider.of<AuthCubit>(context, listen: false).sendVerificationOTP();
                        } else {
                          BlocProvider.of<AuthCubit>(context, listen: false).sendResetVerificationOTP(
                            email: state.userEmail!
                          );
                        }
                        restartTimer();
                      },
                      child: Text(
                        "I didn't receive a code ${!resendEnabled ? (_secondsRemaining) : ""}",
                        style: TextStyle(
                          color: !resendEnabled ? grey40 : blackColor
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  CustomButton(
                    onPressed: () {
                      if(widget.isSignUp) {
                        BlocProvider.of<AuthCubit>(context, listen: false).verifyUserEmail(
                          otp: otp,
                        );
                      } else {
                        BlocProvider.of<AuthCubit>(context, listen: false).verifyResetOTP(
                          otp: otp,
                        );
                      }
                    },
                    isDisabled: otp.length < 6,
                    label: "Verify",
                  )
                ],
              ),
            );
        },
      ),
    );
  }
}