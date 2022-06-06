import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus{loading,signedIn,notSignedIn}

class AuthProvider with ChangeNotifier{

  AuthStatus status = AuthStatus.loading;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  String docId = '';

  Map<String,dynamic> userCredentials = {
    'phoneNumber' : '',
    'email' : '',
    'storeName' : '',
    'salesGraph' : {}
  };

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // sign in with credential
     await FirebaseAuth.instance.signInWithCredential(credential);
  }


  Future<void> googleSignIn() async {
    // Initialize Firebase
    User? user;

    // The `GoogleAuthProvider` can only be used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential = await _auth.signInWithPopup(authProvider);

      user = userCredential.user;
    } catch (e) {
      print(e);
    }

    if (user != null) {
      // uid = user.uid;
      // name = user.displayName;
      // userEmail = user.email;
      // imageUrl = user.photoURL;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('auth', true);
      prefs.setString('email', user.email!);
      userCredentials['email'] = user.email!;
      handleAuth(false);
      setUserDetails();
      print(user.email);
      //
    }
  }

  //save user details to firebase
  void setUserDetails() async{
    print('setting details');
    var exists = await FirebaseFirestore.instance.collection('webUsers').where('email',isEqualTo: userCredentials['email']).get();
    //check if the document exits
    if(exists.docs.isNotEmpty) {
      docId = exists.docs[0].id;
      userCredentials = exists.docs[0].data();
      //upon entering a new year the graph year is updated and sales are reset
      resetGraph();
    }else{
      print('does not exist');
      setGraph();
      //if not we create new account details
      var collection = FirebaseFirestore.instance.collection('webUsers');
      await collection.add(userCredentials);
    }
  }

  //save user details to firebase
  void getUserDetails() async{
    var collection = FirebaseFirestore.instance.collection('webUsers').where('email',isEqualTo: userCredentials['email']);
    final snapshots = await collection.get();
    docId = snapshots.docs[0].id;
    userCredentials = snapshots.docs[0].data();
    print(snapshots.docs[0].data());
  }



  handleAuth(bool getUserData) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool authSignedIn = prefs.getBool('auth') ?? false;
    String savedEmail = prefs.getString('email') ?? '';

    if(savedEmail.isNotEmpty){
      userCredentials['email'] = savedEmail;
    }

    print('is the user signed in?');

    print(authSignedIn);

    if(authSignedIn){
      if(getUserData){
        print('getting user data');
        getUserDetails();
      }
      status = AuthStatus.signedIn;
      notifyListeners();
    }else{
      status = AuthStatus.notSignedIn;
      notifyListeners();
    }

  }

  void logOut() async{
   //r  await _googleAuth.signOut();
     _auth.signOut();
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setBool('auth', false);
     handleAuth(false);
  }

  void setGraph(){
    int year = DateTime.now().year;

    Map<String, dynamic> defaultGraph = {
      '1-$year' : 0.0,
      '2-$year' : 0.0,
      '3-$year' : 0.0,
      '4-$year' : 0.0,
      '5-$year' : 0.0,
      '6-$year' : 0.0,
      '7-$year' : 0.0,
      '8-$year' : 0.0,
      '9-$year' : 0.0,
      '10-$year' : 0.0,
      '11-$year' : 0.0,
      '12-$year' : 0.0,
      'year' : year
    };

    if(userCredentials['salesGraph'].isEmpty){
      userCredentials['salesGraph'] = defaultGraph;
    }else{
      resetGraph();
    }
  }


  void resetGraph() async{
    int year = DateTime.now().year;

    if(year > userCredentials['salesGraph']['year']){
    userCredentials['salesGraph'] =  {
        '1-$year' : 0.0,
    '2-$year' : 0.0,
    '3-$year' : 0.0,
    '4-$year' : 0.0,
    '5-$year' : 0.0,
    '6-$year' : 0.0,
    '7-$year' : 0.0,
    '8-$year' : 0.0,
    '9-$year' : 0.0,
    '10-$year' : 0.0,
    '11-$year' : 0.0,
    '12-$year' : 0.0,
    'year' : year
  };
      var collection = FirebaseFirestore.instance.collection('webUsers');
      await collection.doc(docId).update(userCredentials);
    }



  }




}