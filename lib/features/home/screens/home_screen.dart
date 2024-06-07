import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedevs_assignment/features/home/widgets/filter_bottom_sheet.dart';
import 'package:wedevs_assignment/features/home/widgets/network_image_widget.dart';
import 'package:wedevs_assignment/features/home/widgets/rating_stars_widget.dart';
import 'package:wedevs_assignment/providers/load_prodcuts_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);
    final filter = ref.watch(productFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          TextButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => FilterBottomSheet(
                  selectedFilter: filter,
                  onFilterSelected: (newFilter) {
                    ref.read(productFilterProvider.notifier).state = newFilter;
                  },
                ),
              );
            },
            icon: const Icon(Icons.sort),
            label: const Text('Filters'),
          ),
        ],
      ),
      body: productsAsyncValue.when(
        data: (products) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final image =
                  product.images.isNotEmpty ? product.images.first : null;
              final imageUrl = image?.src;
              final rating = double.tryParse(product.averageRating ?? '0') ?? 0;
              return Card(
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: NetworkImageWidget(
                        imageUrl: imageUrl,
                        placeholderIndex: index,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? 'No Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Text(
                                product.regularPrice?.isNotEmpty ?? false
                                    ? '\$${product.regularPrice ?? '0.00'}'
                                    : '',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                '\$${product.price ?? '0.00'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          RatingStarsWidget(rating: rating),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
