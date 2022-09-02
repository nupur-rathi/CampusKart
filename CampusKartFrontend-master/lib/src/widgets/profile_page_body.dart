// This page shows the whole profile page of the user
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:olx_iit_ropar/src/screens/edit_profile_page.dart';
import 'package:olx_iit_ropar/src/screens/login.dart';
import 'package:olx_iit_ropar/src/widgets/round_button.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/screens/home_screen.dart';
import 'package:olx_iit_ropar/models/user.dart' as AddUser;
import 'package:provider/provider.dart';
import 'package:olx_iit_ropar/apis/token_api.dart';
import 'package:olx_iit_ropar/apis/user_api.dart';
import '../../apis/liked_product_api.dart';
import '../../apis/product_api.dart';
import '../../utils/functions.dart';
import 'package:olx_iit_ropar/models/user_image.dart';
import 'package:olx_iit_ropar/apis/user_image_api.dart';
import 'package:olx_iit_ropar/src/widgets/select_remove_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageBody extends StatefulWidget {
  const ProfilePageBody({Key? key}) : super(key: key);

  @override
  _ProfilePageBodyState createState() => _ProfilePageBodyState();
}

class _ProfilePageBodyState extends State<ProfilePageBody> {
  final _auth = FirebaseAuth.instance;
  String url =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  List<Media> images = <Media>[];
  var username = "";
  UserImageProvider? uip;

