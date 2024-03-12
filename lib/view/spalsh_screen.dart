import 'dart:async';


import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("HomePage", (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.pink[100]
        ),
        child: Column(
          children: [
            SizedBox(height: 150,),
            Center(
              child: Image.asset("assets/splash.png",width: double.infinity,),
            ),
            Image.asset("assets/sp1.png",width: double.infinity,),

          ],
        ),
      ),
    );
  }
}
