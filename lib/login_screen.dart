import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              onTap: () {
                setState(() {
                  visible = false;
                });
              },
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              onTap: () {
                setState(() {
                  visible = false;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim());

                  //
                  final ref = FirebaseDatabase.instance.ref();
                  final snapshot = await ref
                      .child('users/${FirebaseAuth.instance.currentUser!.uid}')
                      .get();
                  if (snapshot.exists) {
                    final x = jsonDecode(snapshot.value!.toString());
                    print(x);
                  } else {
                    print('No data available.');
                  }

                  //
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    visible = true;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_open),
                  Text("Sign In"),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: visible,
              child: const Text(
                "Incorrect email or password!",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: 10,
              child: Divider(
                thickness: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No Account?"),
                TextButton(
                    onPressed: () {
                      // Navigator.of(context)
                      //     .pushReplacementNamed("/signupscreen");
                      Navigator.of(context).pushNamed("/signupscreen");
                    },
                    child: Text("Sign up")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
