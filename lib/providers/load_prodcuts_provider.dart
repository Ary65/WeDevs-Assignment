import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedevs_assignment/models/product_model.dart';

enum ProductFilter { newest, oldest, priceLowToHigh, priceHighToLow, bestSelling }

final productFilterProvider = StateProvider<ProductFilter>((ref) => ProductFilter.newest);

final productsProvider = FutureProvider<List<ProductsModel>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/products_data.json');
  final jsonData = json.decode(jsonString);
  var products = List<ProductsModel>.from(
    jsonData.map(
      (productJson) => ProductsModel.fromJson(productJson),
    ),
  );

  final filter = ref.watch(productFilterProvider);
  switch (filter) {
    case ProductFilter.newest:
      products.sort((a, b) => b.dateCreated!.compareTo(a.dateCreated!));
      break;
    case ProductFilter.oldest:
      products.sort((a, b) => a.dateCreated!.compareTo(b.dateCreated!));
      break;
    case ProductFilter.priceLowToHigh:
      products.sort((a, b) => double.parse(a.price!).compareTo(double.parse(b.price!)));
      break;
    case ProductFilter.priceHighToLow:
      products.sort((a, b) => double.parse(b.price!).compareTo(double.parse(a.price!)));
      break;
    case ProductFilter.bestSelling:
      products.sort((a, b) => b.totalSales!.compareTo(a.totalSales!));
      break;
  }

  return products;
});
