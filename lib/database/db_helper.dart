import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_admin/model/product_const_model.dart';
import 'package:e_commerce_app_admin/model/product_model.dart';
import 'package:e_commerce_app_admin/model/purches_model.dart';
import '../model/CategoryModel.dart';

class DbHelper {
  static const String userCollection = 'Admins';
  static const String collectionCategory = "Category";
  static const String collectionProduct = 'Products';
  static const String collectionPurchase = 'Purchase';
  static const String collectionUser = 'User';
  static const String collectionOrder = 'Order';
  static const String collectionOrderDetails = 'OrderDetails';
  static const String collectionOrderSettings = 'Settings';
  static const String documentConstant = 'OrderConstant';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> isadmin(String adminId) async {
    final snapshot = await _db.collection(userCollection).doc(adminId).get();
    return snapshot.exists;
  }

  static Future<void> addNewCategory(CategoryModel categoryModel) {
    final doc = _db.collection(collectionCategory).doc();
    categoryModel.catId = doc.id;
    return doc.set(categoryModel.toMap());
  }

  static Future<void> addProduct(ProductModel productModel,
      PurchaseModel purchaseModel, String catId, num count) {
    final wb = _db.batch();
    final proDoc = _db.collection(collectionProduct).doc();
    final purDoc = _db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionCategory).doc(catId);
    productModel.id = proDoc.id;
    purchaseModel.id = purDoc.id;
    purchaseModel.productID = proDoc.id;
    wb.set(proDoc, productModel.toMap());
    wb.set(purDoc, purchaseModel.toMap());
    wb.update(catDoc, {categoryProductCount: count});
    return wb.commit();
  }

  static Future<void> addOrderConstants(OrderConstantsModel orderConstantsModel)=>
      _db.collection(collectionOrderSettings).doc(documentConstant).set(orderConstantsModel.toMap());


  static Future<void> rePurchase(PurchaseModel purchaseModel, CategoryModel catModel, num sell){
    final wb = _db.batch();
    final doc = _db.collection(collectionPurchase).doc();
    purchaseModel.id = doc.id;
    wb.set(doc, purchaseModel.toMap());
    final catDoc = _db.collection(collectionCategory).doc(catModel.catId);
    wb.update(catDoc, {categoryProductCount : catModel.productCount});
    final productDoc=_db.collection(collectionProduct).doc(purchaseModel.productID);
    wb.update(productDoc, {productSalePrice : sell});
    return wb.commit();

  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAllOrderConstants() =>
      _db.collection(collectionOrderSettings).doc(documentConstant).get();


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(
          String id) =>
      _db.collection(collectionProduct).doc(id).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPurchaseByProductId(
          String id) =>
      _db
          .collection(collectionPurchase)
          .where(purchaseProductId, isEqualTo: id)
          .snapshots();

  static Future<void> updateProduct(String id, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(id).update(map);
  }
}
