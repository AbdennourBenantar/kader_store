import 'package:cloud_firestore/cloud_firestore.dart';

class Option{
  final int id;
  final String imagePath;

  Option({this.id, this.imagePath});
}
final options=[
  Option(id:1,imagePath: 'assets/coffee.png'),
  Option(id:2,imagePath: 'assets/donut.png'),
  Option(id:3,imagePath: 'assets/softdrinks.png'),
  Option(id:4,imagePath: 'assets/more.png'),
];
class Comm{
  QueryDocumentSnapshot produit;
  Comm(this.produit);
}
List<Comm> panier=[];
List<Comm> history=[];