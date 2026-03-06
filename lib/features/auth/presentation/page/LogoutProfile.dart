import 'package:dandom/features/auth/presentation/page/login.dart';
import 'package:flutter/material.dart';

class LogOutProfile extends StatefulWidget {
  const LogOutProfile({super.key});

  @override
  State<LogOutProfile> createState() => _LogOutProfileState();
}

class _LogOutProfileState extends State<LogOutProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("โปรไฟล์"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 177, 199, 178),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ชื่อผู้ใช้",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Guest",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            SizedBox(height: 30),
            // ListTile(
            //           leading: const Icon(Icons.contact_mail),
            //           title: const Text("ติดต่อเรา"),
            //           trailing: const Icon(Icons.chevron_right),
            //           onTap: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(builder: (context) => const contactMe()),
            //             );
            //           },
            //         ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("เข้าสู่ระบบ"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
