import 'package:e_commerce_app_admin/model/CategoryModel.dart';
import 'package:e_commerce_app_admin/provider/app_helper_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName="/category";
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Consumer<AppHelperProvider>(
        builder: (context, provider, _) => provider.categoryList.isEmpty
            ? const Center(
          child: Text('No item found'),
        )
            : ListView.builder(
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final category = provider.categoryList[index];
            return ListTile(
              title: Text('${category.catName} (${category.productCount})'),
            );
          },
        ),
      ),
    );
  }
  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ADD CATEGORY'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
              hintText: 'Enter new category', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CLOSE'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<AppHelperProvider>()
                  .addCategory(CategoryModel(catName: nameController.text))
                  .then((value) {
                nameController.clear();
              });
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}
