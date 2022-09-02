// Shows the success or the failure status of the upload product
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/bottomappbar.dart';
import 'package:olx_iit_ropar/utils/functions.dart';

class UploadResultScreen extends StatefulWidget {
  bool success = false;
  bool isEdited = false;
  UploadResultScreen({Key? key, required this.success, required this.isEdited})
      : super(key: key);
  @override
  State<UploadResultScreen> createState() => _UploadResultScreenState();
}

class _UploadResultScreenState extends State<UploadResultScreen> {
  Widget showMessage(success, failure) {
    return Container(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 100.0,
              child: widget.success
                  ? Image.asset("lib/assets/random/success.png")
                  : Image.asset("lib/assets/random/failure.png")),
          const SizedBox(height: 30.0),
          widget.success
              ? Text(
                  success.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                )
              : Text(
                  failure.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
          const SizedBox(height: 15.0),
          widget.isEdited
              ? SizedBox(
                  height: 0,
                )
              : (widget.success
                  ? const Text(
                      "Kindly note your product will be automatically deleted after 30 days.",
                      style: TextStyle(fontSize: 15.0, color: Colors.green),
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      "Please try again.",
                      style: TextStyle(fontSize: 15.0),
                      textAlign: TextAlign.center,
                    )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            widget.isEdited
                ? showMessage(
                    "Product edited successfully", "Product editing failed")
                : showMessage(
                    "Product uploaded successfully", "Product upload failed"),
            SizedBox(height: 15.0),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                child: const Text(
                  'Return to home screen',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  navigation(context, '/home_page');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
