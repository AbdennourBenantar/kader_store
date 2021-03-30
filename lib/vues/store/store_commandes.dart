import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaderstore/vues/client/client_home_page.dart';
import 'package:sweetalert/sweetalert.dart';
import 'navigation/store_navigation_bloc.dart';

class Commandes extends StatefulWidget with StoreNavigationStates{
  @override
  _CommandesState createState() => _CommandesState();
}

class _CommandesState extends State<Commandes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(width: MediaQuery.of(context).size.width*0.8,height: MediaQuery.of(context).size.height*0.6,color: Colors.blueAccent.shade100,),
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
                    Text('Commandes',style: GoogleFonts.abel(fontSize: 26),),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.04,width: MediaQuery.of(context).size.width,),
              Expanded(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.9,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("store/"+"YiBuID6sBRUwXnEpp1o2MwvnXHM2"+"/commandes").snapshots(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData?
                          Center(child: Text("Chargement ..."),)
                              :ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context,index){
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height*0.35,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 12),
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
                                              child: FadeInImage.assetNetwork(placeholder: 'assets/200.gif', image: snapshot.data.docs[index].data()["img"])
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width*0.02,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(snapshot.data.docs[index].data()["produit"],style: GoogleFonts.abel(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                              Text("Prix : "+snapshot.data.docs[index].data()["prix"]+" DA",style: GoogleFonts.abel(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w100
                                              ),),
                                              SizedBox(
                                                height: MediaQuery.of(context).size.height*0.02,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.3,
                                                child: FlatButton(
                                                    color: Colors.green.shade400,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    onPressed: (){
                                                      setState(() {
                                                        Navigator.push(context, new MaterialPageRoute(builder: (context)=>CommandeDetails(cmd: snapshot.data.docs[index],)));
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.check),
                                                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                                        Text('Valider',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                                      ],
                                                    )
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.3,
                                                child: FlatButton(
                                                    color: Colors.red,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    onPressed: (){
                                                      setState(() {
                                                        SweetAlert.show(context,title: "Attention",subtitle: "Êtes vous sûrs de l'annulation ?",style: SweetAlertStyle.confirm,showCancelButton: true,
                                                            // ignore: missing_return
                                                            onPress: (bool isConfirm){
                                                              if(isConfirm){
                                                                SweetAlert.show(context,subtitle: "Suppression...", style: SweetAlertStyle.loading);
                                                                setState(() {
                                                                  FirebaseFirestore.instance.collection("store/"+'YiBuID6sBRUwXnEpp1o2MwvnXHM2'+"/commandes").doc(snapshot.data.docs[index].id).delete();
                                                                });
                                                                new Future.delayed(new Duration(seconds:1),(){
                                                                  SweetAlert.show(context,subtitle: "Annulation avec succés", style: SweetAlertStyle.success);
                                                                });
                                                              }
                                                            }
                                                        );
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.delete),
                                                        SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                                        Text('Rejetter',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                                      ],
                                                    )
                                                ),
                                              )
                                            ],
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
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 7,
            right: 5,
            child:FlatButton(
                color: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ),
                onPressed: (){
                  setState(() {
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history,color: Colors.white,),
                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                    Center(child: Text('Rafraichir',style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),)),
                  ],
                )
            ) ,
          )
        ],
      ),
    );
  }
}
class CommandeDetails extends StatefulWidget {
  final QueryDocumentSnapshot cmd;

  const CommandeDetails({Key key, this.cmd}) : super(key: key);

  @override
  _CommandeDetailsState createState() => _CommandeDetailsState();
}

class _CommandeDetailsState extends State<CommandeDetails> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool clicked=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Builder(
        builder:(context)=> Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Background(
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.9,
              color: Colors.blue.shade100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 18.0,top: 6),
                  child: Align(
                    child: IconButton(
                      icon:Icon(Icons.close),
                      iconSize: 36,
                      color: Colors.black,
                      onPressed: (){
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    alignment: Alignment.topRight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: Text(
                    'Details de la commande',
                    style: GoogleFonts.abel(color: Colors.black,
                        fontSize: 22,fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 35),
                  child: Text(
                    'Veuillez préparer la commande suivante :',
                    style: GoogleFonts.abel(color: Colors.black,
                        fontSize: 18,fontWeight: FontWeight.normal
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.03),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Material(
                    animationDuration: Duration(milliseconds: 500),
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:18,top: 10),
                          child: Text(
                            'Voici les détails de la commande à préparer :',
                            style: GoogleFonts.abel(color: Colors.black,
                                fontSize: 16,fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.02,
                        ),
                        Table(
                          children: [
                            TableRow(
                                children: [
                                  Center(child: Text("Produit :",style: GoogleFonts.abel(fontSize:14,fontWeight: FontWeight.bold),)),
                                  Center(child: Text(widget.cmd.data()["produit"],style: GoogleFonts.abel(fontSize:14,),)),
                                ]
                            ),

                          ],
                        ),
                        Center(child: Image.network(widget.cmd.data()["img"],height: MediaQuery.of(context).size.height*0.25,width: MediaQuery.of(context).size.width*0.4,)),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
