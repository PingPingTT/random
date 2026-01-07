import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Randomapp")),
        backgroundColor: Colors.green[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "search restaurant",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 50),

            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(40),
              ),
            ),

            const SizedBox(height: 100),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // ignore: avoid_print
                  print("Random Restaurant");
                },
                child: const Text(
                  "Random",
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
