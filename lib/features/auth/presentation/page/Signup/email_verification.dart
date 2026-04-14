import 'package:dandom/features/auth/presentation/widget/mainnavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    setState(() => isLoading = true);

    await FirebaseAuth.instance.currentUser!.reload();
    final user = FirebaseAuth.instance.currentUser;

    if (user!.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigation()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ยังไม่ได้ยืนยันอีเมล")));
    }

    setState(() => isLoading = false);
  }

  Future<void> resendEmail() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("ส่งอีเมลใหม่แล้ว")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// ICON
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E7F4F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                  size: 50,
                ),
              ),

              const SizedBox(height: 30),

              /// TITLE
              const Text(
                "ยืนยันอีเมลของคุณ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              /// DESCRIPTION
              const Text(
                "เราได้ส่งลิงก์ยืนยันไปที่อีเมลของคุณแล้ว\nกรุณาเข้าไปกดยืนยันก่อนใช้งาน",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 40),

              /// RESEND BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: resendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E7F4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "ส่งอีเมลอีกครั้ง",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CHECK BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : checkEmailVerified,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3F32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "ฉันยืนยันแล้ว",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),

              SizedBox(height: 20),

              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => MainNavigation()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "เข้าใช้งานแบบ Guest",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
