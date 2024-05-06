import 'package:petrol/auth/auth_service.dart';
import 'package:petrol/auth/login_screen.dart';
import 'package:petrol/company_form.dart';
import 'package:petrol/company.dart';
import 'package:petrol/widgets/button.dart';
import 'package:flutter/material.dart';

class HomeScreen2 extends StatelessWidget {
  const HomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome User",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              
              Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompanyFormScreen()),
      );
            }, child: Text("Add")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              
              Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompanyListScreen()),
      );
            }, child: Text("see")),
            const SizedBox(height: 20),
            CustomButton(
              label: "Sign Out",
              onPressed: () async {
                await auth.signout();
                goToLogin(context);
              },
            )
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
}