
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaderstore/utils/config.dart';
import 'package:kaderstore/vues/client/client_layout.dart';
import 'package:kaderstore/vues/common/inscription.dart';
import 'package:kaderstore/vues/store/store_layout.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class Login extends StatefulWidget {
  final int option;

  const Login({Key key, this.option}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obscureText=true;
class _LoginState extends State<Login> {
  final _scaffoldKey2=new GlobalKey<ScaffoldState>();

  bool proceed;
  final Map<String,dynamic> signInData={'email':null,'password':null};

  final _formKey=new GlobalKey<FormState>();

  final focusPassword=new FocusNode();
  ProgressDialog pg;

  Future<void> validate() async {
    pg=new ProgressDialog(context);
    pg.style(
      message: 'Connexion en cours ...',
    );
    final FormState _form=_formKey.currentState;
    if(!_form.validate()){
      _form.save();
      try{
        pg.show();
        UserCredential result=await FirebaseAuth.instance.signInWithEmailAndPassword(email: signInData['email'], password: signInData['password']);
        print(result.user.uid);
        Store.user=result.user;
      }on PlatformException catch(e){
        print(e.message.toString());
        await pg.hide();
        _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text(e.message.toString())));

      }catch(e){
        await pg.hide();
        _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text(e.message.toString())));

      }
    }else{
      print("Echec");
    }
    if(Store.user!=null){
      readData(Store.user);
    }
  }
  Future readData(User user) async{

    switch(widget.option) {
      case 0:
        {
          FirebaseFirestore.instance.collection("clients").doc(user.uid).get().whenComplete((){}).then((dataSnap) async {
            if(dataSnap.data()!=null)
            {
              proceed=true;
              await Store.sharedPreferences.setString(Store.clientUID, dataSnap.data()[Store.clientUID]);
              await Store.sharedPreferences.setString(Store.clientEmail, dataSnap.data()[Store.clientEmail]);
              await Store.sharedPreferences.setString(Store.clientName, dataSnap.data()[Store.clientName]);
              await Store.sharedPreferences.setString(Store.clientPhone, dataSnap.data()[Store.clientPhone]);
              await Store.sharedPreferences.setString(Store.clientDate, dataSnap.data()[Store.clientDate]);
              await Store.sharedPreferences.setString(Store.clientLatitude, dataSnap.data()[Store.clientLatitude].toString());
              await Store.sharedPreferences.setString(Store.clientLongitude, dataSnap.data()[Store.clientLongitude].toString());
              await Store.sharedPreferences.setString(Store.StoreCurrentUser, "0");

            }else{
              setState(() {
                proceed=false;
              });
            }
          }).whenComplete(() {
          }
          ).then((value) async {
            if(proceed){
              await pg.hide();
              Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() :  StoreLayout() ));
            }else{
              await pg.hide();
              _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text("Vous vous n'etes pas encore inscris en tant que client !"),duration: Duration(milliseconds: 3000),));
            }
          });
          break;
        }
      case 1:
        {
          FirebaseFirestore.instance.collection("store").doc(user.uid).get().whenComplete((){}).then((dataSnap) async {
            if(dataSnap.data()!=null)
            {
              proceed=true;
              await Store.sharedPreferences.setString(Store.storeUID, dataSnap.data()[Store.storeUID]);
              await Store.sharedPreferences.setString(Store.storeEmail, dataSnap.data()[Store.storeEmail]);
              await Store.sharedPreferences.setString(Store.storeName, dataSnap.data()[Store.storeName]);
              await Store.sharedPreferences.setString(Store.StoreCurrentUser, "1");
              await Store.sharedPreferences.setString(Store.storeLongitude, dataSnap.data()[Store.storeLongitude].toString());
              await Store.sharedPreferences.setString(Store.storeLatitude, dataSnap.data()[Store.storeLatitude].toString());
              await Store.sharedPreferences.setString(Store.storeOuvert, dataSnap.data()[Store.storeOuvert].toString());
            }
            else{
              setState(() {
                proceed=false;
              });
              await Store.auth.signOut();
            }
          }).whenComplete(() {
          }
          ).then((value) async {
            if(proceed){
              // Navigator.pop(context);
              await pg.hide();
              Navigator.push(context, new MaterialPageRoute(builder: (context) => widget.option == 0 ? ClientLayout() : StoreLayout() ));
            }else{
              await pg.hide();
              _scaffoldKey2.currentState.showSnackBar(SnackBar(content: Text("Vous essayer de vous connecter en tant qu'administrateur alors vous ne l'etes pas !"),duration: Duration(milliseconds: 3000),));
            }
          });
          break;
        }

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
      key: _scaffoldKey2,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          WavyImageRestaurantPage(),
          Padding(
            padding: const EdgeInsets.only(top:230),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text("Connexion",style: GoogleFonts.changa(fontSize: 55,fontWeight: FontWeight.bold),),
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
                                  child: new
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).requestFocus(focusPassword);
                                    },
                                    onSaved: (String value){
                                      signInData['email']=value;
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
                                        return "Adresse email invalide";
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
                                  child: new TextFormField(obscureText: obscureText,
                                    focusNode: focusPassword,
                                    style: GoogleFonts.changa(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                                    onFieldSubmitted: (v){
                                      if(_formKey.currentState.validate())
                                      {
                                        _formKey.currentState.save();
                                      }
                                    },
                                    onSaved: (String value){
                                      signInData['password']=value;
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

                  if(widget.option==0)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Inscription(option: widget.option,)));
                        },
                        child:Text("Nouveau compte",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w400),),
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
}
class WavyImageHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Image.asset('assets/header.jpg'),
      clipper: BottomWaveClipperHomePage(),

    );
  }
}
class BottomWaveClipperHomePage extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path=Path();
    path.lineTo(0, size.height*0.9);
    path.cubicTo(size.width/3, size.height*0.8, 2*size.width/3, size.height*0.8, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
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