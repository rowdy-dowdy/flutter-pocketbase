import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final emailController = TextEditingController(text: 'viet.hung.2898@gmail.com');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Việt Hùng Ít',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),
            ),

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email address',
                ),
              )
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              )
            ),

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () { },
                child: const Text('Sign in'),
              )
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Does not have account?'),
                  const SizedBox(width: 5,),
                  GestureDetector( 
                    onTap: () => {},
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}