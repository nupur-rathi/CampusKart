import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:olx_iit_ropar/apis/category_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/apis/token_api.dart';
import 'package:olx_iit_ropar/apis/user_image_api.dart';
import 'package:olx_iit_ropar/models/notification.dart';
import 'package:olx_iit_ropar/src/screens/store_screen.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:olx_iit_ropar/src/screens/buy_product_screen.dart';
import 'package:olx_iit_ropar/src/screens/home_screen.dart';
import 'package:olx_iit_ropar/src/screens/products_screen.dart';
import 'package:olx_iit_ropar/src/screens/profile_screen.dart';
import 'package:olx_iit_ropar/src/screens/upload_product_screen.dart';
import 'package:olx_iit_ropar/src/screens/wishlist_screen.dart';
import 'package:olx_iit_ropar/src/screens/login.dart';
import 'package:olx_iit_ropar/src/screens/signup.dart';
import 'package:olx_iit_ropar/src/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:olx_iit_ropar/apis/user_api.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/src/screens/edit_profile_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:olx_iit_ropar/src/screens/notification_list.dart';
import 'package:olx_iit_ropar/apis/notification_api.dart';
import 'apis/liked_product_api.dart';

// ignore: non_constant_identifier_names
var unread_notification_count = ValueNotifier<int>(0);

// material colour object for primary color of our app
MaterialColor myColor = MaterialColor(primary_color, {
  50: Color(primary_color),
  100: Color(primary_color),
  200: Color(primary_color),
  300: Color(primary_color),
  400: Color(primary_color),
  500: Color(primary_color),
  600: Color(primary_color),
  700: Color(primary_color),
  800: Color(primary_color),
  900: Color(primary_color),
});

// for notification to the users android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializing firebase app
  await Firebase.initializeApp();
  // loading .env file
  await dotenv.load(fileName: ".env");

  const initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  /// Initialization Settings for iOS
  const initializationSettingsIOS = IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );

  /// InitializationSettings for initializing settings for both platforms
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

// run app
  runApp(
    ChangeNotifierProvider<NotificationProvider>(
      create: (ctx) => NotificationProvider(),
      child: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, _) {
          return MyApp(notificationProvider);
        },
      ),
    ),
  );
}

String hashcode = '';

// MyApp class
class MyApp extends StatefulWidget {
  NotificationProvider np;
  MyApp(this.np);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // firebase authentication checking if user logged in or not
  late StreamSubscription<User?> user;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
      } else {
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user_k = auth.currentUser;
      var username = user_k?.email!.substring(0, user_k.email!.length - 13);

      if (notification != null &&
          android != null &&
          hashcode != notification.hashCode.toString()) {

        MyNotification mn = MyNotification(
            username: username!, description: notification.body!, read: false);

        widget.np.addNotification(mn);

        hashcode = notification.hashCode.toString();

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // channel.description,
              icon: android.smallIcon,
              // other properties...
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body.toString())],
                )),
              );
            });
      }
    });

    // returning provider widget
    return MultiProvider(
      // creating providers for state management
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => PictureProvider()),
        ChangeNotifierProvider(create: (context) => LikedProductsProvider()),
        ChangeNotifierProvider(create: (context) => TokenProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => UserImageProvider()),
      ],
      // returning materialapp widget
      child: MaterialApp(
        title: 'CampusKart',
        theme: ThemeData(
          primarySwatch: myColor,
          primaryColor: Color(primary_color),
        ),
        // intialroute is homepage if user already logged in else welcomescreen
        initialRoute: (FirebaseAuth.instance.currentUser != null &&
                FirebaseAuth.instance.currentUser!.emailVerified)
            ? '/home_page'
            : '/',
        // creating routes to navigate to different pages of our app
        routes: {
          '/profile_screen': (context) => const ProfileScreen(),
          '/upload_product_screen': (context) => UploadProductScreen(),
          '/wishlist_screen': (context) => const WishlistScreen(),
          '/products_screen': (context) => const ProductsScreen(),
          '/buy_product_screen': (context) => const BuyProductScreen(),
          '/': (context) => WelcomeScreen(),
          '/signup_screen': (context) => SignupScreen(),
          '/login_screen': (context) => LoginScreen(),
          '/home_page': (context) => const MyHomePage(),
          '/edit_profile': (context) => EditProfilePage(),
          '/store_page': (context) => const StoreScreen(),
          '/notification_list': (context) => const NotificationList(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}