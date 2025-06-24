import 'package:flutter/material.dart';

class CategorySelect extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onAddCategory;

  const CategorySelect({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onAddCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            value: selectedCategory,
            isExpanded: true,
            onChanged: (yeni) {
              if (yeni != null) onCategoryChanged(yeni);
            },
            items: categories
                .map((k) => DropdownMenuItem(
              value: k,
              child: Text(k),
            ))
                .toList(),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: onAddCategory,
        ),
      ],
    );
  }
}
