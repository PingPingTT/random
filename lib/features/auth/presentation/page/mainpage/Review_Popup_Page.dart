import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewPopupPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const ReviewPopupPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<ReviewPopupPage> createState() => _ReviewPopupPageState();
}

class _ReviewPopupPageState extends State<ReviewPopupPage> {
  double rating = 0;
  final TextEditingController reviewController = TextEditingController();
Future<void> submitReview() async {
  if (rating == 0) return;

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final restaurantRef = FirebaseFirestore.instance
      .collection('restaurants')
      .doc(widget.restaurantId);

  final reviewRef = restaurantRef.collection('reviews');

  final batch = FirebaseFirestore.instance.batch();

  // เพิ่ม review ใต้ร้าน
  batch.set(reviewRef.doc(), {
    'restaurantId': widget.restaurantId,
    'restaurantName': widget.restaurantName,
    'rating': rating.toInt(),
    'review': reviewController.text.trim(),
    'userId': user.uid,
    'createdAt': FieldValue.serverTimestamp(),
  });

  // อัปเดตคะแนนรวม
  batch.update(restaurantRef, {
    'ratingTotal': FieldValue.increment(rating),
    'reviewCount': FieldValue.increment(1),
  });

  await batch.commit();

  // คำนวณค่าเฉลี่ย
  final snapshot = await restaurantRef.get();
  final data = snapshot.data()!;

  double total = (data['ratingTotal'] ?? 0).toDouble();
  int count = (data['reviewCount'] ?? 0).toInt();

  double newAverage = total / count;

  await restaurantRef.update({
    'rating': newAverage,
  });

  if (mounted) Navigator.pop(context);
}
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("รีวิว ${widget.restaurantName}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: rating,
            min: 0,
            max: 5,
            divisions: 5,
            label: rating.toString(),
            onChanged: (value) {
              setState(() {
                rating = value;
              });
            },
          ),
          TextField(
            controller: reviewController,
            decoration: const InputDecoration(
              hintText: "เขียนรีวิว...",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("ปิด"),
        ),
        ElevatedButton(
          onPressed: submitReview,
          child: const Text("ส่งรีวิว"),
        ),
      ],
    );
  }
}
