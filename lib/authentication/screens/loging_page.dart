import 'package:adypkc/pages/home_page.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/text_field.dart';

class LogingPage extends StatefulWidget {
  final Function() onTap;

  const LogingPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LogingPage> createState() => _LogingPageState();
}

class _LogingPageState extends State<LogingPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  Future<bool> isVerified(String uid) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> querySnapshot =
        await collectionRef.doc(uid).get();

    final bool isVerified = querySnapshot['verified'];

    return isVerified;
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) async {
        String uid = value.user!.uid;

        bool verified = await isVerified(uid);
        print('Verified: $verified');

        if (verified) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        } else {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          return AnimatedSnackBar.material(
            'You don\'t have permission',
            type: AnimatedSnackBarType.error,
          ).show(context);
        }
      });
    } on FirebaseAuthException catch (e) {
      showAlertDialog(e.code);
      print(e.code);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F2FF),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // icon
                      const Icon(
                        Icons.lock,
                        size: 100,
                      ),

                      // welcome message
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      // email textfield
                      const SizedBox(
                        height: 50,
                      ),
                      MyTextfield(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      // password textfield
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextfield(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),

                      // signin button
                      const SizedBox(
                        height: 10,
                      ),
                      MyButton(
                        text: 'Sign In',
                        onTap: signIn,
                      ),

                      // go to register page
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
