import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/components/loading_screen.dart';
import 'package:flutter_pocketbase/providers/auth_provider.dart';
import 'package:flutter_pocketbase/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final emailController = TextEditingController(text: 'viet.hung.2898@gmail.com');
  final passwordController = TextEditingController(text: 'Admin123!');

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
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
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email address',
                ),
              )
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
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
                onPressed: () async {
                  // case 1
                  _onLoading(context);
                  await ref.read(authProvider.notifier)
                    .login(emailController.text, passwordController.text);
                  Navigator.of(context).pop();

                  // case 2
                  // LoadingScreen.instance().show(context: context);
                  // await ref.read(authProvider.notifier)
                  //   .login(emailController.text, passwordController.text);
                  // LoadingScreen.instance().hide();
                },
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

void _onLoading(BuildContext context) {
  final size = MediaQuery.of(context).size;
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.8,
            maxHeight: size.height * 0.8,
            minWidth: size.width * 0.5
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10,),
                  Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  );
}