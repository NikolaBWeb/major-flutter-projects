import 'package:flutter/material.dart';
import 'package:restaurant_app/data/dummy_data.dart';
import 'package:restaurant_app/models/category.dart';
import 'package:restaurant_app/screens/meals.dart';
import 'package:restaurant_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  void selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyrestaurant_app
        .where(
          (meal) => meal.categories.contains(category.id),
        )
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) =>
            MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
       GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                selectCategory(context, category);
              },
            ),
        ],
      );
  }
}
