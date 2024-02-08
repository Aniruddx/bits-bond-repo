import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bitsbond/Authentication/login_screen.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255,143,171),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                  fontSize: 40, 
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'CandyLove',
                  letterSpacing: 2
              ),
            ),
          ],
        ),
      ),
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(getUserId()).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var userData = snapshot.data?.data() as Map<String, dynamic>;
        var name = userData['name'] ?? 'No Name';
        var email = userData['email'] ?? 'No Email';
        var crushList = (userData['crushList'] as List<dynamic>?) ?? [];

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').where('crushList', arrayContains: getUserId()).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var numberOfCrushes = snapshot.data?.docs.length ?? 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25, 
                        fontWeight: FontWeight.w500,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ),
                    ),
                  ],
                ),            
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Text(
                      '$name', 
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15, 
                        //fontWeight: FontWeight.w500,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25, 
                        fontWeight: FontWeight.w500,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ),
                    ),
                  ],
                ), 
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Text(
                      '$email', 
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15, 
                        //fontWeight: FontWeight.w500,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Flexible(
                      child: Text(
                        'People Crushing on You: $numberOfCrushes',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25, 
                          fontWeight: FontWeight.w500,
                          fontFamily: 'LemonDays',
                          letterSpacing: 2
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Text(
                      'Your Crush List:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25, 
                        fontWeight: FontWeight.w500,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: crushList.map<Widget>((crushId) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(crushId).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            var crushUserData = snapshot.data?.data() as Map<String, dynamic>;
                            var crushName = crushUserData['name'] ?? 'Unknown';
                            return Text(crushName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.5,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 100),
                
                // Display matched users
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10,),
                        Text(
                          'Your Matches: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25, 
                            fontWeight: FontWeight.w500,
                            fontFamily: 'LemonDays',
                            letterSpacing: 2
                          ),
                        ),
                        Text(
                          '[Meet them :)]',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15, 
                            fontWeight: FontWeight.w500,
                            fontFamily: 'LemonDays',
                            letterSpacing: 2
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').where('matches', arrayContains: getUserId()).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('No matches yet.');
                        }
                        var matches = snapshot.data!.docs;
                        return Column(
                          children: matches.map<Widget>((match) {
                            var matchName = match['name'];
                            return Text(matchName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.5,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 120),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {
                        logout(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255,143,171)),
                      ),
                      child: Text('Logout',
                      style: TextStyle(
                        color: Colors.black,
                            fontSize: 10, 
                            fontWeight: FontWeight.w500,
                            fontFamily: 'LemonDays',
                            letterSpacing: 2
                      ),),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  String getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  Future<void> logout(BuildContext context) async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
