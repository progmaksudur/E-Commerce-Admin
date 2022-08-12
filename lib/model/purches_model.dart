

import 'date model.dart';

const String purchaseId = "id";
const String purchaseProductId = "productId";
const String purchaseDateModel = "date_model";
const String purchasePrice = "price";
const String purchaseQuantity = "quantity";

class PurchaseModel {
  String? id;
  String? productID;
  DateModel dateModel;
  num purchaseprice;
  num quantity;

  PurchaseModel({
    this.id,
    this.productID,
    required this.dateModel,
    required this.purchaseprice,
    required this.quantity,
  });




  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      purchaseId: id,
      purchaseProductId: productID,
      purchaseDateModel : dateModel.toMap(),
      purchasePrice : purchaseprice,
      purchaseQuantity: quantity,
    };
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) => PurchaseModel(
      id: map[purchaseId],
      productID: map[purchaseProductId],
      dateModel : DateModel.fromMap(map[purchaseDateModel]),
      purchaseprice : map[purchasePrice],
      quantity : map[purchaseQuantity]

  );
}