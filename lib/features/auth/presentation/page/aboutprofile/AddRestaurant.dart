import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRestaurant extends StatefulWidget {
  const AddRestaurant({super.key});

  @override
  State<AddRestaurant> createState() => _AddRestaurantState();
}

class _AddRestaurantState extends State<AddRestaurant> {
  final TextEditingController mallController = TextEditingController();
  final TextEditingController restaurantController = TextEditingController();
  final TextEditingController floorController = TextEditingController();

  List<String> selectedCategories = [];

  final List<String> foodCategories = [
    "อาหารไทย",
    "อาหารญี่ปุ่น",
    "อาหารเกาหลี",
    "อาหารจีน",
    "อาหารฝรั่ง",
    "ฟาสต์ฟู้ด",
    "ของหวาน",
    "เครื่องดื่ม",
    "บุฟเฟ่",
  ];

  Future<void> addRestaurant() async {
    try {
      final mallName = mallController.text.trim();
      final restaurantName = restaurantController.text.trim();
      final floor = floorController.text.trim();

      if (mallName.isEmpty ||
          restaurantName.isEmpty ||
          floor.isEmpty ||
          selectedCategories.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")));
        return;
      }

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('restaurants').add({
        'mallName': mallName,
        'restaurantName': restaurantName,
        'floor': floor,
        'categories': selectedCategories,
        'rating': 0.0,
        'ratingTotal': 0.0,
        'reviewCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'ownerId': user?.uid,
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $e")));
    }
  }

  @override
  void dispose() {
    mallController.dispose();
    restaurantController.dispose();
    floorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เพิ่มร้านอาหาร"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 177, 199, 178),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: mallController,
              decoration: InputDecoration(
                hintText: "ชื่อห้างสรรพสินค้า",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: restaurantController,
              decoration: InputDecoration(
                hintText: "ชื่อร้าน",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: floorController,
              decoration: InputDecoration(
                hintText: "ชั้น (เช่น ชั้น 3)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "ประเภทอาหาร",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: foodCategories.map((category) {
                final isSelected = selectedCategories.contains(category);

                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedCategories.add(category);
                      } else {
                        selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addRestaurant,
                child: const Text("บันทึก", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
