
import 'package:e_commerce_app_admin/page/admin_dashboard.dart';
import 'package:e_commerce_app_admin/page/log_in_page.dart';
import 'package:flutter/material.dart';
import '../auth_service/auth_service.dart';

class LauncherPage extends StatefulWidget {
  static const routeName ="/";
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero,(){

      if(AuthService.user==null){
        Navigator.pushReplacementNamed(context, LogInPage.routeName);
      }else{
        Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }

    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CircularProgressIndicator(),

    );
  }
}