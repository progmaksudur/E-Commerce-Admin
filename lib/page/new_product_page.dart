import 'dart:io';

import 'package:e_commerce_app_admin/utlitis/utilit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName="/newproductpage";
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

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productSalePriceController.dispose();
    productPurchasePriceController.dispose();
    productQuantityController.dispose();

    super.dispose();
  }

  String? _purchaseDate;

  String bookCategory = 'OTHERS';
  String? imagePath;

  ImageSource source = ImageSource.camera;
  var category_items = [
    'LAPTOP',
    'WATCH',
    'DRESS',
    'MOBILE',
    'BIKE',
    'OTHERS',
  ];

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
              SizedBox(height: 10,),
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
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: imagePath==null?Image.asset("asstes/images/addproduct.png",fit: BoxFit.cover,height: 100,width: 100,):
                            Image.file(File(imagePath!),fit: BoxFit.cover,height: 100,width: 100,),

                          ),
                        ),
                      ),
                    )),
              ),
              Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: TextFormField(
              controller: productNameController,
              style: fieldFont1,
              decoration: InputDecoration(
                  filled: true,
                  fillColor:forthColors.withOpacity(.2),
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
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: TextFormField(
                  controller: productPurchasePriceController,
                  style: fieldFont1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor:forthColors.withOpacity(.2),
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
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                  tileColor: forthColors.withOpacity(.2),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.date_range,color: _purchaseDate==null?Colors.grey:primaryColor,),
                      SizedBox(width: 5,),
                      Text("Purchase Date:", style: hintstyle,),
                    ],
                  ),
                  title: Center(
                    child: Text(
                      _purchaseDate == null
                          ? "No date choisen!"
                          : _purchaseDate.toString(),
                      style: TextStyle(
                          color: _purchaseDate == null
                              ? Colors.grey
                              : Theme.of(context).primaryColor),
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: _showPurchaseDatePicker,
                      icon: Icon(
                        Icons.add,
                        color: secondaryColors,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                   Expanded(child: TextFormField(
                     controller: productQuantityController,
                     style: fieldFont1,
                     keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                         filled: true,
                         fillColor:forthColors.withOpacity(.2),
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
                   ),),
                    SizedBox(width: 5,),
                    Expanded(child: TextFormField(
                      controller: productSalePriceController,
                      style: fieldFont1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor:forthColors.withOpacity(.2),
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
                    ),)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  tileColor: forthColors.withOpacity(.2),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.category),
                      SizedBox(width: 5,),
                      Text("Select Category:", style: hintstyle,),
                    ],
                  ),
                  trailing: DropdownButton(
                    borderRadius: BorderRadius.circular(20),
                    underline: Text(""),
                    dropdownColor: Colors.white,
                    value: bookCategory,
                    icon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.keyboard_arrow_down,color: secondaryColors,),
                    ),
                    style:fieldFont1,
                    items: category_items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Center(child: Text(items)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        bookCategory = newValue!;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child: TextFormField(
                  controller: productDescriptionController,
                  style: fieldFont1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor:forthColors.withOpacity(.2),
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
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: _addProduct,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
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
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
      });
    }
  }
  CustomDialog(){
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
                Icons.camera_alt_outlined,size: 30,
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
                Icons.photo_library_outlined,size: 30,
                color: primaryColor,
              ),
              subtitle: Text(
                "Image from Gallery",
                textAlign: TextAlign.center,
                  style: dialogtext
              ),
            ),
          ],
        ));

  }
  void _showPurchaseDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      setState(() {
        _purchaseDate = DateFormat("yyy/MM/dd").format(selectedDate);
      });
    }
  }

  void _addProduct() {
  }
}
