
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaderstore/utils/config.dart';
import 'package:kaderstore/vues/store/navigation/store_navigation_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreHomePage extends StatefulWidget with StoreNavigationStates {
  @override
  _StoreHomePageState createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  Position current;


  @override
  void initState() {
    // TODO: implement initState
    Firebase.initializeApp();
    super.initState();
    current=Position(latitude: 36.70540301033143,longitude:  3.1710432217001774);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(
            height: MediaQuery.of(context).size.height*0.45,
            width: MediaQuery.of(context).size.width,
            color: Colors.orange.withOpacity(0.8),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height*0.07,),
              Titlee(text: 'Abdelkader T-Snacks',),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.07,width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('40',style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w800
                        ),),
                        Text("Commandes d'aujourd'hui",style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('2300 DA',style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w800
                        ),),
                        Text("Gains d'aujourd'hui",style: GoogleFonts.abel(
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                child: Material(
                  animationDuration: Duration(milliseconds: 500),
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                     Padding(
                         padding: EdgeInsets.all(18),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Adresse :',style: GoogleFonts.abel(fontSize: 26, fontWeight: FontWeight.bold),),
                           Text("Oued Smar, En face de l'école nationale \nsupérieure de l'informatique ESI",style: GoogleFonts.abel(fontSize: 14),),
                         ],
                       ),
                     )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                child: Material(
                  animationDuration: Duration(milliseconds: 500),
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              color:Store.sharedPreferences.getString(Store.storeOuvert)=='1'? Colors.redAccent.withOpacity(0.8):Colors.green.shade400,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(child: Text(Store.sharedPreferences.getString(Store.storeOuvert)=='1'?'Fermer':'Ouvrir',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,)),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              onPressed: () async {

                                if(Store.sharedPreferences.getString(Store.storeOuvert)=='1'){
                                  setState(() {
                                    Store.sharedPreferences.setString(Store.storeOuvert, '0');
                                    Store.sharedPreferences.setString(Store.storeOuvert, '0');
                                  });
                                  await FirebaseFirestore.instance.collection("store").doc(Store.sharedPreferences.getString(Store.storeUID)).update({
                                    Store.storeOuvert:'0'
                                  }).whenComplete(() {setState(() {
                                  });});
                                }

                                else{
                                  setState(() {
                                    Store.sharedPreferences.setString(Store.storeOuvert, '1');
                                  });
                                  await FirebaseFirestore.instance.collection("store").doc(Store.sharedPreferences.getString(Store.storeUID)).update({
                                    Store.storeOuvert:'1'
                                  }).whenComplete(() {setState(() {
                                  });});
                                }
                              },
                            ),
                            Text("Veuillez indiquer l'état de \nvotre boutique régulièrement",style: GoogleFonts.abel(fontSize: 14, ),),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:30.0),
                        child: Container(
                          width: 0.6,
                          height: MediaQuery.of(context).size.height*0.07,
                          color: Colors.black45.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text('Etat :',style: GoogleFonts.abel(fontSize: 26, fontWeight: FontWeight.bold),),
                            StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance.collection('store').doc(Store.sharedPreferences.getString(Store.storeUID)).snapshots(),
                                builder: (context, snapshot) {
                                  return !snapshot.hasData?
                                  Text("")   :
                                  snapshot.data.data()[Store.storeOuvert]=='1'?
                                  Image.asset('assets/ouvert.png',fit: BoxFit.cover,height: MediaQuery.of(context).size.height*0.12,):
                                  Image.asset('assets/ferme.png',fit: BoxFit.cover,height: MediaQuery.of(context).size.height*0.12);
                                }
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Les produits les plus demandés ',
                  style: GoogleFonts.abel(color: Colors.black,
                      fontSize: 26,fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.22,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('store').doc(Store.sharedPreferences.getString(Store.storeUID)).collection('categories').snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData?Text(""):
                    PageView.builder(
                      itemCount:  snapshot.data.docs.length,
                      controller: PageController(viewportFraction: 1.0),
                      itemBuilder: (context,index){
                        return  Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Material(
                            animationDuration: Duration(milliseconds: 1000),
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width*0.35,
                                      height: double.maxFinite,
                                      child: Image.network(snapshot.data.docs[index].data()['img'],fit: BoxFit.scaleDown,)),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.02,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(snapshot.data.docs[index].data()['id'],style: GoogleFonts.abel(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    Text(Random().nextInt(100).toString()+" commandes",style: GoogleFonts.abel(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100
                                    ),),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height*0.02,
                                    ),
                                    Text('Avis des clients',style: GoogleFonts.abel(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Icon(
                                          Icons.star_half,
                                          color: Colors.yellow,
                                        ),
                                        Icon(
                                          Icons.star_border,
                                          color: Colors.yellow,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.02,
                                        ),
                                        Text("(3.5)",style: GoogleFonts.abel(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w100
                                        ),),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              )

            ],
          ),
        ],
      ),
    );
  }
}
class Background extends StatelessWidget {
  final double width,height;
  final Color color;

  const Background({Key key, this.width, this.height,this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      width: width,
      top: 0,
      height: height,
      child: ClipRRect(
        child: Container(color: color,),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: width==MediaQuery.of(context).size.width?Radius.circular(40):Radius.circular(0)),
      ),
    );
  }
}
class Titlee extends StatelessWidget {
  final String text;

  const Titlee({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final words=text.split(' ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: RichText(
        text: TextSpan(
            children: [
              TextSpan(
                  text: words[0],
                  style: TextStyle(
                      height: 0.9,
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      letterSpacing: 2,
                      color: Colors.black
                  )
              ),
              TextSpan(
                  text: '\n'
              ),
              TextSpan(
                  text: words[1],
                  style: TextStyle(
                      height: 0.9,
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      letterSpacing: 6,
                      fontFamily: 'Londrina_Outline',
                      color: Colors.black
                  )
              )
            ]
        ),
      ),
    );
  }
}
