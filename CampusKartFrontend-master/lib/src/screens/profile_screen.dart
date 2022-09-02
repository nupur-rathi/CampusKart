// profile screen is the container for the profile body
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/profile_page_body.dart';
import 'package:olx_iit_ropar/src/widgets/search_bar.dart';
import 'package:olx_iit_ropar/src/widgets/upload_product.dart';
import 'package:olx_iit_ropar/src/widgets/bottomappbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const <Widget>[
          TitleBar(),
          ProfilePageBody(),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
