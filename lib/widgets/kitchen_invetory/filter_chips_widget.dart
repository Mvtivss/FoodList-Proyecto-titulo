import 'package:flutter/material.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> filterOptions;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChipsWidget({
    super.key,
    required this.filterOptions,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filterOptions.map((filter) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: selectedFilter == filter,
                onSelected: (bool selected) {
                  onFilterChanged(filter);
                },
                selectedColor: Colors.green[200],
                backgroundColor: Colors.grey[200],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}