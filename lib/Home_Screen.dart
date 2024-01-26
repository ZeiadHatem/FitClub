import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fitclub2/Sign_In.dart';
import 'package:fitclub2/Widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';


class HomeScreen extends StatefulWidget{

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var phone , numberAdd , userName , messageWrite;
  var unique = Set<Widget>();
  List<Widget> phonesWithoutRepeat = [];
  final TextController = TextEditingController();
  final messageController = TextEditingController();
  late User signedInUser;
  var currentUser;
  List<Text> usersWithoutRepeat=[];


  @override
  void initState(){
    super.initState();
    getUser();
  }

getUser(){

  final User = FirebaseAuth.instance.currentUser;

  if(User!=null){

    signedInUser = User;
  }
}


  Future<Null> sending_SMS(String msg, List<String> list_receipents) async {
    try{
      String send_result = await sendSMS(message: msg, recipients: list_receipents , sendDirect: true);
      print(send_result);
    }
        catch(e){
      print(e);
        }

  }

  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        elevation: 5,

        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("FITCLUB" , style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold
                ),),

            IconButton(
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignIn()), (route) => false);
                },
                icon: Icon(Icons.close)
            )
          ],
        ),

      ),
        body: SingleChildScrollView(
          child: Padding(
              padding:  EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Admins').snapshots(),
                        builder: (context , snapshot){
                          List<Text> accountUser = [];
                          switch(snapshot.connectionState){
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator(),);

                            case ConnectionState.active:
                            case ConnectionState.done:
                              if(snapshot.hasData){
                                final accountAdmins = snapshot.data?.docs;

                                for(var admin in accountAdmins!){
                                  userName = admin.get('userName');
                                  currentUser = admin.get('email');
                          if(signedInUser.email==currentUser&&userName!=null){
                          accountUser.add(Text("Admin: $userName" , style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.brown[700],
                            fontStyle: FontStyle.italic
                          )));

                          }
                                }
                              }
                              return Padding(
                                padding:  EdgeInsets.all(5),
                                child:Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                          userName!=null?Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: usersWithoutRepeat = accountUser.where((element) => unique.add(element)).toList()
                          ): Container(),

                          signedInUser.displayName!=null? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                          Text("${signedInUser.displayName}" , style: Theme.of(context).textTheme.titleSmall,),
                          ],
                          ):Container()


                          ],
                          )
                              );
                          }
                        }
                    ),

                    Padding(
                      padding:  EdgeInsets.only(top: 5 , left: 20 , right: 20),
                      child: TextField(
                        maxLines: null,
                        onChanged: (value){
                          messageWrite = value;
                        },
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            label: Text("Write Your message"),
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
                    Center(
                      child: FirstBtn(
                        text: "Save Message",
                        press: (){
                          messageController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                          if(messageWrite!=null){
                                Fluttertoast.showToast(
                                    msg: "Message Changed",
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white
                                );
                          } else{
                            Fluttertoast.showToast(
                                msg: "Message Not change",
                                backgroundColor: Colors.black87,
                                textColor: Colors.white
                            );
                          }

                        },
                        color: Colors.black87,
                      ),
                    ),


                    SizedBox(height: 10,),

                    Padding(
                      padding:  EdgeInsets.only(top: 10 , left: 20 , right: 20),
                      child: TextField(
                        onChanged: (value){
                          numberAdd = value;
                        },
                        controller: TextController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            label: Text("Enter Number"),
                            border: OutlineInputBorder()
                          ),
                        ),
                    ),

                    SizedBox(height: 20,),

                    Center(
                      child: FirstBtn(
                          text: "Add",
                          press: (){
                            TextController.clear();
                            FocusManager.instance.primaryFocus?.unfocus();
                            if(numberAdd!=null){
                              FirebaseFirestore.instance.collection('Phones').add({
                                'phone' : numberAdd
                              }).then((value) =>
                                  Fluttertoast.showToast(
                                      msg: "The Number Has Been Saved",
                                      backgroundColor: Colors.black87,
                                      textColor: Colors.white
                                  )
                              );
                            } else{
                              Fluttertoast.showToast(
                                  msg: "Please Enter Number",
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white
                              );
                            }
                          },
                        color: Colors.red[900]!,
                      ),
                    ),

                    SizedBox(height: 30,),

                    Row(
                      children: [
                        Icon(CupertinoIcons.phone_circle_fill, color: Colors.grey[600],),
                        Text('FitClub Members' , style: TextStyle(
                            fontWeight: FontWeight.bold ,
                            fontSize: 25 ,
                            color: Colors.grey[600] ,
                            fontStyle: FontStyle.italic),),
                      ],
                    ),

                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('Phones').snapshots(),
                      builder: (context , snapshot){
                        final List<Widget> phones = [];
                        switch(snapshot.connectionState){
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator(),);
                          case ConnectionState.done:
                          case ConnectionState.active:
                            if(snapshot.hasData){
                              final accounts = snapshot.data?.docs;
                              for(var account in accounts!){
                                phone = account.get('phone');
                                List<String> phonesSavedWithoutRepeat = [];
                                final List<String> phonesSaved = [];
                                var uniquePhones = Set();
                                phonesSaved.add(phone);

                                phonesSavedWithoutRepeat = phonesSaved.where((element) => uniquePhones.add(element)).toList();

                                phones.add(ListTile(
                                  leading: Icon(Icons.phone , color: Colors.blue,),
                                  title: Text(phone , style: TextStyle(color: Colors.black87 , fontSize: 15),),
                                  trailing: FirstBtn(
                                    color: Colors.indigo[900]!,
                                      text: "Send",
                                      press: (){
                                        sending_SMS(messageWrite!=null?messageWrite : 'لو الماسدج دي جاتلك\n اسئل على عروض الشتا فى FitClub Gym فرع جمال عبد الناصر😃🔥',
                                            phonesSavedWithoutRepeat).then(
                                                (value) => Fluttertoast.showToast(
                                                    msg: "SMS Sent!",
                                                  backgroundColor: Colors.black87,
                                                  textColor: Colors.white
                                                )
                                        );
                                      }
                                  )
                                ));
                              }
                            }

                            return  Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: Column(
                                        children: phonesWithoutRepeat = phones.where((element) => unique.add(element)).toList(),
                                      ),
                            );
                        }
                      },
                    ),

                  ],
                ),
            ),
        )
      );
  }
}

