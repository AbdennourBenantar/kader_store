
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:kaderstore/utils/config.dart';
import 'package:kaderstore/utils/models.dart';
import 'package:kaderstore/vues/client/navigation/client_navigation_bloc.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:swipe_up/swipe_up.dart';

import 'client_home_page.dart';



class Cart extends StatefulWidget with ClientNavigationStates{
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int i,j;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  double countTotal(){
    double sum=0;
    if(panier.isNotEmpty)
    {
      for (int i=0;i<panier.length;i++)
      {
        sum=sum+(double.parse(panier[i].produit.data()['prix']));
      }
    }else{
      sum=0;
    }

    return sum;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SwipeUp(
          sensitivity: 0.7,
          onSwipe: (){
            setState(()  {
                for(i=0;i<panier.length;i++){
                  FirebaseFirestore.instance.collection("store").doc('YiBuID6sBRUwXnEpp1o2MwvnXHM2').collection('commandes').doc().set({
                   Store.clientName:Store.sharedPreferences.getString(Store.clientName),
                    'produit':panier[i].produit.data()['nom'],
                    'prix':panier[i].produit.data()['prix'],
                    'img':panier[i].produit.data()['img']
                  });
                  FirebaseFirestore.instance.collection("clients").doc(Store.sharedPreferences.getString(Store.clientUID)).collection('historique').doc().set({
                    Store.clientName:Store.sharedPreferences.getString(Store.clientName),
                    'produit':panier[i].produit.data()['nom'],
                    'prix':panier[i].produit.data()['prix'],
                    'img':panier[i].produit.data()['img'],
                    'date':DateTime.now().toString()
                  });
                }
                if(panier.length==0)
                {
                  setState(() {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Votre panier est vide !")));
                  });
                }
                else{
                  setState(() {
                    SweetAlert.show(context,title: "Merci à vous !",confirmButtonColor:Colors.green.shade400,subtitle: "   Commande passée avec succés",style: SweetAlertStyle.success,
                        onPress: (bool isConfirm){
                          if(isConfirm) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Votre commande est validé, et vous attend !")));
                          }
                          return true;
                        });
                  });
                }
                if(i>=panier.length){
                  setState(() {
                    panier.clear();
                  });
                }

            });
          },
          body: Stack(
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
                        Text('Mon Panier',style: GoogleFonts.abel(fontSize: 26),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:34.0,vertical: 20),
                    child: Text('Produits commandés',style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide.none)
                      ),
                      height: MediaQuery.of(context).size.height*0.6,
                      child: ListView.builder(
                          itemCount: panier.length,
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
                                          child: Image.network(panier[index].produit.data()["img"],fit: BoxFit.contain,)
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.02,
                                      ),
                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(panier[index].produit.data()["nom"],style: GoogleFonts.abel(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold
                                            ),),
                                            Text("Description : "+panier[index].produit.data()["description"],style: GoogleFonts.abel(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w100
                                            ),),
                                            Text("Prix : "+panier[index].produit.data()["prix"]+" DA",style: GoogleFonts.abel(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold
                                            ),),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height*0.02,
                                            ),
                                            FlatButton(
                                                color: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                onPressed: (){
                                                  setState(() {
                                                    panier.remove(panier[index]);
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                                                    Text('Retirer',style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.w500),),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                  ),


                ],
              )
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.8),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))
            ),
            height: MediaQuery.of(context).size.height*0.18,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.keyboard_arrow_up,color: Colors.white,size: 20,),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text('Swipe up pour passer votre commande',style: GoogleFonts.abel(color:Colors.white,fontSize: 14, fontWeight: FontWeight.w100),),
                ),
                Container(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Votre commande sera prise en charge dés que vous valider votre panier, vous pouvez la récupérer en vous déplaçant vers le magasin",style: GoogleFonts.abel(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.shopping_basket,color: Colors.white,size: 30,),
                      Text('Totale à payer : '+countTotal().toStringAsFixed(2)+" DA",style: GoogleFonts.abel(color:Colors.white,fontSize: 18, fontWeight: FontWeight.w500),),
                    ],
                  ),
                )
              ],
            ),
          ),
          showArrow: false,
        ),
      ),
    );
  }
}
