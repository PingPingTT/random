import 'package:flutter/material.dart';

class AddRestaurant extends StatelessWidget {
  const AddRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Restaurant"),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [

            // ชื่อห้าง
            TextField(
              decoration: InputDecoration(
                hintText: "ชื่อห้างสรรพสินค้า",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ชื่อร้าน
            TextField(
              decoration: InputDecoration(
                hintText: "ชื่อร้าน",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// 🔹 ปุ่มบันทึก
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "บันทึก",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
