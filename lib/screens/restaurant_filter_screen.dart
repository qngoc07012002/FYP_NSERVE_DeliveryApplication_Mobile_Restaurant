import 'package:flutter/material.dart';

class FoodManagementPage extends StatefulWidget {
  const FoodManagementPage({super.key});

  @override
  State<FoodManagementPage> createState() => _FoodManagementPageState();
}

class _FoodManagementPageState extends State<FoodManagementPage> {
  final List<Map<String, dynamic>> _foods = [
    {
      'name': 'Margherita Pizza',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
      'description': 'Classic Margherita with fresh basil',
      'status': 'Available',
    },
    {
      'name': 'California Roll',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
      'description': 'Fresh and delicious California Roll',
      'status': 'Out of Stock',
    },
    {
      'name': 'Cheeseburger',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
      'description': 'Juicy cheeseburger with all the fixings',
      'status': 'Available',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Food Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Handle Edit Food action
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Manage Your Foods',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                DropdownButton<String>(
                  value: 'Available', // Default value
                  items: <String>['Available', 'Out of Stock'].map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // Handle status filter action
                  },
                  isExpanded: false,
                  underline: Container(),
                  icon: const Icon(Icons.filter_list, color: Color(0xFF39c5c8)),
                  dropdownColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _foods.length,
        itemBuilder: (context, index) {
          final food = _foods[index];
          return _buildFoodItem(
            name: food['name'],
            imageUrl: food['imageUrl'],
            description: food['description'],
            status: food['status'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF39c5c8),
        child: const Icon(Icons.add),
        onPressed: () {
          // Handle add food action
        },
      ),
    );
  }

  Widget _buildFoodItem({
    required String name,
    required String imageUrl,
    required String description,
    required String status,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12.0)),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: ListTile(
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              subtitle: Text(description, style: const TextStyle(color: Colors.grey)),
              trailing: Text(
                status,
                style: TextStyle(
                  color: status == 'Available' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