  Future<void> pickImages() async {
    List<Media> resultList = <Media>[];
    String error = 'No Error Detected';
    try {
      resultList = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 1,
          showGif: false,
          showCamera: true,
          compressSize: 500,
          uiConfig: UIConfig(uiThemeColor: const Color(0xffff0f50)),
          cropConfig: CropConfig(enableCrop: false, width: 2, height: 1));
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });

    UserImage user_image =
        UserImage(username: username, image: images[0].path!);

    Provider.of<UserImageProvider>(context, listen: false)
        .addUserImage(user_image);

    if (uip != null) {
      uip!.fetchUserImage(username);

      if (uip!.l != null) {
        setState(() {
          url = uip!.l!.image;
        });
      }
    }
  }

  void removePhoto() {
    setState(() {
      url =
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
    });
    UserImage user_image = UserImage(username: username, image: url);
    Provider.of<UserImageProvider>(context, listen: false)
        .deleteUserImage(user_image);
  }

  Widget _buildTitleProfile() {
    return const Text(
      "Profile",
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSizedBox(double size) {
    return SizedBox(
      height: size,
    );
  }

  Widget _buildSignOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 45),
          primary: Color(0xFF8A0D02),
          textStyle: const TextStyle(fontSize: 18)),
      child: const Text('Sign Out'),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        var user_device_token = prefs.getString('token_id');
        prefs.remove('token_id');
        Provider.of<TokenProvider>(context, listen: false)
            .deleteToken(user_device_token!);
        _auth.signOut();
        Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
      },
    );
  }

  Widget _buildSubTitles(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SelectProfileImage(removePhoto, pickImages);
          },
        );
      },
      child: Container(
        height: 120.0,
        width: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.0),
          boxShadow: const [
            BoxShadow(
                blurRadius: 3.0, offset: Offset(0, 4.0), color: Colors.black38),
          ],
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileName() => FutureBuilder<AddUser.User>(
      future: current_user, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<AddUser.User> snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!.first_name != null
                ? snapshot.data!.first_name as String
                : "-",
            style: TextStyle(
              fontSize: 15.0,
            ),
          );
        } else {
          return const Text(
            "Warning snapshot name empty",
            style: TextStyle(
              fontSize: 15.0,
            ),
          );
        }
      });

  Widget _buildProfileMail() => FutureBuilder<AddUser.User>(
      future: current_user, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<AddUser.User> snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!.emailId != null
                ? snapshot.data!.emailId as String
                : "-",
            style: const TextStyle(
              fontSize: 15.0,
            ),
          );
        } else {
          return const Text(
            "Warning snapshot email empty",
            style: TextStyle(
              fontSize: 15.0,
            ),
          );
        }
      });

  Widget _buildProfileUserName() => FutureBuilder<AddUser.User>(
      future: current_user, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<AddUser.User> snapshot) {
        if (snapshot.hasData) {
          return ListTile(
            contentPadding: const EdgeInsets.all(0.0),
            title: const Text("Username"),
            trailing: Text(
              snapshot.data!.emailId != null
                  ? snapshot.data!.emailId
                      .substring(0, snapshot.data!.emailId.length - 13)
                  : "-",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return const Text(
            "Warning snapshot username empty",
            style: TextStyle(
              fontSize: 15.0,
            ),
          );
        }
      });

  Widget _buildProfilePhone() => FutureBuilder<AddUser.User>(
      future: current_user, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<AddUser.User> snapshot) {
        if (snapshot.hasData) {
          return ListTile(
            contentPadding: const EdgeInsets.all(0.0),
            title: const Text("Phone No."),
            trailing: Text(
              snapshot.data!.phone_number != null
                  ? snapshot.data!.phone_number as String
                  : "-",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return const Text(
            "Warning snapshot phone empty",
            style: TextStyle(
              fontSize: 15.0,
            ),
          );
        }
      });

  Widget _buildAccountCardTiles(String title, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEditButton() => ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditProfilePage()),
          );
        },
        icon: const Icon(
          Icons.edit_outlined,
        ),
        label: const Text('Edit'), // <-- Text
      );

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildProfileName(),
        _buildSizedBox(10.0),
        _buildProfileMail(),
        _buildSizedBox(10.0),
        _buildEditButton(),
      ],
    );
  }

  Widget _buildTopProfileContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildProfileImage(),
        const SizedBox(
          width: 25.0,
        ),
        _buildProfileInfo(),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.grey,
    );
  }

  Widget _buildAccountCard() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildProfileUserName(),
              _buildDivider(),
              _buildProfilePhone(),
              _buildDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWLCardTiles() {
    final likedP = Provider.of<LikedProductsProvider>(context, listen: true);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      title: const Text("Your Wishlist"),
      trailing: IconButton(
        onPressed: () async {
          EasyLoading.show(
            status: 'loading...',
            maskType: EasyLoadingMaskType.black,
          );
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          print(user!.email);
          var username = user.email!.substring(0, user.email!.length - 13);
          await likedP.fetchLikedProducts(username);
          EasyLoading.dismiss();
          Navigator.pushNamed(context, '/wishlist_screen');
        },
        icon: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }

  Widget _buildUCardTiles() {
    final productsP = Provider.of<ProductsProvider>(context, listen: false);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      title: const Text("Your Uploads Store"),
      trailing: IconButton(
        onPressed: () async {
          var u_id = getUser();
          EasyLoading.show(
            status: 'loading...',
            maskType: EasyLoadingMaskType.black,
          );
          await productsP.fetchStoreProducts(u_id);
          EasyLoading.dismiss();
          Navigator.pushNamed(context, '/store_page');
        },
        icon: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }

  Widget _buildOtherCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildWLCardTiles(),
              _buildDivider(),
              _buildUCardTiles(),
              _buildDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMain() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitleProfile(),
            _buildSizedBox(30.0),
            _buildTopProfileContainer(),
            _buildSizedBox(50.0),
            _buildSubTitles("Account"),
            _buildSizedBox(20.0),
            _buildAccountCard(),
            _buildSizedBox(30.0),
            _buildSubTitles("Other"),
            _buildSizedBox(20.0),
            _buildOtherCard(),
            _buildSizedBox(40.0),
            _buildSignOutButton(),
            _buildSizedBox(60.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    uip = Provider.of<UserImageProvider>(context, listen: false);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    print(user!.email);

    username = user.email!.substring(0, user.email!.length - 13);

    uip!.fetchUserImage(username);

    if (uip!.l != null) {
      setState(() {
        url = uip!.l!.image;
      });
    }

    return _buildProfileMain();
  }
}
