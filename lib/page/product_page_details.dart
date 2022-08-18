


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_admin/provider/app_helper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import '../utlitis/helper_functions.dart';
import '../utlitis/utilit.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product_details';

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pId = ModalRoute.of(context)!.settings.arguments as String;
    Provider.of<AppHelperProvider>(context).getProductById(pId);
    final provider =   Provider.of<AppHelperProvider>(context,listen: false);
    provider.getPurchaseByProduct(pId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body:  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: provider.getProductById(pId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = ProductModel.fromMap(snapshot.data!.data()!);
            return ListView(
              children: [
                Container(
                  color: Colors.white,
                  child: FadeInImage.assetNetwork(
                    placeholder: "asstes/images/addproduct.png",
                    image: product.imageUrl!,
                    fadeInCurve: Curves.bounceInOut,
                    fadeInDuration: const Duration(seconds: 3),
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        _showRePurchaseBottomSheet(context,
                                (quantity, price,sell, date) {
                              provider
                                  .rePurchase(pId, quantity, price, sell ,date, product.category!)
                                  .then((value) {
                                Navigator.pop(context);
                              }).catchError((error) {
                                showMsg(context, "Could not save");
                                throw error;
                              });
                            });
                      },
                      child: const Text('Re-Purchase'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        _showPurchaseHistoryBottomSheet(context);
                      },
                      child: const Text('Purchase History'),
                    ),
                  ],
                ),
                ListTile(
                  title: Text(product.name!),
                  trailing: IconButton(
                    onPressed: () {
                      showUpdateDialog(context, "Name", product.name,
                              (value) {
                            provider.updateProduct(
                                product.id!, productName, value);
                          });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  title: Text('৳${product.salePrice.toString()}'),
                  trailing: IconButton(
                    onPressed: () {
                      showUpdateDialog(
                          context, "Price", product.salePrice.toString(),
                              (value) {
                            provider.updateProduct(
                                product.id!, productSalePrice, num.parse(value));
                          });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  title: const Text('Product Description'),
                  subtitle: Text(product.description ?? 'Not Available'),
                  trailing: IconButton(
                    onPressed: () {
                      showUpdateDialog(
                          context, "Description", product.description,
                              (value) {
                            provider.updateProduct(
                                product.id!, productDescription, value);
                          });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Available'),
                  value: product.available,
                  onChanged: (value) {
                    provider.updateProduct(
                        product.id!, productAvailable, value);
                  },
                ),
                SwitchListTile(
                  title: const Text('Featured'),
                  value: product.featured,
                  onChanged: (value) {
                    provider.updateProduct(
                        product.id!, productFeatured, value);
                  },
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

    );
  }

  void _showPurchaseHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "Purchase History",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                  itemCount: context
                      .read<AppHelperProvider>()
                      .purchaseListOfSpecificProduct
                      .length,
                  itemBuilder: (context, index) {
                    final purchaseModel = context
                        .read<AppHelperProvider>()
                        .purchaseListOfSpecificProduct[index];
                    return Column(
                      children: [
                        ListTile(

                          title: Text(getFormattedDateTime(
                              purchaseModel.dateModel.timestamp.toDate(),
                              "dd/MM/yyyy")),
                          subtitle: Text(
                              "Quantity: ${purchaseModel.quantity.toString()}"),
                          trailing:
                          Text('৳ ${purchaseModel.purchaseprice} '),

                        ),
                        Divider(
                          height: 2,
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ));
  }

  showUpdateDialog(BuildContext context, String title, String? value,
      Function(String) onSaved) {
    final txtContoller = TextEditingController();

    txtContoller.text = value ?? "";
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Update $title",
            textAlign: TextAlign.center,
          ),
          content: TextFormField(
            controller: txtContoller,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffe6e6e6),
                contentPadding: const EdgeInsets.only(left: 10),
                focusColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.workspaces_filled,
                ),
                hintText: "Enter $title",
                hintStyle: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
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
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  onSaved(txtContoller.text);
                  Navigator.pop(context);
                },
                child: Text("Update"))
          ],
        ));
  }

  void _showRePurchaseBottomSheet(BuildContext context,
      Function(num quantity, num price,num sellprice, DateTime date) onSave) {
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    final sellPriceController=TextEditingController();
    DateTime purchaseDate = DateTime.now();
    ValueNotifier<DateTime> dateTimeNotifier = ValueNotifier(DateTime.now());

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ListView(
          padding: const EdgeInsets.all(15),
          children: [
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: priceController,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffe6e6e6),
                  contentPadding: const EdgeInsets.only(left: 10),
                  focusColor: Colors.white,
                  hintText: "Enter product Purchase price",
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
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
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: quantityController,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffe6e6e6),
                  contentPadding: const EdgeInsets.only(left: 10),
                  focusColor: Colors.white,
                  hintText: "Enter product quantity",
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
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
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: sellPriceController,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffe6e6e6),
                  contentPadding: const EdgeInsets.only(left: 10),
                  focusColor: Colors.white,
                  hintText: "Enter Sell price",
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
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
            SizedBox(
              height: 15,
            ),
            ListTile(
              tileColor: Color(0xffe6e6e6),
              leading: Text(
                "Purchase Date:",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              title: Center(
                child: ValueListenableBuilder(
                  valueListenable: dateTimeNotifier,
                  builder: (context, value, child) => Text(
                    getFormattedDateTime(value as DateTime, "dd/MM/yyyy"),
                  ),
                ),
              ),
              trailing: IconButton(
                  onPressed: () async {
                    dateTimeNotifier.value =
                    await _showRePurchaseDatePicker(context);
                  },
                  icon: Icon(
                    Icons.add,
                    color: secondaryColors,
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                  onPressed: () {
                    onSave(
                        num.parse(quantityController.text),
                        num.parse(priceController.text),
                        num.parse(sellPriceController.text),
                        dateTimeNotifier.value);
                    //  Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Re-Purchase",
                      style: TextStyle(fontSize: 16),
                    ),
                  )),
            )
          ],
        ));
  }

  Future<DateTime> _showRePurchaseDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      return selectedDate;
    }
    return DateTime.now();
  }
}