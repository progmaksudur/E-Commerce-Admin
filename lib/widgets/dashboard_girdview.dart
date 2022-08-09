
import 'package:e_commerce_app_admin/model/dashboard_iteam_model.dart';
import 'package:e_commerce_app_admin/utlitis/utilit.dart';
import 'package:flutter/material.dart';

class DashBoardItemView extends StatelessWidget {
  final DashBoardIteamModel dashboardIteam;
  final Function(String) onPressed;
  const DashBoardItemView({
    Key? key,
    required this.dashboardIteam,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed(dashboardIteam.title);
      },
      child: Card(
        color: forthColors,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),

          ),
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                dashboardIteam.icon,
                size: 45,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 5,),
              Text(dashboardIteam.title, style:dashboardlistfont,)
            ],
          )),
    );
  }
}