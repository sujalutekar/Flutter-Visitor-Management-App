import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adypkc/pages/admin_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Hero(
                tag: Icons.person,
                child: Icon(
                  Icons.person,
                  size: 100,
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                return Text('${snapshot.data?['name'] ?? 'Unknown'}');
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      AnimatedSnackBar.removeAll();

                      return const AdminPage();
                    },
                  ),
                );
              },
              leading: const Icon(Icons.lock_person_rounded),
              title: const Text(
                'Admin',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            const Spacer(),
            const Divider(),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            try {
                              Navigator.of(context).pop(true);
                              await FirebaseAuth.instance.signOut();
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  },
                );
              },
              leading: const Icon(Icons.logout_rounded),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
          ],
        ),
      ),
    );
  }
}
