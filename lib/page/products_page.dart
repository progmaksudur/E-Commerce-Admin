import 'package:e_commerce_app_admin/page/product_page_details.dart';
import 'package:e_commerce_app_admin/provider/app_helper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'new_product_page.dart';

class ProductsPage extends StatefulWidget {
  static const String routeName="/products";
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: const Text("Products"),
      ),
      body: Consumer<AppHelperProvider>(
        builder: (context, provider, _) => provider.productList.isEmpty
            ? const Center(
          child: Text('No item found'),
        )
            : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
          itemCount: provider.productList.length,
          itemBuilder: (context, index) {
              final product = provider.productList[index];
              return ListTile(
                onTap: () => Navigator.pushNamed(
                    context,
                    ProductDetailsPage.routeName,
                    arguments: product.id
                ),
                leading: Image.network(product.imageUrl!,fit: BoxFit.cover,height: 60,width: 60,),
                title: Text(product.name!),
              );
          },
        ),
            ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, NewProductPage.routeName);
      },child:const Icon(Icons.add)),

    );
  }
}
