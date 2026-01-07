import 'package:flutter/material.dart';

class contactMe extends StatefulWidget {
  const contactMe({super.key});

  @override
  State<contactMe> createState() => _contactMeState();
}

class _contactMeState extends State<contactMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Me"),
        centerTitle: true,
        backgroundColor: Colors.green[300],
      ),

      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  "E-mail --------------------------",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),

            SizedBox(height: 25),

            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  "Phone --------------------------",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
