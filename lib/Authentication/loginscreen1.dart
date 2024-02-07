import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:sign_in_button/sign_in_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitsbond/home/homescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailtextEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        //_user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 130,),
              Image.asset(
                "images/logo2wbg.png",
              ),
              SizedBox(height: 90,),
              _customGoogleSignInButton(context),
              SizedBox(height: 225,),
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
        elevation: 15,
        onPressed: () {
          googleLogin(context);
        },
        color: Color.fromARGB(255, 111, 201, 242),
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
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return;
      }

      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Result $result");
      print(result.displayName);
      print(result.email);
      print(result.photoUrl);

      await storeUserDataInFirestore(finalResult.user!);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(userId: '',),
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  Future<void> storeUserDataInFirestore(User user) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      await users.doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
      });
    } catch (error) {
      print("Error storing user data in Firestore: $error");
    }
  }
}
