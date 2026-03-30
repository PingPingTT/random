import 'package:dandom/features/auth/presentation/page/mainpage/Review_Popup_Page.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

  String? randomRestaurant;
  bool isLoading = false;
  Timer? reviewTimer;
  double? restaurantRating;
  String? selectedRestaurantId;
  String? restaurantFloor;

  List<String> selectedCategories = [];
  List<String> mallSuggestions = [];
  List<String> allMalls = [];

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

  Future<void> randomRestaurantFromMall() async {
    final mallName = searchController.text.trim();
    if (mallName.isEmpty) return;

    setState(() {
      isLoading = true;
      randomRestaurant = null;
      restaurantRating = null;
    });

    Query query = FirebaseFirestore.instance
        .collection('restaurants')
        .where('mallName', isEqualTo: mallName);

    if (selectedCategories.isNotEmpty) {
      query = query.where('categories', arrayContainsAny: selectedCategories);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      setState(() {
        randomRestaurant = "ไม่พบร้านที่ตรงเงื่อนไข";
        isLoading = false;
      });
      return;
    }

    final random = Random();
    final randomDoc = snapshot.docs[random.nextInt(snapshot.docs.length)];

    setState(() {
      randomRestaurant = randomDoc['restaurantName'];
      restaurantRating = (randomDoc['rating'] ?? 0).toDouble();
      restaurantFloor = randomDoc['floor'];
      selectedRestaurantId = randomDoc.id;
      isLoading = false;
    });

    startReviewTimer();
  }

  void startReviewTimer() {
    reviewTimer?.cancel();

    reviewTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => ReviewPopupPage(
          restaurantId: selectedRestaurantId!,
          restaurantName: randomRestaurant!,
        ),
      );
    });
  }

  @override
  void dispose() {
    reviewTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchMalls();
  }

  Future<void> fetchMalls() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .get();

    final malls = snapshot.docs
        .map((doc) => doc['mallName'] as String)
        .toSet()
        .toList();

    setState(() {
      allMalls = malls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("กินอะไรดี ?")),
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
              controller: searchController,
              decoration: InputDecoration(
                hintText: "พิมพ์ชื่อห้าง",
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.circular(10),),
              ),
              onChanged: (value) {
                setState(() {
                  mallSuggestions = allMalls
                      .where(
                        (mall) =>
                            mall.toLowerCase().contains(value.toLowerCase()),
                      )
                      .toList();
                });
              },
            ),

            if (mallSuggestions.isNotEmpty && searchController.text.isNotEmpty)
              Container(
                height: 150,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  itemCount: mallSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(mallSuggestions[index]),
                      onTap: () {
                        setState(() {
                          searchController.text = mallSuggestions[index];
                          mallSuggestions.clear();
                        });
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            /// 🏷 เลือกประเภทหลายอัน
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

            /// 🔴 กล่องแสดงผล
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Color(0x909E826B),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            randomRestaurant ?? "ยังไม่ได้สุ่ม",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          if (restaurantFloor != null)
                            Text(
                              "ชั้น: $restaurantFloor",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),

                          const SizedBox(height: 15),

                          if (restaurantRating != null)
                            Text(
                              "คะแนนร้าน: ${restaurantRating!.toStringAsFixed(1)} ⭐",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 60),

            /// 🎲 ปุ่ม Random
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 54, 67, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {randomRestaurantFromMall();},
                child: const Text("Random", style: TextStyle(fontSize: 18,color: Colors .white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
