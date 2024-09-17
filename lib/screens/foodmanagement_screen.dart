import 'package:flutter/material.dart';

class FoodManagementPage extends StatefulWidget {
  const FoodManagementPage({Key? key}) : super(key: key);

  @override
  State<FoodManagementPage> createState() => _FoodManagementPageState();
}

class _FoodManagementPageState extends State<FoodManagementPage> {
  // Sample data for food items
  final List<FoodItem> _foodItems = [
    FoodItem('Burger', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s', 'abmcm', true),
    FoodItem('Pizza', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s', 'abcx', false),
    FoodItem('Salad', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s', '123', true),
    FoodItem('Sushi', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s', '123', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          backgroundColor: const Color(0xFF39c5c8),
          centerTitle: true,
          title: const Text(
            'Food Management',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _foodItems.length,
        itemBuilder: (context, index) {
          final foodItem = _foodItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            // Card color changes based on availability
            color: foodItem.isAvailable ? Colors.white : Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food image (square)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      foodItem.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Food information (name)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodItem.name,
                          style: TextStyle(
                            fontSize: 20, // Larger font size for name
                            fontWeight: FontWeight.w600, // Slightly lighter font weight
                            color: foodItem.isAvailable
                                ? Colors.black
                                : Colors.grey[600], // Greyed out text if unavailable
                          ),
                        ),
                        const SizedBox(height: 8), // Space between name and description
                        Text(
                          foodItem.description ?? 'No description available', // Handle null
                          style: TextStyle(
                            fontSize: 16, // Smaller font size for description
                            fontWeight: FontWeight.w400, // Lighter font weight for description
                            color: foodItem.isAvailable
                                ? Colors.black87 // Slightly lighter black if available
                                : Colors.grey[600], // Greyed out text if unavailable
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Switch and Edit button
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: foodItem.isAvailable,
                        onChanged: (bool value) {
                          setState(() {
                            foodItem.isAvailable = value;
                          });
                          print(
                              '${foodItem.name} status changed to ${value ? 'Available' : 'Unavailable'}');
                        },
                        activeColor: const Color(0xFF39c5c8), // Green when active
                        inactiveThumbColor: Colors.red, // Red when inactive
                        inactiveTrackColor: Colors.red[200],
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          print('Edit ${foodItem.name}');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF39c5c8),
        onPressed: () {
          print('Add new food item');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FoodItem {
  String name;
  String imageUrl;
  String? description; // Nullable
  bool isAvailable;

  FoodItem(this.name, this.imageUrl, this.description, this.isAvailable);
}

void main() {
  runApp(const MaterialApp(
    home: FoodManagementPage(),
  ));
}
