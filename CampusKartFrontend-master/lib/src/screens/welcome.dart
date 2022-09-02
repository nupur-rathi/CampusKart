// The first screen a user is directed to. Contains options for registration and login
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.0,
                  height: MediaQuery.of(context).size.width / 2.0,
                  child: Ink.image(
                    image: AssetImage("lib/assets/logos/shopping-cart.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('CampusKart',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.black)),
                ),
                RoundButton(
                  colour: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, '/login_screen');
                  },
                ),
                RoundButton(
                    colour: Colors.blueAccent,
                    title: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup_screen');
                    }),
              ]),
        ));
  }
}
