import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.https(
      "flutter---shopping-app-default-rtdb.europe-west1.firebasedatabase.app",
      "/shopping-list.json",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _isLoading = false;
          error = "Failed to fetch data, please try again";
        });
        return;
      }

      // Handle case where the database is empty (null response body)
      if (response.body == "null") {
        setState(() {
          _groceryItems = []; // Empty list, no error
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (categoryItem) =>
                  categoryItem.value.title == item.value['category'],
            )
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        this.error = "Failed to fetch data, please try again";
      });
      print('Error loading items: $error');
    }
  }

  Future<void> _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    // Refresh the list after adding a new item
    _loadItems();
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.removeAt(index);
    });
    final url = Uri.https(
      "flutter---shopping-app-default-rtdb.europe-west1.firebasedatabase.app",
      "/shopping-list/${item.id}.json",
    );
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Text(error!),
                )
              : _groceryItems.isEmpty
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
                            ScaffoldMessenger.of(context).clearSnackBars();
                            setState(() {
                              _removeItem(_groceryItems[index]);
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
                                .withOpacity(0.7),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          secondaryBackground: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.7),
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
