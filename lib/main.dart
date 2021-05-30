import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/splash.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:shared_value/shared_value.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'dart:async';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  fetch_user() async {
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.$ = true;
      user_id.$ = userByTokenResponse.id;
      user_name.$ = userByTokenResponse.name;
      user_email.$ = userByTokenResponse.email;
      user_phone.$ = userByTokenResponse.phone;
      avatar_original.$ = userByTokenResponse.avatar_original;
    }
  }

  access_token.load().then((value) => fetch_user());
  // update((s) {
  //   fetch_user();
  //   return s;
  // });

  /*is_logged_in.$;
  user_id.$;
  avatar_original.$;
  user_name.$;
  user_email.$;
  user_phone.$;*/

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Mbox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MyTheme.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: MyTheme.accent_color,
        /*textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(fontSize: 12.0),
          )*/
        //
        // the below code is getting fonts from http
        textTheme: GoogleFonts.sourceSansProTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.sourceSansPro(textStyle: textTheme.bodyText1),
          bodyText2: GoogleFonts.sourceSansPro(
              textStyle: textTheme.bodyText2, fontSize: 12),
        ),
      ),
      home: Splash(),
      //home: Main(),
    );
  }
}
