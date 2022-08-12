
import 'package:e_commerce_app_admin/auth_service/auth_service.dart';
import 'package:e_commerce_app_admin/model/dashboard_iteam_model.dart';
import 'package:e_commerce_app_admin/page/category_page.dart';
import 'package:e_commerce_app_admin/page/decider_page.dart';
import 'package:e_commerce_app_admin/page/new_product_page.dart';
import 'package:e_commerce_app_admin/page/order_page.dart';
import 'package:e_commerce_app_admin/page/products_page.dart';
import 'package:e_commerce_app_admin/page/report_page.dart';
import 'package:e_commerce_app_admin/page/setting_page.dart';
import 'package:e_commerce_app_admin/page/user_page.dart';
import 'package:e_commerce_app_admin/provider/app_helper_provider.dart';
import 'package:e_commerce_app_admin/widgets/dashboard_girdview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  static const routeName = "/dashboard";
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<AppHelperProvider>(context, listen: false).getAllCategories();
    Provider.of<AppHelperProvider>(context, listen: false).getAllProducts();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(onPressed: (){
            AuthService.logout();
            Navigator.pushReplacementNamed(context, LauncherPage.routeName);
          },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: GridView.builder(
              shrinkWrap: true,
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 5
              ),
              itemCount: dashboardIteam.length,
              itemBuilder: (context,index)=>
              DashBoardItemView(dashboardIteam: dashboardIteam[index],
              onPressed: (value){

                String route =   navigator(value);
                Navigator.pushNamed(context, route);

          }),
        ),
    ),
      ),


    );
  }
  String navigator(String value) {
    String route ="";
    switch(value){
      case DashBoardIteamModel.user:
        route = UserPage.routeName;
        break;
      case DashBoardIteamModel.settings:
        route = SettingPage.routeName;
        break;
      case DashBoardIteamModel.category:
        route = CategoryPage.routeName;
        break;
      case DashBoardIteamModel.order:
        route = OrderPage.routeName;
        break;
      case DashBoardIteamModel.report:
        route = ReportPage.routeName;
        break;
      case DashBoardIteamModel.product:
        route = ProductsPage.routeName;
        break;

    }
    return route;


  }
}