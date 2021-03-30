
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaderstore/utils/config.dart';
import 'package:kaderstore/vues/client/client_layout.dart';
import 'package:kaderstore/vues/common/login.dart';
import 'package:kaderstore/vues/store/store_layout.dart';

import 'package:progress_dialog/progress_dialog.dart';


class Inscription extends StatefulWidget {
  final int option;

  const Inscription({Key key, this.option}) : super(key: key);
  @override
  _InscriptionState createState() => _InscriptionState();
}
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obscureText=true;
class _InscriptionState extends State<Inscription> {
  final Map<String,dynamic> signUpData={'email':null,'username':null,'phone':null,'password':null};

  final _formKey=new GlobalKey<FormState>();
  final _scaffoldKey=new GlobalKey<ScaffoldState>();

  final focusUsername=new FocusNode();

  final focusPhone=new FocusNode();

  final focusPassword=new FocusNode();


  void validate() async{
    final FormState _form=_formKey.currentState;
    ProgressDialog pg=new ProgressDialog(context);
    pg.style(
      message: 'Inscription en cours ...',
    );
    if(!_form.validate()){
      _form.save();
      try{
        pg.show();
        UserCredential result=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: signUpData['email'], password: signUpData['password']);
        print(result.user.uid);
        Store.user=result.user;
        if(Store.user!=null){
          saveUserToFirestore(Store.user).then((value) async {
            await pg.hide();
            switch(widget.option){
              case 0:
                Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() :  StoreLayout() ));
                break;
              case 1:
                Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() : StoreLayout()));
                break;
            }
          });
        }
      }on PlatformException catch(e){
        await pg.hide();
        print(e.message.toString());
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
      catch(e){
        await pg.hide();
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    }else{
      print("Echec");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          WavyImageRestaurantPage(),
          Padding(
            padding: const EdgeInsets.only(top:130),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Inscription",style: GoogleFonts.changa(fontSize: 55,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.05,
                  ),
                  Form(
                    key: _formKey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child:
                                  TextFormField(keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusUsername);
                                    },
                                    onSaved: (String value){
                                      signUpData['email']=value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      hintStyle: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                      hintText: 'Email',
                                      prefixIcon: Icon(Icons.mail,color: Colors.black,),
                                    ),
                                    validator: (String value){
                                      if (value.isEmpty){
                                        return "Champs Obligatoire";
                                      }
                                      else if(!regExp.hasMatch(value)){
                                        return "Adresse mail invalide";
                                      }
                                      return "";
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child:
                                  TextFormField(keyboardType: TextInputType.name,
                                    focusNode: focusUsername,
                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusPhone);
                                    },
                                    onSaved: (String value){
                                      signUpData['username']=value;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      hintStyle: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                      hintText: "Nom d'utilisateur",
                                      prefixIcon: Icon(Icons.person,color: Colors.black,),
                                    ),
                                    validator: (String value){
                                      if(value.trim().isEmpty)
                                      {
                                        return'Champs obligatoire';
                                      }else if(value.length<6){
                                        return"Doit etre de longueur superieure à 6'";
                                      }
                                      return "";
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child:
                                  TextFormField(keyboardType: TextInputType.phone,
                                      focusNode: focusPhone,
                                      style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v){
                                        FocusScope.of(context).requestFocus(focusPassword);
                                      },
                                      onSaved: (String value){
                                        signUpData['phone']=value;
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black)
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        hintStyle: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                        hintText: 'Téléphone',
                                        prefixIcon: Icon(Icons.phone,color: Colors.black,),
                                      ),
                                      validator: (String value){
                                        if(value.isEmpty){
                                          return "Champs Obligatoire";
                                        }
                                        else if (value.length!=10){
                                          return "Numéro de téléphone doit etre de longueur 10";
                                        }
                                        return "";
                                      }
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: new TextFormField(
                                    obscureText: obscureText,
                                    focusNode: focusPassword,

                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    onFieldSubmitted: (v){
                                      if(_formKey.currentState.validate())
                                      {
                                        _formKey.currentState.save();
                                      }
                                    },
                                    onSaved: (String value){
                                      signUpData['password']=value;
                                    },
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(0,0,0,1))
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(0,0,0,1))
                                        ),
                                        hintText: 'Mot de Passe',
                                        hintStyle: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black.withAlpha(150)),
                                        prefixIcon: Icon(Icons.lock,color: Colors.black,),
                                        suffixIcon: GestureDetector(
                                          child: Icon(Icons.visibility,color: Colors.black,),
                                          onTap: (){
                                            setState(() {
                                              obscureText=!obscureText;
                                            });
                                            FocusScope.of(context).unfocus();
                                          },
                                        )
                                    ),
                                    validator: (String value){
                                      if(value.trim().isEmpty)
                                      {
                                        return'Champs obligatoire';
                                      }else if (value.length<6)
                                      {
                                        return "Mot de passe doit etre de longueur superieure à 6";
                                      }
                                      return "";
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  ClipOval(
                    child: Container(
                      child: InkWell(
                        onTap: (){
                          validate();
                        },
                        child: new Icon(Icons.arrow_forward,size: 40,color: Colors.white,),
                      ),
                      height: MediaQuery.of(context).size.height*0.1,
                      width: MediaQuery.of(context).size.width*0.2,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.01,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login(option: widget.option,)));
                        },
                        child:Text("Login",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.black)
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future saveUserToFirestore(User user) async{
    switch(widget.option) {
      case 0:
        {
          FirebaseFirestore.instance.collection("clients").doc(user.uid).set({
            Store.clientUID:user.uid,
            Store.clientEmail:user.email,
            Store.clientName:signUpData['username'],
            Store.clientPhone:signUpData['phone'],
            Store.clientDate:'jj-mm-aaaa',
            Store.clientLatitude:'0',
            Store.clientLongitude:'0',
          });

          await Store.sharedPreferences.setString(Store.clientUID, user.uid);
          await Store.sharedPreferences.setString(Store.clientEmail, user.email);
          await Store.sharedPreferences.setString(Store.clientPhone, signUpData['phone']);
          await Store.sharedPreferences.setString(Store.StoreCurrentUser, "0");
          await Store.sharedPreferences.setString(Store.clientName, signUpData['username']);
          await Store.sharedPreferences.setString(Store.clientDate,'jj-mm-aaaa');
          await Store.sharedPreferences.setString(Store.clientLatitude,'0');
          await Store.sharedPreferences.setString(Store.clientLongitude,'0');
          break;
        }
      case 1:
        {
          FirebaseFirestore.instance.collection("store").doc(user.uid).set({
            Store.storeUID:user.uid,
            Store.storeEmail:user.email,
            Store.storeName:signUpData['username'],
            Store.storeLatitude:0,
            Store.storeLongitude:0,
            Store.storeOuvert:'1'
          });


          await Store.sharedPreferences.setString(Store.storeUID, user.uid);
          await Store.sharedPreferences.setString(Store.storeEmail, user.email);
          await Store.sharedPreferences.setString(Store.storeName, signUpData['username']);
          await Store.sharedPreferences.setString(Store.StoreCurrentUser, "1");
          await Store.sharedPreferences.setString(Store.storeLatitude, '0');
          await Store.sharedPreferences.setString(Store.storeLongitude,'0');
          await Store.sharedPreferences.setString(Store.storeOuvert, "1");
          break;
        }

    }
  }
}
class WavyImageRestaurantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Image.asset('assets/header.jpg'),
      clipper: BottomWaveClipperRestaurantPage(),
    );
  }
}
class BottomWaveClipperRestaurantPage extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path=Path();
    path.lineTo(0, size.height*0.4);
    path.cubicTo(size.width/3, size.height*0.5, 2*size.width/3, size.height*0.5, size.width, size.height*0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
