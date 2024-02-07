import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitsbond/home/homescreen.dart' show HomeScreen;
//import 'package:bitsbond/Authentication/image.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailtextEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 130),
              Image.asset(
                "images/logo2wbg.png",
              ),
              SizedBox(height: 90),
              _customGoogleSignInButton(context),
              SizedBox(height: 225),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customGoogleSignInButton(BuildContext context) {
    return Container(
      height: 40,
      child: MaterialButton(
        elevation: 5,
        onPressed: () {
          googleLogin(context);
        },
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'BITS Email Login',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  googleLogin(BuildContext context) async {
    print("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      var finalResult = await _auth.signInWithCredential(credential);

      print("Result $finalResult");
      print(finalResult.user!.displayName);
      print(finalResult.user!.email);
      print(finalResult.user!.photoURL);

      await storeUserDataInFirestore(finalResult.user!, finalResult.user!.photoURL!);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(userId: finalResult.user!.uid,),
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  Future<void> storeUserDataInFirestore(User user, String photoUrl) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      await users.doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'photoUrl': photoUrl,
      });
    } catch (error) {
      print("Error storing user data in Firestore: $error");
    }
  }
}
 /*checkifUserLoggedIn(User? user){
  if(user == null){

  }
  else {
    Get.to(HomeScreen(userId: '',));
  }
 }
 @override 
 void onReady(){

 }*/