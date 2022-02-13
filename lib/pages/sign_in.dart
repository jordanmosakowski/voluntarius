import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:voluntarius/widgets/text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();
  bool creating = true;

  Future<void> createAccount() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken(
      vapidKey:
          "BAa6hVgOZDzYfEO62OfH7Kfvjfe1-8Am4gm9fYurJP0NR9nnELXzPK1e4PsX_rJdrfRC5d8lP_Bt0IIT_9WSX24",
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: pwController.text);
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .set(UserData(
            hasProfilePic: false,
            id: user.uid,
            averageStars: 0,
            notificationTokens: [if (token != null) token],
            numReviews: 0,
            name: nameController.text,
          ).toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signIn() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken(
      vapidKey:
          "BAa6hVgOZDzYfEO62OfH7Kfvjfe1-8Am4gm9fYurJP0NR9nnELXzPK1e4PsX_rJdrfRC5d8lP_Bt0IIT_9WSX24",
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: pwController.text);
      User? user = FirebaseAuth.instance.currentUser;
      UserData userData = UserData.fromFirestore(await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user!.uid)
          .get());
      if (token != null && user != null) {
        userData.notificationTokens.add(token);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update(userData.toJson());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'Incorrect Password',
            style: TextStyle(fontSize: 24, color: Colors.red),
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
              image: AssetImage('assets/colortransparentbk.png'),
              height: 75,
              width: 125),
          VoluntariusTextField(
            "Email",
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email';
              }
              return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)
                  ? null
                  : "Please enter a valid email";
            },
          ),
          if (creating)
            VoluntariusTextField(
              "Full Name",
              controller: nameController,
            ),
          VoluntariusTextField(
            "Password",
            controller: pwController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a password";
              }
              return null;
            },
          ),
          if (creating)
            VoluntariusTextField(
              "Confirm Password",
              controller: confirmPwController,
              obscureText: true,
              validator: (value) {
                print(value);
                print(pwController.text);
                if (value == pwController.text) {
                  return null;
                }
                return "Passwords do not match";
              },
            ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (creating) {
                  createAccount();
                } else {
                  signIn();
                }
              }
            },
            child: Text(creating ? "Create Account" : "Sign in"),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  creating = !creating;
                });
              },
              child: Text("Or ${creating ? "Sign in" : "Create Account"}"))
        ],
      ),
    ));
  }
}
