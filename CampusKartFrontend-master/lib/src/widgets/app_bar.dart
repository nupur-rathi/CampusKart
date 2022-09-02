// The top bar for all the pages of our app
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/main.dart';
import 'package:olx_iit_ropar/apis/notification_api.dart';
import 'package:olx_iit_ropar/models/notification.dart';
import 'package:provider/provider.dart';
import '../../apis/liked_product_api.dart';
import '../../apis/product_api.dart';
import '../../utils/functions.dart';

class TitleBar extends StatefulWidget {
  const TitleBar({Key? key}) : super(key: key);
  @override
  State<TitleBar> createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    Provider.of<NotificationProvider>(context, listen: false).fetchTasks();
    final likedP = Provider.of<LikedProductsProvider>(context);
    final productsP = Provider.of<ProductsProvider>(context);

    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('CampusKart'),
      actions: <Widget>[
        Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            IconButton(
              onPressed: () {
                navigation(context, "/notification_list");
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
            ),
            ValueListenableBuilder(
                // For showing number of unread notifications
                valueListenable: unread_notification_count,
                builder: (context, value, widget) {
                  return unread_notification_count.value != 0
                      ? Positioned(
                          right: 11,
                          top: 11,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              unread_notification_count.value.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container();
                }),
          ],
        ),
        IconButton(
          tooltip: 'Your Uploads',
          icon: const Icon(
            Icons.inventory_2_outlined,
            size: 22,
          ),
          onPressed: () async {
            var u_id = getUser();
            EasyLoading.show(
              status: 'loading...',
              maskType: EasyLoadingMaskType.black,
            );
            // Fetch the products uploaded by the user
            await productsP.fetchStoreProducts(u_id);
            EasyLoading.dismiss();
            navigation(context, "/store_page");
          },
        ),
        IconButton(
          onPressed: () async {
            EasyLoading.show(
              status: 'loading...',
              maskType: EasyLoadingMaskType.black,
            );
            final FirebaseAuth auth = FirebaseAuth.instance;
            final User? user = auth.currentUser;
            print(user!.email);
            // Getting the username to get his/her liked products
            var username = user.email!.substring(0, user.email!.length - 13);
            await likedP.fetchLikedProducts(username);
            EasyLoading.dismiss();
            navigation(context, "/wishlist_screen");
          },
          icon: const Icon(
            Icons.favorite_border_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
