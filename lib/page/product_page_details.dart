


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
    final pid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Consumer<AppHelperProvider>(
        builder: (context, provider, _) => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getProductById(pid),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              return ListView(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'asstes/images/addproduct.png',
                    image: product.imageUrl!,
                    fadeInCurve: Curves.bounceInOut,
                    fadeInDuration: const Duration(seconds: 3),
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {

                        },
                        child: const Text('Re-Purchase'),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.getPurchaseByProduct(pid);
                          _showPurchaseHistoryBottomSheet(context);
                        },
                        child: const Text('Purchase History'),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text(product.name!),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: Text('$currencySymbol${product.salePrice}'),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: const Text('Product Description'),
                    subtitle: Text(product.description ?? 'Not Available'),
                    trailing: IconButton(
                      onPressed: () {},
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
            if(snapshot.hasError) {
              return const Center(child: Text('Failed'),);
            }
            return const Center(child: CircularProgressIndicator(),);
          } ,
        ),
      ),

    );
  }

  void _showPurchaseHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer<AppHelperProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.purchaseListOfSpecificProduct.length,
          itemBuilder: (context, index) {
            final purModel = provider.purchaseListOfSpecificProduct[index];
            return ListTile(
              //textColor: Colors.blue,
              title: Text(getFormattedDateTime(purModel.dateModel.timestamp.toDate(), 'dd/MM/yyyy')),
              subtitle: Text('Quantity: ${purModel.quantity}'),
              trailing: Text('$currencySymbol${purModel.purchaseprice}'),
            );
          },
        ),
      ),);
  }
}