import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class Learn5Screen extends ConsumerWidget {
  const Learn5Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Learn 5'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container() 
      ),
     
    );
  }
}
