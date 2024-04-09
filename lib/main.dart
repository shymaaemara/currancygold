import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled12/screens/admin/Add_exhibition.dart';
import 'package:untitled12/screens/admin/add_company.dart';
import 'package:untitled12/screens/admin/add_currency.dart';
import 'package:untitled12/screens/admin/add_gold.dart';
import 'package:untitled12/screens/admin/admin_company.dart';
import 'package:untitled12/screens/admin/admin_currency.dart';
import 'package:untitled12/screens/admin/admin_exhibition.dart';
import 'package:untitled12/screens/admin/admin_gold.dart';
import 'package:untitled12/screens/admin/admin_home.dart';
import 'package:untitled12/screens/admin/admin_login.dart';
import 'package:untitled12/screens/auth/login.dart';
import 'package:untitled12/screens/auth/reg.dart';
import 'package:untitled12/screens/exhabit/Exhabit_Addproducts.dart';
import 'package:untitled12/screens/exhabit/Exhabit_Exhabitions.dart';
import 'package:untitled12/screens/exhabit/Exhabit_login.dart';
import 'package:untitled12/screens/exhabit/Exhabit_products.dart';
import 'package:untitled12/screens/user/User_Exhabitions.dart';
import 'package:untitled12/screens/user/homepage.dart';

import 'package:untitled12/screens/user/openscreen.dart';
import 'package:untitled12/screens/user/user_company.dart';
import 'package:untitled12/screens/user/user_currency.dart';
import 'package:untitled12/screens/user/user_gold.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:  FirebaseAuth.instance.currentUser == null
          ?
      const OpenScreen()
          :
      FirebaseAuth.instance.currentUser?.email == 'admin@gmail.com'
          ?
      const AdminHomePage()
          : FirebaseAuth.instance.currentUser!.displayName == 'معرض'?
      const CustomerHomePage():const OpenScreen()
        ,

        routes: {
          RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          CustomerHomePage.routeName: (ctx) => CustomerHomePage(),
          AdminLogin.routeName: (ctx) => AdminLogin(),
          AdminHomePage.routeName: (ctx) =>AdminHomePage (),
          AddGold.routeName: (ctx) => AddGold (),
          AdminGoldPage.routeName: (ctx) => AdminGoldPage(),
          OpenScreen.routeName: (ctx) =>  OpenScreen(),
          UserGoldPage.routeName: (ctx) => UserGoldPage(),
          AddCurrency.routeName: (ctx) =>  AddCurrency(),
          AdminCurrency.routeName: (ctx) => AdminCurrency(),
          UserCurrency.routeName: (ctx) => UserCurrency(),
          AddCompany.routeName: (ctx) => AddCompany(),
          AdminCompany.routeName: (ctx) => AdminCompany(),
          UserCompany.routeName: (ctx) => UserCompany(),
          AddExhibition.routeName: (ctx) => AddExhibition(),
          AdminExhibition.routeName: (ctx) => AdminExhibition(),
          ExhabitAddproducts.routeName: (ctx) => ExhabitAddproducts(Exhabit: '',),
          ExhabitProducts.routeName: (ctx) => ExhabitProducts(Exhabit: '',),
          ExhabitLogin.routeName: (ctx) => ExhabitLogin(),
          ExhabitExhabitions.routeName: (ctx) =>  ExhabitExhabitions(),
          UserExhabition.routeName: (ctx) =>   UserExhabition(),
        });
  }
}




