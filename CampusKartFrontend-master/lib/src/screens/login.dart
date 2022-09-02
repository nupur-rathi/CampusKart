import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/category_api.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/models/image.dart';
import 'package:olx_iit_ropar/src/widgets/round_button.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:olx_iit_ropar/apis/token_api.dart';
import 'package:olx_iit_ropar/models/token.dart';
import 'package:olx_iit_ropar/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olx_iit_ropar/src/screens/home_screen.dart';
//code for designing the UI of our text field where the user writes his/her email id or password

// String? user_device_token;

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; //to show or hide the password
  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();
  bool isButtonDisabled = false;  //to disable the login button after clicking it once

  // function to resent the password
  _passwordReset() async {
    try {
      _formKey.currentState?.save();
      // send email to reset password
      final user = await _auth.sendPasswordResetEmail(email: email);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Password Reset'),
          // mail could reach the spam folder
          content: const Text(
              'A message has been sent to you by email with instructions on how to reset your password. If you did not receive an email, check your Spam or Junk email folders.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ); //check for error here, incase of invalid email or password
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email" || e.code == "user-not-found") {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Invalid Email'),
            content: const Text(
                'This email id is not registered with this app. Please try again'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Picture> imageList = [];
    final productsP = Provider.of<ProductsProvider>(context);
    final picturesP = Provider.of<PictureProvider>(context);

    _loginUser() async {
      setState(() {
        isButtonDisabled = true;
      });
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (user.user!.emailVerified) {
          String? token = await FirebaseMessaging.instance.getToken();

          if (token != null) {
            String username = email.substring(0, email.length - 13);
            Token device_token = Token(token: token, username: username);
            Token? returned_token =
                await Provider.of<TokenProvider>(context, listen: false)
                    .addToken(device_token);

            if (returned_token != null) {
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('token_id', returned_token.id!);
            }
          }

          await Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const MyHomePage(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == "invalid-email" || e.code == "user-not-found") {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Invalid Email'),
              content: const Text(
                  'This email id is not registered with this app. Please try again'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        if (e.code == "wrong-password") {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Wrong Password'),
              content: const Text('Password Incorrect'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
      setState(() {
        isButtonDisabled = false;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Login with email',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black)),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.left,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(primary_color), width: 0.75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(primary_color), width: 1.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: _obscureText,
                textAlign: TextAlign.left,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password.',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(primary_color), width: 0.75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(primary_color), width: 1.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: isButtonDisabled
                          ? const Color.fromARGB(180, 0, 53, 49)
                          : myColor,
                    ),
                    onPressed: () async {
                      isButtonDisabled ? null : _loginUser();
                    }),
              ),
              TextButton(
                onPressed: () {
                  _passwordReset();
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
