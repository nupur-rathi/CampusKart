// Dialogue for contacting the seller(email, whatsApp, call, message)
import 'package:firebase_auth/firebase_auth.dart' as UserF;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/models/user.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import 'dart:io';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactSeller extends StatefulWidget {
  final p_id;
  const ContactSeller(this.p_id);

  @override
  _ContactSellerState createState() => _ContactSellerState();
}

class _ContactSellerState extends State<ContactSeller> {
  // When seller has not provided the phone number, show a dialog
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Phone number not found'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Seller has not provided their phone number.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // For messaging the seller
  void sending_SMS(userID, Product product) async {
    User seller = await fetchUser(userID);
    String message = "Hi, I came across your product " +
        product.title +
        " for Rs. " +
        product.price.toString() +
        " listed at CampusKart. I am interested in the product. Please let me know if it is available. Thank you!";
    if (seller.phone_number == null) {
      _showMyDialog();
    } else {
      String send_result = await sendSMS(
          message: message,
          recipients: [seller.phone_number.toString()]).catchError((err) {
        print(err);
      });
    }
  }

  // For messaging on whatsApp
  void launchWhatsapp(userID, Product product) async {
    User seller = await fetchUser(userID);
    String message = "Hi, I came across your product " +
        product.title +
        " for Rs. " +
        product.price.toString() +
        " listed at CampusKart. I am interested in the product. Please let me know if it is available. Thank you!";
    if (seller.phone_number == null) {
      _showMyDialog();
    } else {
      String url = 'https://api.whatsapp.com/send?phone=' +
          seller.phone_number.toString() +
          '&text=' +
          message;
      await launch(url);
    }
  }

  // For calling the seller
  Future<void> _makePhoneCall(userID) async {
    User seller = await fetchUser(userID);
    if (seller.phone_number == null) {
      _showMyDialog();
    } else {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: seller.phone_number,
      );
      await launch(launchUri.toString());
    }
  }

  // For mailing the seller
  Future<void> send_email(userID, Product product) async {
    User seller = await fetchUser(userID);
    final UserF.FirebaseAuth auth = UserF.FirebaseAuth.instance;
    final UserF.User? user = auth.currentUser;

    String message = "Hi, I came across your product " +
        product.title +
        " for Rs. " +
        product.price.toString() +
        " listed at CampusKart. I am interested in the product. Please let me know if it is available.\n\nThanks and regards\n" +
        user!.email.toString();

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: seller.emailId,
      queryParameters: {
        'subject': 'CampusKart: Interested Buyer',
        'body': message,
      },
    );
    launch(emailLaunchUri.toString().replaceAll('+', ' '));
  }

  // For showing the dialog box
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MaterialButton(
            height: 40.0,
            minWidth: double.infinity,
            color: Color(secondary_color),
            splashColor: Colors.grey,
            child: Row(
              children: const [
                Icon(Icons.call, color: Colors.white),
                SizedBox(width: 20),
                Text(
                  'Call the seller',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            onPressed: () async {
              Product p = await fetchProductInfo(widget.p_id);
              _makePhoneCall(p.username);
            },
          ),
          MaterialButton(
            height: 40.0,
            minWidth: double.infinity,
            color: Color(secondary_color),
            splashColor: Colors.grey,
            child: Row(
              children: const [
                Icon(Icons.chat_bubble_outline_outlined, color: Colors.white),
                SizedBox(width: 20),
                Text(
                  'WhatsApp the seller',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            onPressed: () async {
              Product p = await fetchProductInfo(widget.p_id);
              launchWhatsapp(p.username, p);
            },
          ),
          MaterialButton(
            height: 40.0,
            minWidth: double.infinity,
            color: Color(secondary_color),
            splashColor: Colors.grey,
            child: Row(
              children: const [
                Icon(Icons.message, color: Colors.white),
                SizedBox(width: 20),
                Text(
                  'SMS the seller',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            onPressed: () async {
              Product p = await fetchProductInfo(widget.p_id);
              sending_SMS(p.username, p);
            },
          ),
          MaterialButton(
            height: 40.0,
            minWidth: double.infinity,
            color: Color(secondary_color),
            splashColor: Colors.grey,
            child: Row(
              children: const [
                Icon(Icons.mail, color: Colors.white),
                SizedBox(width: 20),
                Text(
                  'Mail the seller',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            onPressed: () async {
              Product p = await fetchProductInfo(widget.p_id);
              send_email(p.username, p);
            },
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
