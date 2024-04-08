import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class Myotp extends StatefulWidget {
  final String verificationid;

  const Myotp({
    required this.verificationid,
    Key? key,
  }) : super(key: key);

  @override
  State<Myotp> createState() => _MyotpState();
}

class _MyotpState extends State<Myotp> {
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OTP Verification'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter OTP sent to ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Change number',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OtpTextField(
                numberOfFields: 6,
                showFieldAsBox: false,
                borderWidth: 4.0,
                onCodeChanged: (String code) {
                  setState(() {
                    _otp = code; // Update OTP
                  });
                },
                onSubmit: (String verificationCode) async {
                  if (verificationCode.length == 6) {
                    try {
                      PhoneAuthCredential credential =
                          await PhoneAuthProvider.credential(
                        verificationId: widget.verificationid,
                        smsCode: verificationCode,
                      );
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            'Verified',
                            textAlign: TextAlign.center,
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } catch (ex) {
                      // Display Tooltip for incorrect OTP
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Incorrect OTP'),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  } else {
                    // Display Tooltip for incomplete OTP
                    Tooltip(
                      message: 'Please enter a 6-digit OTP',
                      child: Icon(Icons.error),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 30),
                ),
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
