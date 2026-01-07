import 'package:dandom/model/reviewmodel.dart';
import 'package:flutter/material.dart';

class HistoryReview extends StatefulWidget {
  const HistoryReview({super.key});

  @override
  State<HistoryReview> createState() => _HistoryReviewState();
}

class _HistoryReviewState extends State<HistoryReview> {

  final List<ReviewModel> reviews = [
    ReviewModel(name: 'ร้านอาหาร A', detail: 'อร่อยมาก ⭐⭐⭐⭐⭐', rating: 5),
    ReviewModel(name: 'ร้านอาหาร B', detail: 'บริการดี ⭐⭐⭐⭐', rating: 4),
    ReviewModel(name: 'ร้านอาหาร C', detail: 'ราคาถูก ⭐⭐⭐', rating: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History Review"),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(25),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: InfoCard(review: review),
          );
        },
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final ReviewModel review;

  const InfoCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7F8F6A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.blue, width: 3),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey.shade300,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(review.detail),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(
                      review.rating,
                      (index) => const Icon(Icons.star, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
