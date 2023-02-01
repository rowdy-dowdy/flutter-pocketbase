import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// counter
class CounterNotifier extends StateNotifier<int?> {
  CounterNotifier(): super(null);
  void increment() => state = state == null ? 1 : state! + 1;
  int? get value => state;
}

final counter_provider = StateNotifierProvider<CounterNotifier, int?>((ref) => CounterNotifier());

// weather
enum City {
  vietnam,
  paris,
  tokyo
}

Future<String> getWeather(City city) {
  return Future.delayed(const Duration(seconds: 1), () {
    return {
      City.vietnam: '⛅',
      City.tokyo: '🌧️',
      City.paris: '⚡'
    }[city]!;
  });
}

final currentCityProvider = StateProvider<City?>((ref) {
  return null;
});

final weatherProvider = FutureProvider<String>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  }
  else {
    return '🤷‍♀️';
  }
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counter_provider);

    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              child: Consumer(builder: (context, ref, child) {
                final count = ref.watch(counter_provider);
                final text = count == null ? 'Press the button' : count.toString();
                return Text(text);
              }),
            ),
            TextButton(
              onPressed: () {
                ref.read(counter_provider.notifier).increment();
              },
              child: const Text(
                'Increment counter'
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentWeather.when(
                  data: (data) => Text(
                    data,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 39
                    ),
                  ),
                  error: (_,__) => const Text('Error 😭'),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  )
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: City.values.length,
                itemBuilder: (context, index) {
                  final city = City.values[index];
                  final isSelected = city == ref.watch(currentCityProvider);

                  return ListTile(
                    title: Text(
                      city.toString()
                    ),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () => ref.read(currentCityProvider.notifier).state = city,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}