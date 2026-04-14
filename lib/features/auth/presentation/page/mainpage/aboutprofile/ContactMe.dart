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
        title: Text("ติดต่อเรา"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 177, 199, 178),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
      ),
      ),

      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 95, 118, 97),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "E-mail : Sophonwit.sjw@gmail.com",
                   style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 25),

            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 95, 118, 97),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "Phone : 0923140211",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
