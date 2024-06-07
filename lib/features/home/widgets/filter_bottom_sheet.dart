import 'package:flutter/material.dart';
import 'package:wedevs_assignment/providers/load_prodcuts_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  final ProductFilter selectedFilter;
  final void Function(ProductFilter) onFilterSelected;

  const FilterBottomSheet({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  ProductFilter? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Filter by:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          RadioListTile<ProductFilter>(
            title: const Text('Newest'),
            value: ProductFilter.newest,
            groupValue: _selectedFilter,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFilter = value;
                  widget.onFilterSelected(value);
                });
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<ProductFilter>(
            title: const Text('Oldest'),
            value: ProductFilter.oldest,
            groupValue: _selectedFilter,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFilter = value;
                  widget.onFilterSelected(value);
                });
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<ProductFilter>(
            title: const Text('Price: Low to High'),
            value: ProductFilter.priceLowToHigh,
            groupValue: _selectedFilter,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFilter = value;
                  widget.onFilterSelected(value);
                });
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<ProductFilter>(
            title: const Text('Price: High to Low'),
            value: ProductFilter.priceHighToLow,
            groupValue: _selectedFilter,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFilter = value;
                  widget.onFilterSelected(value);
                });
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<ProductFilter>(
            title: const Text('Best Selling'),
            value: ProductFilter.bestSelling,
            groupValue: _selectedFilter,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFilter = value;
                  widget.onFilterSelected(value);
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
