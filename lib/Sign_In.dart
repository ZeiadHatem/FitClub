import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitclub2/Home_Screen.dart';
import 'package:fitclub2/Sign_Up.dart';
import 'package:fitclub2/Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SignIn extends StatefulWidget{
  
  
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  bool isHidden = true;
  late String userName , pass;
  final userNameController = TextEditingController();
  final passController = TextEditingController();

  void _showPass(){
    setState(() {
      isHidden =!isHidden;
    });
  }

  Widget build(BuildContext context){

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50 , horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                  Text('FITCLUB GYM' , style:
                  TextStyle(color: Colors.indigo[900]! ,
                      fontSize: 35 ,
                      fontStyle: FontStyle.italic),),

              SizedBox(height: 40,),

              Row(
                children: [
                  Text('New To FitClub?' , style: TextStyle(fontSize: 17 , color: Colors.black87),),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                      },
                      child: Text("SignUp" , style: TextStyle(color: Colors.indigo[900]! , fontSize: 17),)
                  ),
                ],
              ),

              TextField(
                controller: userNameController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (userNameValue){
                  userName = userNameValue;
                },
                decoration: InputDecoration(
                  label: Text("Emai" , style: TextStyle(color: Colors.blue),),
                  border: OutlineInputBorder()
                ),
              ),

              SizedBox(height: 20,),

              TextField(
                obscureText: isHidden,
                controller: passController,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (passValue){
                  pass = passValue;
                },
                decoration: InputDecoration(
                    label: Text("Password" , style: TextStyle(color: Colors.blue),),
                    border: OutlineInputBorder(),
                  suffixIcon: InkWell(
                    onTap: _showPass,
                    child: Icon(isHidden?Icons.visibility:Icons.visibility_off),
                  )
                ),
              ),

              SizedBox(height: 20,),

              SignBtn(
                text: 'SignIn',
                color: Colors.red[900]!,
                press: ()async{
                  userNameController.clear();
                  passController.clear();
                  try{
                    final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: userName, password: pass);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()) , (route)=>false);
                  }
                  catch(e){
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}