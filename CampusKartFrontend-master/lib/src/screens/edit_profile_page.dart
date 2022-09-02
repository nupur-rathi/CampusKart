// Edit profile page
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/round_button.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/screens/home_screen.dart';
import 'package:olx_iit_ropar/models/user.dart' as AddUser;
import 'package:olx_iit_ropar/src/widgets/text_field_widget.dart';
import 'package:olx_iit_ropar/src/screens/profile_page_new.dart';
import 'package:olx_iit_ropar/apis/user_api.dart';
import 'package:olx_iit_ropar/src/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const TitleBar(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Your Profile",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Future builder is needed since there must be 
                //sync between the profile page values and the edit profile page values
                FutureBuilder<AddUser.User>(
                    future: current_user,
                    builder: (BuildContext context,
                        AsyncSnapshot<AddUser.User> snapshot) {
                      List<Widget> children;
                      // If the snapshot contains data from the profile page
                      if (snapshot.hasData) {
                        children = <Widget>[
                          const SizedBox(height: 20),
                          TextFieldWidget(
                            label: 'Full Name',
                            text: snapshot.data!.first_name != null
                                ? snapshot.data!.first_name as String
                                : "-",
                            onChanged: (name) {
                              snapshot.data!.first_name = name;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFieldWidget(
                            label: 'Phone No.',
                            text: snapshot.data!.phone_number != null
                                ? snapshot.data!.phone_number as String
                                : "-",
                            onChanged: (phoneNum) {
                              snapshot.data!.phone_number = phoneNum;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFieldWidget(
                            label: 'Email',
                            text: snapshot.data!.emailId != null
                                ? snapshot.data?.emailId as String
                                : "-",
                            onChanged: (email) {},
                          ),
                          const SizedBox(height: 30),
                          Center(child: _buildSaveButton(snapshot.data!)),
                        ];
                      } else { // else return empty text
                        children = <Widget>[const Text("Empty")];
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: children,
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Save button to send the data from the edit page back to the profile page
  Widget _buildSaveButton(AddUser.User user) {
    return MaterialButton(
      height: 50.0,
      minWidth: MediaQuery.of(context).size.width / 1.1,
      color: Color(primary_color),
      splashColor: const Color(0xff2CA4FF),
      // Only Indian phone numbers are valid for this application
      onPressed: () {
        if (user.phone_number != null &&
            !(user.phone_number!.startsWith("+91"))) {
          user.phone_number = "+91" + user.phone_number!;
        }
        Provider.of<UserProvider>(context, listen: false).UpdateUser(user);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
      child: const Text(
        'Save',
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      ),
    );
  }
}
