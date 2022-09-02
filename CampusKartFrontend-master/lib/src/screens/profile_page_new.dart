// Test code
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/screens/edit_profile_page.dart';
import 'package:olx_iit_ropar/src/widgets/round_button.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/screens/home_screen.dart';
import 'package:olx_iit_ropar/models/user.dart' as AddUser;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      const TitleBar(),
      Column(
        children: [
          _buildTitleProfile(),
          const SizedBox(height: 8),
          buildName(),
          const SizedBox(height: 8),
          Center(child: buildEditButton()),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
        ],
      ),
    ]));
  }

  Widget buildName() => FutureBuilder<AddUser.User>(
      future: current_user, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<AddUser.User> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = <Widget>[
            Text(
              snapshot.data!.first_name != null
                  ? snapshot.data!.first_name as String
                  : "-",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              snapshot.data!.emailId != null
                  ? snapshot.data?.emailId as String
                  : "-",
              style: const TextStyle(color: Colors.grey),
            )
          ];
        } else {
          children = <Widget>[
            const Text(
              "Warning snapshot empty",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 4),
            const Text(
              "snapshot empty",
              style: TextStyle(color: Colors.grey),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
        // throw ("Warning in the profile page");
      });

  Widget buildEditButton() => ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditProfilePage()),
          );
        },
        icon: const Icon(
          Icons.edit_outlined,
        ),
        label: Text('Edit'), // <-- Text
      );

  Widget _buildTitleProfile() {
    return const Text(
      "Profile",
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
