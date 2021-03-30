import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaderstore/utils/config.dart';
import 'package:kaderstore/utils/models.dart';
import 'package:kaderstore/vues/client/navigation/client_navigation_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';



class ClientHomePage extends StatefulWidget with ClientNavigationStates {
  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int selectedOption=0;
  final _formKey2 = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  String url;
  ProgressDialog pg;
  File _imgFile;
  TextEditingController tedc=TextEditingController();
  TextEditingController tedc4=TextEditingController();
  TextEditingController tedc3=TextEditingController();
  TextEditingController tedc2=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
  }
  Future chooseImage() async {
    final pickedFile= await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _imgFile=File(pickedFile.path);
    });
  }
  Future uploadImagetoFirestore(BuildContext context) async {
    pg=new ProgressDialog(context);
    pg.style(
      message: 'Importation en cours ...',
    );
    pg.show();
    String fileName=_imgFile.path;
    Reference firebaseStorageRef=FirebaseStorage.instance.ref().child(fileName);
    TaskSnapshot taskSnapshot=await firebaseStorageRef.putFile(_imgFile).whenComplete(() => null);
    do{
      print(taskSnapshot.bytesTransferred);
    }while(taskSnapshot.bytesTransferred<taskSnapshot.totalBytes);
    var img=await taskSnapshot.ref.getDownloadURL();
    setState(() {
      url=img;
    });
    pg.hide();
  }
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(
            width: width*0.52,
            height: height*0.8,
            color: Colors.orange.withOpacity(0.8),
          ),
          StreamBuilder<DocumentSnapshot>(
           stream: FirebaseFirestore.instance.collection('store').doc('YiBuID6sBRUwXnEpp1o2MwvnXHM2').snapshots(),
            builder: (context, dsnapshot) {
              return !dsnapshot.hasData?
                  Text(''):
              dsnapshot.data.data()[Store.storeOuvert]=='0'?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/ferme.png'),
                    Center(child: Text('Notre magasin est hors service pour le moment, veuillez revenir plutard\n Merci !',textAlign: TextAlign.center,style: GoogleFonts.abel(fontWeight: FontWeight.bold,fontSize: 18),))
                  ],
                ),
              ):
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('store').doc('YiBuID6sBRUwXnEpp1o2MwvnXHM2').collection('categories').snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData?Text("Chargement"):
                    snapshot.data.docs.length==0?Center(child: Text("Nous n'avons pas encore introduit de produits"),):
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Titlee(text: 'Nos Produits',),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height*0.01
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 50,right: 1,top: 5),
                          child: Text(
                            "Soyez les bienvenus",
                            style: GoogleFonts.abel(color: Colors.black,
                                fontSize: 16,fontWeight: FontWeight.normal
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height*0.03
                        ),
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int index=0;index<snapshot.data.docs.length;index++)
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Material(
                                        elevation: 8,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                            padding: const EdgeInsets.all(8),
                                            width: index==selectedOption?MediaQuery.of(context).size.width*0.16:MediaQuery.of(context).size.width*0.15,
                                            height: index==selectedOption?MediaQuery.of(context).size.height*0.08:MediaQuery.of(context).size.height*0.07,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: index==selectedOption?Colors.black:Colors.white,
                                            ),
                                            child: snapshot.data.docs[index].data()['img']==null?Image.asset('assets/200.gif'):Image.network(snapshot.data.docs[index].data()['img'],color:index==selectedOption?Colors.white:Colors.black,)
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        selectedOption=index;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:18.0),
                          child: Center(
                            child: Text("Catégorie "+snapshot.data.docs[selectedOption].data()['id'],style: GoogleFonts.abel(fontWeight: FontWeight.bold,fontSize: 26),),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.42,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('store').doc('YiBuID6sBRUwXnEpp1o2MwvnXHM2').collection('categories').doc(snapshot.data.docs[selectedOption].reference.id).collection('elements').snapshots(),
                              builder: (context, dsnapshot) {
                                return !dsnapshot.hasData?Text('Chargement'):
                                PageView.builder(
                                    itemCount: dsnapshot.data.docs.length,
                                    controller: PageController(viewportFraction: 0.72),
                                    itemBuilder: (context, i) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        child: InkWell(
                                          onTap: () {
                                          },
                                          child: Stack(
                                            children: <Widget>[
                                              Hero(
                                                tag: "background-$i",
                                                child: Material(
                                                  elevation: 10,
                                                  shape: PlatCardShape(
                                                      MediaQuery.of(context).size.width* 0.65,
                                                      MediaQuery.of(context).size.height * 0.38),
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    62, 0, 62, 80),
                                                child: Align(
                                                  child: FadeInImage.assetNetwork(placeholder: 'assets/200.gif', image:  dsnapshot.data.docs[i].data()['img']),
                                                  alignment: Alignment(0, 0),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    32, 0, 32, 0),
                                                child: Align(
                                                  child: FlatButton(
                                                    color: Colors.orange.withOpacity(0.8),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Icon(Icons.shopping_basket),
                                                        SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                                                        Text('Ajouter au panier',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    onPressed: (){
                                                      Comm commande=new Comm(null);
                                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Commande ajoutée, Consultez votre panier pour la valider")));
                                                      commande.produit=dsnapshot.data.docs[i];
                                                      panier.add(commande);
                                                      setState(() {
                                                      });

                                                    },
                                                  ),
                                                  alignment: Alignment(0,0.3),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                child: Align(
                                                  child: Text(dsnapshot.data.docs[i].data()['nom'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w800
                                                    ),),
                                                  alignment: Alignment(0,0.55),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    0 , 0, 0, 0),
                                                child: Align(
                                                  child: Text(dsnapshot.data.docs[i].data()['description'],
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w300
                                                    ),),
                                                  alignment: Alignment(0,0.65),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    0 , 0, 0, 0),
                                                child: Align(
                                                  child: Text(dsnapshot.data.docs[i].data()['prix']+" DA",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w300
                                                    ),),
                                                  alignment: Alignment(0,0.75),
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                          ),
                        ),
                      ],
                    );
                  }
              );
           }
          ),

        ],
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
class PlatCardShape extends ShapeBorder{
  final double width;
  final double height;

  const PlatCardShape(this.width, this.height);
  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getInnerPath
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(Size(width,height));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    return null;
  }
  Path getClip(Size size) {
    Path clippedPath=new Path();
    double curveDistance=40;

    clippedPath.moveTo(0, size.height*0.4);
    clippedPath.lineTo(0, size.height-curveDistance);
    clippedPath.quadraticBezierTo(1, size.height-1, 0+curveDistance, size.height);
    clippedPath.lineTo(size.width-curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width+1, size.height-1, size.width, size.height-curveDistance);
    clippedPath.lineTo(size.width, 0+curveDistance);
    clippedPath.quadraticBezierTo(size.width-1, 0, size.width-curveDistance-5, 0+curveDistance/3);
    clippedPath.lineTo(curveDistance, size.height*0.27);
    clippedPath.quadraticBezierTo(1, (size.height*0.30)+10, 0, size.height*0.4);
    return clippedPath;
  }

}