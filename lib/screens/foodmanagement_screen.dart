import 'package:flutter/material.dart';

class FoodManagementPage extends StatefulWidget {
  const FoodManagementPage({super.key});

  @override
  State<FoodManagementPage> createState() => _FoodManagementPageState();
}

class _FoodManagementPageState extends State<FoodManagementPage> {
  final List<Food> _foods = [
    Food(
      name: 'Pizza Margherita',
      imageUrl: 'https://example.com/images/pizza_margherita.jpg',
      description: 'Classic pizza with tomatoes, mozzarella, and basil.',
      isAvailable: true,
    ),
    Food(
      name: 'Sushi Roll',
      imageUrl: 'https://example.com/images/sushi_roll.jpg',
      description: 'Fresh sushi rolls with various fillings.',
      isAvailable: true,
    ),
    Food(
      name: 'Cheeseburger',
      imageUrl: 'https://example.com/images/cheeseburger.jpg',
      description: 'Juicy cheeseburger with all the toppings.',
      isAvailable: false,
    ),
  ];

  void _toggleAvailability(int index) {
    setState(() {
      _foods[index].isAvailable = !_foods[index].isAvailable;
    });
  }

  void _editFood(int index) {
    // Implement edit functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Management'),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _foods.length,
        itemBuilder: (context, index) {
          final food = _foods[index];
          return _buildFoodItem(food, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add new food functionality
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF39c5c8),
      ),
    );
  }

  Widget _buildFoodItem(Food food, int index) {
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
              food.imageUrl.isNotEmpty ? food.imageUrl : 'https://via.placeholder.com/120',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, size: 120);
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: ListTile(
              title: Text(food.name.isNotEmpty ? food.name : 'No Name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              subtitle: Text(food.description.isNotEmpty ? food.description : 'No Description', style: const TextStyle(color: Colors.grey)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    food.isAvailable ? Icons.check_circle : Icons.cancel,
                    color: food.isAvailable ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 4.0),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editFood(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.toggle_on),
                    onPressed: () => _toggleAvailability(index),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Food {
  final String name;
  final String imageUrl;
  final String description;
  bool isAvailable;

  Food({
    required this.name,
    required this.imageUrl,
    required this.description,
    this.isAvailable = true,
  });
}
