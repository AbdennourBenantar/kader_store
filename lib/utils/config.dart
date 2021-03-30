import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store{
  static const String appName = 'Store';
  static SharedPreferences sharedPreferences;
  static User user;
  static FirebaseAuth auth;
  static FirebaseFirestore firestore ;
  static String StoreCurrentUser="currentUser";

  //clients
  static final String clientName = 'clientName';
  static final String clientEmail = 'clientEmail';
  static final String clientPhotoUrl = 'clientPhotoUrl';
  static final String clientUID = 'clientUID';
  static final String clientPhone = 'clientPhone';
  static final String clientDate = 'clientDate';
  static final String clientLatitude = 'clientLatitude';
  static final String clientLongitude = 'clientLongitude';


  //store
  static final String storeName = 'storeName';
  static final String storeEmail = 'storeEmail';
  static final String storePhotoUrl = 'storePhotoUrl';
  static final String storeUID = 'storeUID';
  static final String storeLongitude ='storeLongitude';
  static final String storeLatitude ='storeLatitude';
  static final String storeOuvert="storeOuvert";


}