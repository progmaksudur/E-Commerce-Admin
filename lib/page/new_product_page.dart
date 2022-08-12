import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_admin/provider/app_helper_provider.dart';
import 'package:e_commerce_app_admin/utlitis/utilit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/date model.dart';
import '../model/product_model.dart';
import '../model/purches_model.dart';
import '../utlitis/helper_functions.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = "/newproductpage";
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final formKey = GlobalKey<FormState>();
  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productSalePriceController = TextEditingController();
  final productPurchasePriceController = TextEditingController();
  final productQuantityController = TextEditingController();
  XFile? imageFile;
  DateTime? _productPurchaseDate;
  String? _imageUrl;

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productSalePriceController.dispose();
    productPurchasePriceController.dispose();
    productQuantityController.dispose();

    super.dispose();
  }
  String? _category;

  ImageSource source = ImageSource.camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Product"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Card(
                    elevation: 15,
                    color: forthColors.withOpacity(.2),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: CustomDialog,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: primaryColor,
                                width: 2,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:  _imageUrl == null
                                ? Image.asset("asstes/images/addproduct.png",height: 100,width: 100,fit:BoxFit.cover,)
                                :Image.file(File(_imageUrl!),fit: BoxFit.cover,height: 100,width: 100,),
                          ),
                          ),
                        ),
                      ),
                    )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: productNameController,
                  style: fieldFont1,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: forthColors.withOpacity(.2),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.card_giftcard,
                      ),
                      hintText: "Enter the product name",
                      hintStyle: hintstyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  controller: productPurchasePriceController,
                  style: fieldFont1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: forthColors.withOpacity(.2),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.monetization_on_outlined,
                      ),
                      hintText: "Enter the product purcheses price",
                      hintStyle: hintstyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: forthColors.withOpacity(.2),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range,
                        color:
                            _productPurchaseDate == null ? Colors.grey : primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Purchase Date:",
                        style: hintstyle,
                      ),
                    ],
                  ),
                  title: Center(
                    child: Text(
                      _productPurchaseDate == null
                          ? "No date choisen!"
                          : getFormattedDateTime(_productPurchaseDate!, 'dd/MM/yyyy'),
                      style: TextStyle(
                          color: _productPurchaseDate == null
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: _selectDate,
                      icon: Icon(
                        Icons.add,
                        color: secondaryColors,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: productQuantityController,
                        style: fieldFont1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: forthColors.withOpacity(.2),
                            contentPadding: const EdgeInsets.only(left: 10),
                            focusColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.clean_hands_outlined,
                            ),
                            hintText: "Product Quantity",
                            hintStyle: hintstyle,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field must not be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: productSalePriceController,
                        style: fieldFont1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: forthColors.withOpacity(.2),
                            contentPadding: const EdgeInsets.only(left: 10),
                            focusColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.sell_outlined,
                            ),
                            hintText: "Selling Price",
                            hintStyle: hintstyle,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field must not be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Consumer<AppHelperProvider>(
                  builder: (context, provider, _) => ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: forthColors.withOpacity(.2),
                    leading: Icon(Icons.category),
                    minLeadingWidth: 15,
                    title: Text(
                      "Select category:",
                      textAlign: TextAlign.center,
                      style: hintstyle,
                    ),
                    trailing: DropdownButton(
                      hint: Text(
                        "No category selected",
                        style: hintstyle,
                      ),
                      dropdownColor: Colors.white,
                      value: _category,
                      icon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: secondaryColors,
                        ),
                      ),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500),
                      items: provider.categoryList.map((items) {
                        return DropdownMenuItem(
                          value: items.catName,
                          child: Center(child: Text(items.catName.toString())),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _category = newValue.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  controller: productDescriptionController,
                  style: fieldFont1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: forthColors.withOpacity(.2),
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.description_outlined,
                      ),
                      hintText: "Enter the product description",
                      hintStyle: hintstyle,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: _saveProduct,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Product",
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _getImage() async {
    final selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _imageUrl=selectedImage.path;
        imageFile=selectedImage;
      });
    }
  }


  CustomDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              elevation: 10,
              actions: [
                ListTile(
                  onTap: () {
                    source = ImageSource.camera;
                    _getImage();
                    Navigator.of(context).pop();
                  },
                  title: Icon(
                    Icons.camera_alt_outlined,
                    size: 30,
                    color: primaryColor,
                  ),
                  subtitle: Text(
                    "Image from camera",
                    textAlign: TextAlign.center,
                    style: dialogtext,
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    source = ImageSource.gallery;
                    _getImage();
                    Navigator.of(context).pop();
                  },
                  title: Icon(
                    Icons.photo_library_outlined,
                    size: 30,
                    color: primaryColor,
                  ),
                  subtitle: Text("Image from Gallery",
                      textAlign: TextAlign.center, style: dialogtext),
                ),
              ],
            ));
  }



  void _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      setState(() {
        _productPurchaseDate = selectedDate;
      });
    }
  }


  void _saveProduct() async{
    if(_productPurchaseDate == null) {
      showMsg(context, 'Please select a purchase date');
      return;
    }
    if(_imageUrl == null) {
      showMsg(context, 'Please select an image');
      return;
    }

    if (formKey.currentState!.validate()) {
      EasyLoading.showProgress(0.3, status: 'Please wait...');
      try {
        final url =
            await context.read<AppHelperProvider>().updateImage(imageFile!);
        final productModel = ProductModel(
            name: productNameController.text,
            description: productDescriptionController.text,
            salePrice: num.parse(productSalePriceController.text),
            category: _category,
            imageUrl: url);
        final purchaseModel = PurchaseModel(
          dateModel: DateModel(
            timestamp: Timestamp.fromDate(_productPurchaseDate!),
            day: _productPurchaseDate!.day,
            month: _productPurchaseDate!.month,
            year: _productPurchaseDate!.year,
          ),
          purchaseprice: num.parse(productPurchasePriceController.text),
          quantity: num.parse(productQuantityController.text),
        );
        final catModel = context.read<AppHelperProvider>()
            .getCategoryModelByCatName(_category!);
        context.read<AppHelperProvider>()
            .addNewProduct(
            productModel,
            purchaseModel,
            catModel).then((_) {
          EasyLoading.dismiss(animation: true);
          _resetFields();
        }).catchError((error) {
          showMsg(context, 'Could not save');
          throw error;
        });

      } catch (e) {
        showMsg(context, e.toString());
      }
    }
  }

  void _resetFields() {
    setState(() {
      productNameController.clear();
      productDescriptionController.clear();
      productPurchasePriceController.clear();
      productSalePriceController.clear();
      productQuantityController.clear();
      _imageUrl = null;
      _category = null;
      _productPurchaseDate = null;
    });
  }
}
