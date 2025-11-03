import 'package:flutter/material.dart';
import 'package:fulupo_ums/models/productModel.dart';

class ProductSearchDelegate extends SearchDelegate<String?> {
  final List<ProductModel> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where(
          (product) => product.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text("Code: ${product.productCode}"),
          onTap: () {
            close(context, product.id); // ✅ Return the product id
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where(
          (product) => product.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            query = product.name;
            close(context, product.id); // ✅ Return product id
          },
        );
      },
    );
  }
}
