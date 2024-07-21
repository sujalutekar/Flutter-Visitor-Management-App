// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:adypkc/pages/admin_page.dart';
import 'package:adypkc/widgets/custom_button.dart';
import 'package:adypkc/widgets/custom_textfield.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPageLogin extends StatefulWidget {
  const AdminPageLogin({super.key});

  @override
  State<AdminPageLogin> createState() => _AdminPageLoginState();
}

class _AdminPageLoginState extends State<AdminPageLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = true;

  void togglePassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void login() {
    try {
      if (emailController.text.toLowerCase() == 'admin123@gmail.com' &&
          passwordController.text == 'Admin123') {
        // removing snackbar if any
        AnimatedSnackBar.removeAll();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminPage(),
          ),
        );
      } else {
        AnimatedSnackBar.removeAll();
        AnimatedSnackBar.material(
          'Invalid Credentials',
          type: AnimatedSnackBarType.error,
        ).show(context);

        return;
      }
    } catch (e) {
      AnimatedSnackBar.material(
        e.toString(),
        type: AnimatedSnackBarType.error,
      ).show(context);
      print(e.toString());
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   isAdmin();
  // }

  void isAdmin() async {
    //   CollectionReference collectionRef =
    //       FirebaseFirestore.instance.collection('users');

    //   DocumentSnapshot<Object?> querySnapshot =
    //       await collectionRef.doc(FirebaseAuth.instance.currentUser!.uid).get();

    //   final bool isAdmin = querySnapshot['isAdmin'];

    //   print('isAdmin: $isAdmin');

    try {
      // FirebaseAuth.instance.signInWithPhoneNumber('8698623998');
      // await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(
      //   email: emailController.text,
      //   password: passwordController.text,
      // )
      //     .then((value) async {
      //   print(value.user!.uid);

      //   String uid = value.user!.uid;

      //   DocumentSnapshot<Object?> querySnapshot =
      //       await FirebaseFirestore.instance.collection('users').doc(uid).get();

      //   final bool isAdminTrue = querySnapshot['isAdmin'];

      //   print('isAdminTrue: $isAdminTrue');
      // });
    } on FirebaseAuthException catch (e) {
      AnimatedSnackBar.material(
        e.toString(),
        type: AnimatedSnackBarType.error,
      ).show(context);

      print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xffF1F2FF),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Hero(
                tag: Icons.person,
                child: Icon(
                  Icons.person,
                  size: 200,
                ),
              ),
              // Login text
              const Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock),
                    SizedBox(width: 4),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        letterSpacing: 3,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              Container(
                child: Column(
                  children: [
                    // email
                    CustomTextField(
                      controller: emailController,
                      title: 'Email',
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),

                    // password
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              'Password',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  obscureText: _passwordVisible,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(0)
                                        .copyWith(left: 4),
                                    hintText: 'Password',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              IconButton(
                                onPressed: togglePassword,
                                icon: _passwordVisible
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // login button
              CustomButton(
                onPressed: () {
                  // login();
                  isAdmin();
                },
                title: 'Login',
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
