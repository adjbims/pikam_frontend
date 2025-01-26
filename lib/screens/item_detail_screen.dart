import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const ItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int quantity = 1;
  String variant = "Ice";
  String size = "Regular";
  String sugar = "Normal";
  String ice = "Normal";
  final List<String> selectedToppings = [];

  final List<Map<String, dynamic>> toppings = [
    {"name": "Extra Espresso", "price": 5000},
    {"name": "Cincau", "price": 6000},
    {"name": "Coffee Jelly", "price": 3000},
    {"name": "Chocolate Ice Cream", "price": 7000},
  ];

  int get totalPrice {
    int basePrice = widget.item["price"];
    int toppingPrice = selectedToppings
        .map((topping) =>
            toppings.firstWhere((item) => item["name"] == topping)["price"])
        .fold<int>(0, (prev, next) => prev + next as int);
    return (basePrice + toppingPrice) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Customize Order"),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.5),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image Section
            Container(
              color: const Color(0xFFFFFF),
              child: Image.asset(
                widget.item["image"],
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            // Item Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.white, // Background putih
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.item["description"],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.item["rating"]} (23)",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 1) quantity--;
                                  });
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                "$quantity",
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Customize Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.white, // Background putih
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Customize",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildOptions("Variant", ["Ice", "Hot"], variant, (value) {
                        setState(() {
                          variant = value;
                        });
                      }),
                      _buildOptions("Size", ["Regular", "Medium", "Large"], size,
                          (value) {
                        setState(() {
                          size = value;
                        });
                      }),
                      _buildOptions("Sugar", ["Normal", "Less"], sugar, (value) {
                        setState(() {
                          sugar = value;
                        });
                      }),
                      _buildOptions("Ice", ["Normal", "Less"], ice, (value) {
                        setState(() {
                          ice = value;
                        });
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Toppings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.white, // Background putih
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Topping",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...toppings.map((topping) {
                        return CheckboxListTile(
                          title: Text(
                            "${topping["name"]} (+ Rp${topping["price"]})",
                            style: const TextStyle(fontSize: 14),
                          ),
                          value: selectedToppings.contains(topping["name"]),
                          onChanged: (selected) {
                            setState(() {
                              if (selected == true) {
                                selectedToppings.add(topping["name"]);
                              } else {
                                selectedToppings.remove(topping["name"]);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Notes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Notes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Optional",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 10,
        offset: const Offset(0, -2), // Shadow di atas bottom bar
      ),
    ],
  ),
  padding: const EdgeInsets.all(16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Rp$totalPrice",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.brown,
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        onPressed: () {
          // Add Order Action
        },
        child: const Text(
          "Add Order",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Teks putih
          ),
        ),
      ),
    ],
  ),
),
    );
  }

  Widget _buildOptions(
    String title,
    List<String> options,
    String selectedOption,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((option) {
            final isSelected = selectedOption == option;
            return GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.brown : Colors.white,
                  border: Border.all(color: Colors.brown),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}