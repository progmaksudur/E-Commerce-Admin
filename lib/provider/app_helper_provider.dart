import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_admin/database/db_helper.dart';
import 'package:e_commerce_app_admin/model/CategoryModel.dart';
import 'package:e_commerce_app_admin/model/product_model.dart';
import 'package:e_commerce_app_admin/page/products_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/date model.dart';
import '../model/purches_model.dart';

class AppHelperProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<PurchaseModel> purchaseListOfSpecificProduct = [];
  List<CategoryModel> categoryList = [];

  Future<void> addCategory(CategoryModel categoryModel) =>
      DbHelper.addNewCategory(categoryModel);

  Future<void> rePurchase(String pId, num quantity, num price ,num sell, DateTime date, String category) {
    final catModel = getCategoryModelByCatName(category);
    catModel.productCount += quantity;
    final purchaseModel = PurchaseModel(
        dateModel: DateModel(
            timestamp: Timestamp.fromDate(date),
            year: date.year,
            month: date.month,
            day: date.day),
        purchaseprice: price,
        quantity: quantity,
        productID: pId

    );

    return DbHelper.rePurchase(purchaseModel, catModel,sell);
  }


  Future<void> addNewProduct(ProductModel productModel,
      PurchaseModel purchaseModel, CategoryModel categoryModel) {
    final count = categoryModel.productCount + purchaseModel.quantity;
    return DbHelper.addProduct(
        productModel, purchaseModel, categoryModel.catId!, count);
  }
  getAllProducts() {
    DbHelper.getAllProducts().listen((event) {
      productList = List.generate(event.docs.length, (index) =>
          ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getPurchaseByProduct(String id) {
    DbHelper.getPurchaseByProductId(id).listen((event) {
      purchaseListOfSpecificProduct =
          List.generate(event.docs.length, (index) =>
              PurchaseModel.fromMap(event.docs[index].data()));
      print(purchaseListOfSpecificProduct.length);
      notifyListeners();
    });
  }

  CategoryModel getCategoryModelByCatName(String name) {
    return categoryList.firstWhere((element) => element.catName== name);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      DbHelper.getProductById(id);



  Future<void> updateProduct(String id, String field, dynamic value) {
    return DbHelper.updateProduct(id, {field : value});
  }



  getAllCategories() {
    DbHelper.getAllCategories().listen((event) {
      categoryList = List.generate(event.docs.length,
          (index) => CategoryModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final photoRef = FirebaseStorage.instance.ref().child("picture/$imageName");
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}
