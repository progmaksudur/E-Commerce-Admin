const String categoryId = "catid";
const String categoryName = "name";
const String categoryProductCount = "productCount";
const String categoryAvailable = "available";

class CategoryModel {
  String? catId;
  String? catName;
  num productCount;
  bool available;

  CategoryModel({
    this.catId,
    this.catName,
    this.productCount = 0,
    this.available = true,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      categoryId: catId,
      categoryName: catName,
      categoryProductCount : productCount,
      categoryAvailable : available,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
    catId: map[categoryId],
    catName: map[categoryName],
    productCount: map[categoryProductCount],
    available : map[categoryAvailable],

  );
}