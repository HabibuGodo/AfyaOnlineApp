import 'package:flutter/material.dart';

class Category {
  final String category;
  final IconData categoryIcon;

  Category(this.category, this.categoryIcon);

  static List<Category> categoryList() {
    List<Category> list = [];
    list.add(Category('All', Icons.dashboard));
    list.add(Category('Buy & Selling', Icons.apartment_outlined));
    list.add(Category('Renting', Icons.cottage_outlined));
    list.add(Category('Events', Icons.event));

    return list;
  }
}
