// Registeration screen
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx_iit_ropar/apis/user_api.dart';
import 'package:olx_iit_ropar/src/widgets/round_button.dart';
import 'package:olx_iit_ropar/models/user.dart' as AddUser;
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:provider/provider.dart';


const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;
  final _auth = FirebaseAuth.instance;
  String email = "HI";
  late String password;

  bool showWarning = false;
  bool showPWarning = false;

  // show warninf to keep the domain in iitrpr
  void setWarning(bool input) {
    setState(() {
      showWarning = input;
    });
  }

  // warnings for min 6 length password
  void setPWarning(bool input) {
    setState(() {
      showPWarning = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Sign up with email',
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black)),
            ),
            if (showWarning)
              const Text('Domain must be IIT ROPAR',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, color: Colors.red)),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.left,
              onChanged: (value) {
                RegExp regExp = RegExp(
                  r".*@iitrpr\.ac\.in$",
                  caseSensitive: false,
                  multiLine: false,
                );
                if (regExp.hasMatch(value)) {
                  setWarning(false);
                  email = value;
                } else {
                  setWarning(true);
                }
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your IIT Ropar email',
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            if (showPWarning)
              const Text('Password must be atleast 6 characters long',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, color: Colors.red)),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              obscureText: _obscureText,
              textAlign: TextAlign.left,
              onChanged: (value) {
                if (value.length >= 6) {
                  setPWarning(false);
                  password = value;
                } else {
                  setPWarning(true);
                }
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your Password',
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
              height: 20.0,
            ),
            const SizedBox(
              height: 24.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                  'An email will be sent to you, Verify to complete registration. If you did not receive an email, check your Spam or Junk email folders.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15)),
            ),
            RoundButton(
              colour: Colors.blueAccent,
              title: 'Register',
              onPressed: () async {
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);

                  await newUser.user
                      ?.sendEmailVerification(); //for sending verification email
                  if (newUser != null) {
                    Navigator.pushNamed(context, '/login_screen');
                    String username = email.substring(0, email.length - 13);
                    final AddUser.User user =
                        AddUser.User(username: username, emailId: email);
                    Provider.of<UserProvider>(context, listen: false)
                        .addUser(user);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
