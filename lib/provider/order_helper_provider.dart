import 'package:e_commerce_app_admin/database/db_helper.dart';
import 'package:flutter/material.dart';

import '../model/product_const_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();

  Future<void> addOrderConstants(OrderConstantsModel orderConstantsModel) =>
      DbHelper.addOrderConstants(orderConstantsModel);

  Future<void> getOrderConstants() async{
    final snapshot = await DbHelper.getAllOrderConstants();
    orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
    notifyListeners();
  }
}