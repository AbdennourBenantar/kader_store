
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:kaderstore/utils/config.dart';
import 'package:kaderstore/utils/models.dart';
import 'package:kaderstore/vues/client/navigation/client_navigation_bloc.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:swipe_up/swipe_up.dart';

import 'client_home_page.dart';



class ClientHistory extends StatefulWidget with ClientNavigationStates{
  @override
  _ClientHistoryState createState() => _ClientHistoryState();
}

class _ClientHistoryState extends State<ClientHistory> {
  int i,j;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Background(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.6,color: Colors.orange.withOpacity(0.8),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.07,width: MediaQuery.of(context).size.width,),
                Padding(
                  padding: const EdgeInsets.only(left:48.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: Icon(Icons.shopping_cart),
                      ),
                      Text('Mon Historique',style: GoogleFonts.abel(fontSize: 26),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:34.0,vertical: 20),
                  child: Text('Produits commandés récemment',style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide.none)
                      ),
                      height: MediaQuery.of(context).size.height*0.8,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('clients').doc(Store.sharedPreferences.getString(Store.clientUID)).collection('historique').snapshots(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData?Center(
                            child: Column(
                              children: [
                                Image.asset('assets/empty.png'),
                                Text('Votre historique est vide',style: GoogleFonts.abel(fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ):ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context,index){
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:18.0,horizontal: 18),
                                    child: Material(
                                      elevation: 8,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              height: MediaQuery.of(context).size.height*0.15,
                                              width: MediaQuery.of(context).size.width*0.4,
                                              child: Image.network(snapshot.data.docs[index].data()["img"],fit: BoxFit.cover)
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width*0.02,
                                          ),
                                          SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(snapshot.data.docs[index].data()["produit"],style: GoogleFonts.abel(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),),
                                                Text("Date : "+snapshot.data.docs[index].data()["date"].toString().split('.').first,style: GoogleFonts.abel(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w100
                                                ),),
                                                Text("Totale : "+snapshot.data.docs[index].data()["prix"]+" DA",style: GoogleFonts.abel(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold
                                                ),),
                                                SizedBox(
                                                  height: MediaQuery.of(context).size.height*0.02,
                                                ),

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      )
                  ),
                ),


              ],
            )
          ],
        )
      ),
    );
  }
}
