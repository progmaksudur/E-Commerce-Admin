
import 'package:flutter/material.dart';


class DashBoardIteamModel{
  String title;
  IconData icon;

  DashBoardIteamModel({
    required this.title,
    required this.icon});

  static const String product = "Products";
  static const String category = "Category";
  static const String order = "Orders";
  static const String user = "Users";
  static const String settings = "Settings";
  static const String report = "Report";

}

final List<DashBoardIteamModel> dashboardIteam=[
  DashBoardIteamModel(
    icon: Icons.card_giftcard,
    title: DashBoardIteamModel.product,
  ),
  DashBoardIteamModel(
    icon: Icons.category,
    title: DashBoardIteamModel.category,
  ),
  DashBoardIteamModel(
    icon: Icons.monetization_on,
    title: DashBoardIteamModel.order,
  ),
  DashBoardIteamModel(
    icon: Icons.person,
    title: DashBoardIteamModel.user,
  ),
  DashBoardIteamModel(
    icon: Icons.settings,
    title: DashBoardIteamModel.settings,
  ),
  DashBoardIteamModel(
    icon: Icons.area_chart,
    title: DashBoardIteamModel.report,
  ),

];