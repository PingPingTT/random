import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryReview extends StatelessWidget {
  const HistoryReview({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("กรุณาเข้าสู่ระบบ")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ประวัติการรีวิว"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 177, 199, 178),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('reviews')
            .where('userId', isEqualTo: user.uid) 
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("ยังไม่มีประวัติรีวิว"));
          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final doc = reviews[index];
              final map = doc.data() as Map<String, dynamic>;

              final ratingValue = map['rating'];
              final int rating = ratingValue is int
                  ? ratingValue
                  : (ratingValue as num).toInt();

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: InfoCard(
                  restaurantName: map['restaurantName'] ?? '',
                  comment: map['review'] ?? '',
                  rating: rating,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String restaurantName;
  final String comment;
  final int rating;

  const InfoCard({
    super.key,
    required this.restaurantName,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFA8BBA5), // สีเขียวอ่อนแบบในภาพ
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurantName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),

          /// ดาว
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
