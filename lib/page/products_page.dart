import 'package:e_commerce_app_admin/page/product_page_details.dart';
import 'package:e_commerce_app_admin/provider/app_helper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_view.dart';
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
          child:Text("No product found"),
        )
            : GridView.builder(
            padding:const EdgeInsets.only(left: 5,right: 5,top: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
            itemCount: provider.productList.length,
            itemBuilder: (context, index) => ProductItem(product: provider.productList[index])),),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, NewProductPage.routeName);
      },child:const Icon(Icons.add)),

    );
  }
}
