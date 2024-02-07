import 'dart:io';

import 'package:bitsbond/Authentication/imageclass.dart';
import 'package:flutter/material.dart';

class Image extends StatefulWidget {
  final String userId;
  const Image({super.key, required this.userId});
  

  //HomeScreen({required this.userId});

  @override
  State<Image> createState() => _ImageState();
}

class _ImageState extends State<Image> {
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
            Text('Add a profile Image',
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),)
          ],
        ),
      ),
      body: Column(
        children: [
          Text('Add a profile image to make it easier for your crush to find you :)',
          style: TextStyle(
                color: Colors.black,
                //fontSize: 24,
                //fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              ),

              authenticationController.imageFile == null ?
              const CircleAvatar(
                radius: 80,
                //backgroundImage: ,
                backgroundColor: Colors.cyan,
              ) : Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: FileImage(
                      File(
                        authenticationController.imageFile!.path,
                      )
                    )
                  )
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async 
                    {
                    await authenticationController.pickImageFileFromGallery();
                    setState(() {
                      authenticationController.imageFile;
                    });
                  }, 
                  icon: const Icon(Icons.image,
                  color: Colors.white,
                  size: 30,
                  )
                  )
                ],
              )

              /*GestureDetector(
                authenticationController.imageFile == null ?
                const CircleAvatar(
                  radius: 80,
                  //backgroundImage: ,
                ) : Container(

                ),
                /*onTap: () async {
                  await authenticationController.pickImageFileFromGallery();
                },*/
                
              )*/
        ],
      ),
    );
  }
}