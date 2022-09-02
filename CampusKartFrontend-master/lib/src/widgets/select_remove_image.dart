// Widget for the pop-up for select or remove profile image
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:olx_iit_ropar/utils/constants.dart';

class SelectProfileImage extends StatefulWidget {
  Function pickImages;
  Function removePhoto;
  SelectProfileImage(this.removePhoto, this.pickImages, {Key? key})
      : super(key: key);

  @override
  _SelectProfileImageState createState() =>
      _SelectProfileImageState(removePhoto, pickImages);
}

class _SelectProfileImageState extends State<SelectProfileImage> {
  Function pickImages;
  Function removePhoto;
  _SelectProfileImageState(this.removePhoto, this.pickImages);

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
                Icon(
                  Icons.image_search,
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                Text(
                  'Select profile photo',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            onPressed: () {
              pickImages();
            },
          ),
          MaterialButton(
            height: 40.0,
            minWidth: double.infinity,
            color: Color(secondary_color),
            splashColor: Colors.grey,
            child: Row(
              children: const [
                Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                Text(
                  'Remove profile photo',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            onPressed: () {
              removePhoto();
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
