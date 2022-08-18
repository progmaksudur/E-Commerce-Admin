


import 'package:e_commerce_app_admin/page/admin_dashboard.dart';
import 'package:e_commerce_app_admin/page/category_page.dart';
import 'package:e_commerce_app_admin/page/decider_page.dart';
import 'package:e_commerce_app_admin/page/log_in_page.dart';
import 'package:e_commerce_app_admin/page/new_product_page.dart';
import 'package:e_commerce_app_admin/page/order_page.dart';
import 'package:e_commerce_app_admin/page/product_page_details.dart';
import 'package:e_commerce_app_admin/page/products_page.dart';
import 'package:e_commerce_app_admin/page/report_page.dart';
import 'package:e_commerce_app_admin/page/setting_page.dart';
import 'package:e_commerce_app_admin/page/user_page.dart';
import 'package:e_commerce_app_admin/provider/app_helper_provider.dart';
import 'package:e_commerce_app_admin/provider/order_helper_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (context)=>AppHelperProvider()),
    ChangeNotifierProvider(create: (context)=>OrderProvider()),

  ]
  ,child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> pokeballperpalSwatch = {
      50: const Color.fromARGB(255, 220, 42, 131),
      100: const Color(0xffe8c1f1),
      200: const Color(0xffdeaeee),
      300: const Color(0xffd199e0),
      400: const Color(0xffcb9cdc),
      500: const Color(0xffa96eb8),
      600: const Color(0xff885893),
      700: const Color(0xff80558C),
      800: const Color(0xff613b6c),
      900: const Color(0xff46284e),
    };
    MaterialColor appColor = MaterialColor(0xff80558C, pokeballperpalSwatch);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: appColor,
      ),
      builder: EasyLoading.init(),
      initialRoute:LauncherPage.routeName,
      routes: {
        LauncherPage.routeName:(context)=>LauncherPage(),
        LogInPage.routeName:(context)=>LogInPage(),
        DashboardPage.routeName: (context)=>DashboardPage(),
        NewProductPage.routeName:(context)=>NewProductPage(),
        ProductsPage.routeName:(context)=>ProductsPage(),
        CategoryPage.routeName:(context)=>CategoryPage(),
        OrderPage.routeName:(context)=>OrderPage(),
        UserPage.routeName:(context)=>UserPage(),
        SettingPage.routeName:(context)=>SettingPage(),
        ReportPage.routeName:(context)=>ReportPage(),
        ProductDetailsPage.routeName:(context)=>ProductDetailsPage(),
      },
    );
  }
}


