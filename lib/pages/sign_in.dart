import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voluntarius/classes/user.dart';
import 'package:voluntarius/widgets/text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({ Key? key }) : super(key: key);

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

  Future<void> createAccount() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: pwController.text
      );
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set(UserData(
        id: user.uid, 
        averageStars: 0, 
        notificationTokens: [], 
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

  Future<void> signIn() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: pwController.text
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
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
            Text("LOGO PLACEHOLDER"),
            VoluntariusTextField(
              "Email",
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid email';
                }
                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ? null : "Please enter a valid email";
              },
            ),
            if(creating)
              VoluntariusTextField("Full Name", controller: nameController,),
            VoluntariusTextField(
              "Password",
              controller: pwController,
              obscureText: true,
              validator: (value){
                 if(value == null || value.isEmpty ){
                   return "Please enter a password";
                 }
                return null;
               },
              ),
            if(creating)
              VoluntariusTextField("Confirm Password",
               controller: confirmPwController,
               obscureText: true,
               validator: (value){
                 print(value);
                 print(pwController.text);
                 if(value == pwController.text){
                   return null;
                 }
                 return "Passwords do not match";
               },
              ),
            ElevatedButton(
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  if(creating){
                    createAccount();
                  }
                  else{
                    signIn();
                  }
                }
              },
              child: Text(creating ? "Create Account" : "Sign in"),
            ),
            TextButton(
              onPressed: (){
                setState((){
                  creating = !creating;
                });
              }, 
              child: Text("Or ${creating ? "Sign in" : "Create Account"}")
              )
          ],
        ),
      )
    );
  }
}