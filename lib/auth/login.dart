import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mymovies/auth/signup.dart';
import 'package:mymovies/page/main-page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool isLoading = false;
  bool isGoogleButtonLoading = false;

  showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 255, 101, 101),
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
      duration: const Duration(seconds: 1),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _login() async {
    bool error = false;
    isLoading = true;
    setState(() {});
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      error = true;
      if (e.code == 'user-not-found') {
        showSnackBar('User not found!');
      } else if (e.code == 'wrong-password') {
        showSnackBar('Invalid password!');
      } else {
        showSnackBar('Invalid email!');
        debugPrint("");
      }
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      isLoading = false;
      if (!error) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return MainPage();
        })));
      } else {
        setState(() {});
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _loginWithGoogle() {
    isGoogleButtonLoading = true;
    signInWithGoogle();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isGoogleButtonLoading = false;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return MainPage();
      })));
    } else {
      setState(() {});
    }
  }

  getSpinner() {
    return const SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusManager.instance.primaryFocus?.unfocus();
      }),
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 100,left: 10,right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Login',
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                            
                              });
                            },
                            icon: _passwordVisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off))),
                    onSubmitted: ((value) {
                      _login();
                    }),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 0, 53, 66),
                          onPrimary: Colors.white,
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        if (_emailController.text == "" ||
                            _passwordController.text == "") {
                          showSnackBar('Please fill out this fields!');
                        } else {
                          _login();
                        }
                      },
                      icon: isLoading ? getSpinner() : Container(),
                      label: const Text('Login to your account')),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 101, 130, 145),
                          onPrimary: Colors.white,
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        _loginWithGoogle();
                      },
                      icon: isGoogleButtonLoading
                          ? getSpinner()
                          : const FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                            ),
                      label: const Text('Login with google')),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('or'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have any account?"),
                      InkWell(
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: ((context) {
                          //   return SignUp();
                          // })));
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
