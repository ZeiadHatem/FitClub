import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitclub2/Home_Screen.dart';
import 'package:flutter/material.dart';

import 'Widget.dart';


class SignUp extends StatefulWidget{

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isHidden = true;

  final userNameController = TextEditingController();
  final passController = TextEditingController();
  final emailController = TextEditingController();
  late String userName , email , pass;

  void _showPass(){
    setState(() {
      isHidden =!isHidden;
    });
  }

  Widget build(BuildContext context){


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50 , horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Hello In' , style:
            TextStyle(color: Colors.indigo[900]! ,
                fontSize: 35 ,
                fontStyle: FontStyle.italic),),

            Text('FITCLUB GYM' , style:
            TextStyle(color: Colors.indigo[900]! ,
                fontSize: 35 ,
                fontStyle: FontStyle.italic),),

            SizedBox(height: 40,),


            TextField(
              controller: userNameController,
              onChanged: (userNameValue){
                userName = userNameValue;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  label: Text("UserName" , style: TextStyle(color: Colors.blue),),
                  border: OutlineInputBorder()
              ),
            ),

            SizedBox(height: 20,),

            TextField(
              controller: emailController,
              onChanged: (emailValue){
                email = emailValue;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  label: Text("Email" , style: TextStyle(color: Colors.blue),),
                  border: OutlineInputBorder()
              ),
            ),

            SizedBox(height: 20,),

            TextField(
              obscureText: isHidden,
              controller: passController,
              onChanged: (value){
                pass = value;
              },
              keyboardType: TextInputType.visiblePassword,
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
              text: 'SignUp',
              color: Colors.red[900]!,
              press: ()async{
                userNameController.clear();
                passController.clear();
                emailController.clear();
                try{
                  final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
                  FirebaseFirestore.instance.collection('Admins').add(
                      {
                        'userName':userName,
                        'email' : email,
                        'password': pass
                      });
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),(route)=>false);
                }
                catch(e){
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}