import 'package:flutter/material.dart';

class AppConstants {
  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static const List<_CategoryItem> _categories = [
    _CategoryItem(value: 'Phones', label: 'Telefonlar'),
    _CategoryItem(value: 'Laptops', label: 'Laptoplar'),
    _CategoryItem(value: 'Electronics', label: 'Elektronik'),
    _CategoryItem(value: 'Watches', label: 'Saatler'),
    _CategoryItem(value: 'Clothes', label: 'Giyim'),
    _CategoryItem(value: 'Shoes', label: 'Ayakkabılar'),
    _CategoryItem(value: 'Books', label: 'Kitaplar'),
    _CategoryItem(value: 'Cosmetics', label: 'Kozmetik'),
    _CategoryItem(value: 'Accessories', label: 'Aksesuarlar'),
  ];

  static List<String> categoriesList =
      _categories.map((category) => category.value).toList();

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
        List<DropdownMenuItem<String>>.generate(
      _categories.length,
      (index) => DropdownMenuItem(
        value: _categories[index].value,
        child: Text(_categories[index].label),
      ),
    );
    return menuItem;
  }
}

class _CategoryItem {
  const _CategoryItem({required this.value, required this.label});

  final String value;
  final String label;
}
