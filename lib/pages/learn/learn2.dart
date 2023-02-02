import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const names = ['1','2','3','4','5','6','7','8','9','10','11'];

final tickerProvider = StreamProvider((ref) => 
  Stream.periodic(const Duration(seconds: 1), (i) => i + 1)
);

final namesProvider = StreamProvider((ref) {
  return ref.watch(tickerProvider.stream).map((count) => names.getRange(0, count));
});

class Learn2Screen extends ConsumerWidget {
  const Learn2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn 2'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: names.when(
                data: (names) {
                  return ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(names.elementAt(index)),
                      );
                    },
                  );
                },
                error: (_, __) => const Text('Reach the end of the list!'),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}