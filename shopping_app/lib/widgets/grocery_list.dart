import 'package:flutter/material.dart';

import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _groceryItems.isEmpty
          ? Center(
              child: Text(
                "You have no items currently in your groceries",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) {
                final itemName = _groceryItems[index].name;
                final itemColor = _groceryItems[index].category.color;

                return Dismissible(
                  key: Key(_groceryItems[index].id),
                  onDismissed: (direction) {
                    setState(() {
                      _groceryItems.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$itemName dismissed'),
                        backgroundColor: itemColor,
                      ),
                    );
                  },
                  background: Container(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.7), // Color for swipe-to-dismiss action
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(
                        0.7), // Color for swipe-to-dismiss in the other direction
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  child: ListTile(
                    title: Text(_groceryItems[index].name),
                    leading: Icon(
                      Icons.square,
                      color: _groceryItems[index].category.color,
                    ),
                    trailing: Text(
                      _groceryItems[index].quantity.toString(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
