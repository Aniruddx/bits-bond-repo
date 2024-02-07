import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bitsbond/Authentication/imageclass.dart';
import 'package:bitsbond/home/homescreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageSelectionScreen extends StatefulWidget {
  final String userId;

  const ImageSelectionScreen({required this.userId});

  @override
  State<ImageSelectionScreen> createState() => _ImageSelectionScreenState();
}

class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
  var authenticationController = AuthenticationController.authController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 111, 201, 242),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Add a profile Image',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Text(
            'Add a profile image to make it easier for your crush to find you :)',
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
          authenticationController.imageFile == null
              ? const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.cyan,
                )
              : Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: FileImage(File(authenticationController.imageFile!.path)),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await authenticationController.pickImageFileFromGallery();

                  // Upload image to Firestore and get the URL
                  String imageUrl = await uploadImage(authenticationController.imageFile! as File);

                  // Update user profile with the image URL
                  await updateProfileImage(widget.userId, imageUrl);

                  setState(() {});
                  navigateToHomeScreen(context);
                },
                icon: const Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  Future<void> updateProfileImage(String userId, String imageUrl) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profileImage': imageUrl,
    });
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(userId: widget.userId),
      ),
    );
  }
}
