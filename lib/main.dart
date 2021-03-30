
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaderstore/utils/config.dart';
import 'package:kaderstore/vues/common/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
     MyApp()
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abdelkader Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Commande en ligne de nourriture '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp().whenComplete(() async {
      setState((){

      });
      Store.auth=FirebaseAuth.instance;
      Store.sharedPreferences=await SharedPreferences.getInstance();
      Store.firestore=FirebaseFirestore.instance;
    });
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            WavyImageHomePage(),
            Padding(
              padding:  EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height*0.05),
              child: Text("Continuer en tant que:",style: GoogleFonts.abel(fontSize: 30,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.08,
                        child: Material(
                          color: Colors.blue.withBlue(240),
                          borderRadius: BorderRadius.circular(10),
                          child:Center(child: Text("Client",style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,)),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context,new MaterialPageRoute(builder: (context)=>Login(option: 0,)));
                      },
                    ),
                  ),
                  InkWell(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.height*0.08,
                      child: Material(
                        color: Colors.blue.withBlue(240),
                        borderRadius: BorderRadius.circular(10),
                        child:Center(child: Text("Administrateur",style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,)),

                      ),
                    ),
                    onTap: (){
                      Navigator.push(context,new MaterialPageRoute(builder: (context)=>Login(option: 1,)));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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