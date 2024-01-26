import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitclub2/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';

import 'Home_Screen.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FitClub());
}

class FitClub extends StatelessWidget{


  Widget build(BuildContext context){
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}


class SplashScreen extends StatelessWidget{

  Widget build(BuildContext context){
    return AnimatedSplashScreen(
        splash: Center(
          child: Text("FIT CLUB" , style: TextStyle(color: Colors.white , fontSize: 40 , fontWeight: FontWeight.bold),),
        ),
        backgroundColor: Colors.black87,
        splashIconSize: 150,
        nextScreen: FirebaseAuth.instance.currentUser!=null?HomeScreen():SignIn(),
        duration: 1000,
    );
  }
}