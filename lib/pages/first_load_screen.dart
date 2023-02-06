import 'package:flutter/material.dart';
import 'package:flutter_pocketbase/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstLoadScreen extends ConsumerWidget {
  const FirstLoadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SafeArea(
        child: Center(
          child: Text('Loadding ...', style: TextStyle(color: white),),
        ),
      ),
    );
  }
}