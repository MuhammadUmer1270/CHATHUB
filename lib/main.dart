import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ChatHUb/colors.dart';
import 'package:ChatHUb/features/common/widget/utilis/loader.dart';
// import 'package:ChatHUb/features/common/widget/utilis/loader.dart';
// import 'package:ChatHUb/features/common/widget/utilis/loader.dart';
import 'package:ChatHUb/features/landing_screen.dart';
import 'package:ChatHUb/repository/controler.dart';
import 'package:ChatHUb/screens/Forget.dart';
import 'package:ChatHUb/screens/Login.dart';
// import 'package:ChatHUb/repository/controler.dart';
import 'package:ChatHUb/screens/OTP_Screen.dart';
import 'package:ChatHUb/screens/Signup.dart';
import 'package:ChatHUb/screens/errorscreen.dart';
// import 'package:ChatHUb/screens/errorscreen.dart';
import 'package:ChatHUb/screens/login_Screen.dart';
import 'package:ChatHUb/features/chat/mobliechat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ChatHUb/screens/moblielayout.dart';
import 'package:ChatHUb/screens/select_contact_screen.dart';
import 'package:ChatHUb/screens/user_info_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor, primaryColor: appBarColor),
      title: 'ChatHUb',
      home: ref.watch(userdatauthprovider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              } else {
                return const moblielayout();
              }
            },
            error: (error, stackTrace) {
              return ErrorScreen(
                errorMessage: "can't loading ",
                onRetry: () {
                  Navigator.pushNamed(context, LandingScreen.id);
                },
              );
            },
            loading: () => const loader(),
          ),
      routes: {
        Selectcontactlist.id: (context) => Selectcontactlist(),
        LandingScreen.id: (context) => const LandingScreen(),
        MoblieChatScreen.id: (context) => const MoblieChatScreen(),
        Loginscreen.id: (context) => const Loginscreen(),
        OTPScreen.id: (context) => OTPScreen(),
        Userinfo.id: (context) => const Userinfo(),
        ErrorScreen.id: (context) => ErrorScreen(
            errorMessage: "errorMessage",
            onRetry: () {
              Navigator.pushNamed(context, LandingScreen.id);
            }),
            Login.id:(context)=>Login(),
            Signup.id:(context)=>Signup(),
            Forget.id:(context)=>Forget(),
      },
    );
  }
}
