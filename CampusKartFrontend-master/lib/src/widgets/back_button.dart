// Common back button for going back
import 'package:flutter/material.dart';

import 'package:olx_iit_ropar/src/widgets/constant.dart';

class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
