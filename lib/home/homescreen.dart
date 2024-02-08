// home_screen.dart
import 'package:bitsbond/home/chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _crushController = TextEditingController();
  List<User> selectedCrushes = [];
  List<User> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255,143,171),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                //SizedBox(
                //  width: 146,
                //),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  IconButton(
                    icon: Icon(
                      Icons.person_2_sharp,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navigate to profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chat_bubble_outline_sharp,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chat()),
                      );
                    },
                  )
                    
                              ],
                            ),
                ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255,179,198),

      // BODY:
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "People you'd like to date :",
                style: TextStyle(
                  fontSize: 25, 
                  fontWeight: FontWeight.w500,
                  fontFamily: 'LemonDays',
                  letterSpacing: 2),
              ),
              SizedBox(height: 2,),
              Text(
                'You can add up to 5 names',
                style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'LemonDays',
                    //fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w100),
              ),
              SizedBox(height: 5,),
              TextField(
                controller: _crushController,
                decoration: InputDecoration(
                  hintText: 'Search in caps lock :)',
                  hintStyle: TextStyle(
                    fontFamily: 'LemonDays',
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 255,143,171),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  _searchCrushSuggestions(value);
                },
              ),
              SizedBox(height: 5),
              //Text('Choose from suggestions:'),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suggestions[index].name,
                      /*style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ),*/),
                      subtitle: Text(suggestions[index].email,
                      /*style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ),*/
                      ),
                      onTap: () {
                        _addCrush(suggestions[index]);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Your Crush List:',
                    style: TextStyle(fontSize: 20, 
                      fontWeight: FontWeight.w500,
                      fontFamily: 'LemonDays',
                      letterSpacing: 2
                      )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedCrushes.map((crush) => Text(crush.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ))).toList(),
                    ),
                    //SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: _updateCrushList,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255,143,171)),
                      ),
                      child: Text('Save',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'LemonDays',
                        letterSpacing: 2
                      ),),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchCrushSuggestions(String searchText) {
    if (searchText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: searchText)
          .where('name', isLessThan: searchText + 'z')
          .get()
          .then((querySnapshot) {
        setState(() {
          suggestions = querySnapshot.docs
              .map((document) => User.fromDocument(document))
              .toList(); 
        });
      });
    } else {
      setState(() {
        suggestions.clear();
      });
    }
  }

  void _addCrush(User user) {
    setState(() {
      if (!_containsCrush(user.userId) && selectedCrushes.length < 5) {
        selectedCrushes.add(user);
      }
      _crushController.clear();
      suggestions.clear();
    });
  }

  bool _containsCrush(String crushUserId) {
    return selectedCrushes.any((user) => user.userId == crushUserId);
  }

  void _updateCrushList() {
    if (widget.userId.isNotEmpty) {
      // Get the list of crushes from selectedCrushes
      List<String> crushIds = selectedCrushes.map((user) => user.userId).toList();

      // Update the crushList field directly with the list of crushIds
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({'crushList': crushIds})
          .then((_) {
            if (mounted) {
              setState(() {
                print('Crush list updated successfully');
                _checkForMutualCrushes(crushIds);
              });
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {
                print('Error updating crush list: $error');
              });
            }
          });
    } else {
      print('Error: User ID is null or empty');
    }
  }

  void _checkForMutualCrushes(List<String> crushIds) {
    // Get the current user's ID
    String currentUserId = widget.userId;

    // Loop through each crush ID and check if the current user is also in their crush list
    for (String crushId in crushIds) {
      FirebaseFirestore.instance.collection('users').doc(crushId).get().then((snapshot) {
        if (snapshot.exists) {
          // Get the crush's crush list
          List<dynamic> crushCrushList = snapshot.get('crushList') ?? [];

          // Check if the current user is in their crush list
          if (crushCrushList.contains(currentUserId)) {
            // Update the profile for the matched crush
            _updateProfileForMatch(currentUserId, crushId);
          }
        }
      });
    }
  }

  void _updateProfileForMatch(String currentUserId, String matchedUserId) {
    // Update the current user's profile
    _updateUserMatch(currentUserId, matchedUserId);

    // Update the matched user's profile
    _updateUserMatch(matchedUserId, currentUserId);
  }

  void _updateUserMatch(String userId, String matchedUserId) {
    // Get the user document reference
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Update the user's profile to add the matched user's ID to their matches list
    userRef.update({
      'matches': FieldValue.arrayUnion([matchedUserId])
    }).then((_) {
      print('User $userId\'s profile updated successfully');
    }).catchError((error) {
      print('Error updating user $userId\'s profile: $error');
    });
  }
}

class User {
  final String userId;
  final String name;
  final String email;

  User({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory User.fromDocument(QueryDocumentSnapshot document) {
    return User(
      userId: document.id,
      name: document['name'] as String,
      email: document['email'] as String,
    );
  }
}
