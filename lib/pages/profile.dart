import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/pdfgen.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/text_field.dart';
import 'chat.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> uploadImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    final ImagePicker _picker = ImagePicker();
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img == null) {
      return;
    }
    Uint8List raw = await img.readAsBytes();
    Reference ref = FirebaseStorage.instance.ref('pictures/${user?.uid}');
    try {
      await ref.putData(raw);
      String url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        "hasProfilePic": true,
      });
      setState(() {
        image = url;
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  String? image = null;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);
    if (image == null && userData.hasProfilePic) {
      FirebaseStorage.instance
          .ref('pictures/${userData.id}')
          .getDownloadURL()
          .then((a) => setState(() => image = a));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatPage("allchat"))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (userData.hasProfilePic && image != null)
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: userData.hasProfilePic
                          ? DecorationImage(
                              fit: BoxFit.fill,
                              image: userData.hasProfilePic
                                  ? NetworkImage(image!)
                                  : (AssetImage("assets/defaultProfile.png")
                                      as ImageProvider))
                          : null,
                    ),
                  ),
                ElevatedButton.icon(
                    onPressed: uploadImage,
                    icon: Icon(Icons.upload,
                        color: userData.hasProfilePic
                            ? Colors.white
                            : Colors.black,
                        size: 30),
                    label: Text("Upload Profile Picture")),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(userData.name,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext) =>
                        _buildPopupDialog(context, userData.name, userData.id),
                  );
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star),
              Text(
                  " ${userData.averageStars.toStringAsFixed(2)} (${userData.numReviews} reviews)",
                  style: TextStyle(fontSize: 17)),
            ],
          ),
          Center(
            child: ElevatedButton(
              child: Text("Print PDF"),
              onPressed: () async {
                if (!kIsWeb) {
                  Printing.sharePdf(
                      bytes: await generateDocument(
                          PdfPageFormat.letter, userData),
                      filename: 'my-document.pdf');
                } else {
                  Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) =>
                          generateDocument(format, userData));
                }
              },
            ),
          ),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text("Sign Out")))
        ],
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, String cName, String uid) {
    final nameController = TextEditingController(text: cName);
    return AlertDialog(
      title: Text("Enter New Name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VoluntariusTextField(
            "Full Name",
            controller: nameController,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel")),
        ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid)
                  .update({"name": nameController.text});
              Navigator.of(context).pop();
            },
            child: const Text("Submit")),
      ],
    );
  }
}
