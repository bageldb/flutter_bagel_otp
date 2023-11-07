import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_module/bagel_db.dart';
import 'package:flutter_otp_module/pin_entry_text_field.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  bool _isInit = true;
  var _contact = '';

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String phoneNo;
  late String smsOTP;
  late String verificationId;
  String errorMessage = '';
  bool isButtonEnabled = false;
  Timer? _timer;

  void startTimer() {
    setState(() {
      isButtonEnabled = false; // Disable the button immediately when clicked
    });

    // Cancel any previous timer before starting a new one
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 30), () {
      setState(() {
        isButtonEnabled = true; // Enable the button after 30 seconds
      });
    });
  }

  @override
  void dispose() {
    // Always cancel the timer when disposing the widget to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  //this is method is used to initialize data
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Start the timer when the screen is first built.
    Timer(const Duration(seconds: 30), () {
      setState(() {
        // Enable the button after 30 seconds
        isButtonEnabled = true;
      });
    });

    // Load data only once after screen load
    if (widget._isInit) {
      widget._contact =
          '${ModalRoute.of(context)?.settings.arguments as String}';
      widget._isInit = false;
    }
  }

  //build method for UI
  @override
  Widget build(BuildContext context) {
    //Getting screen height width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: screenWidth * 0.7,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Image.asset(
                  'assets/images/registration.png',
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                const Text(
                  'Verification',
                  style: TextStyle(fontSize: 28, color: Colors.black),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Text(
                  'Enter A 6 digit number that was sent to ${widget._contact}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // ignore: prefer_const_literals_to_create_immutables
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: screenWidth * 0.025),
                        child: PinEntryTextField(
                          fields: 6,
                          onSubmit: (text) {
                            smsOTP = text as String;
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),

                      ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                                regenerateOtp();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E5BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                          ),
                          alignment: Alignment.center,
                        ),
                        child: const Text(
                          'Send OTP Again',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          verifyOtp(widget._contact);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E5BFF),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Verify',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//Method for generate otp from bagel
  Future<void> regenerateOtp() async {
    try {
      setState(() {
        isButtonEnabled = false; // Disable the button immediately when clicked
      });
      final nonce = await db.bagelUsersRequest.resendOtp();
      startTimer();
      print({nonce});
    } catch (e) {
      print({e});
    }
  }

  //Method for verify otp entered by user
  Future<void> verifyOtp(String phone) async {
    if (smsOTP == '') {
      showAlertDialog(context, 'please enter 6 digit otp');
      return;
    }
    try {
      //// ? via sdk
      // final res = await db.bagelUsersRequest.updatePassword(phone, smsOTP);

      // * via internal api (currently using an express js server)
      final res = await dio.post(
        '/updateUserPassword',
        data: {
          'emailOrPhone': phone,
          'password': smsOTP,
        },
      );
      print({res});

      final validateOtpRes = await db.bagelUsersRequest.validateOtp(smsOTP);
      print({validateOtpRes});
      Navigator.pushReplacementNamed(context, '/homeScreen');
    } catch (e) {
      print({e});
    }
  }

  //Method for handle the errors
  void handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;
      default:
        showAlertDialog(context, error.message as String);
        break;
    }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
