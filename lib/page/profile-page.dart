import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymovies/auth/login.dart';
import 'package:mymovies/model/movie.model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;

  logOut() {
    try {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return const LoginPage();
      })));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1.5,
        title: const Text('Profile'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    user!.photoURL == null
                        ? Icon(
                            Icons.account_circle,
                            size: 85,
                            color: Colors.grey.withOpacity(0.2),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 40,
                            backgroundImage: NetworkImage(
                              user!.photoURL.toString(),
                            )),
                    const SizedBox(
                      height: 5,
                    ),
                    user!.displayName == null
                        ? const Text('Username')
                        : Text(user!.displayName!),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      user!.email!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                    elevation: 0,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    minimumSize: const Size(double.infinity, 50)),
                icon: const Icon(
                  Icons.logout,
                  size: 16,
                  color: Colors.black,
                ),
                onPressed: () {
                  logOut();
                },
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
