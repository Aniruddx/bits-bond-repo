import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
              'SPARK',
              style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'CandyLove',
                    letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SizedBox(width: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(width: 10,),
                    Text(
                      'Coming Soon !',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25, 
                        fontWeight: FontWeight.w500,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(width: 10,),
                      Flexible(
                        child: Text(
                          'Encourage your friends (and your crush :p) to sign up now. More friends, more matches, more LOVE!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15, 
                            fontWeight: FontWeight.w500,
                            fontFamily: 'LemonDays',
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(width: 10,),
                    Text(
                      'to sign up now. More friends, more matches,',
                      style: TextStyle(
                        color: Colors.black,
                          fontSize: 15, 
                          fontWeight: FontWeight.w500,
                          fontFamily: 'LemonDays',
                          letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(width: 10,),
                    Text(
                      'more LOVE!',
                      style: TextStyle(
                        color: Colors.black,
                          fontSize: 15, 
                          fontWeight: FontWeight.w500,
                          fontFamily: 'LemonDays',
                          letterSpacing: 2,
                      ),
                    ),
                  ],
                ),*/
        ],
      ),
    );
  }
}