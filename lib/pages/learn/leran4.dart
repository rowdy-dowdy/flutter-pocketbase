import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({required this.id, required this.title, required this.description, required this.isFavorite});

  Film copy({required bool isFavorite}) {
    return Film(id: id, title: title, description: description, isFavorite: isFavorite);
  }

  @override
  String toString() => 'Film(id: $id, title: $title, description: $description, isFavorite: $isFavorite )';

  @override
  bool operator == (covariant Film other) => 
    id == other.id && isFavorite == other.isFavorite;
  
  @override
  int get hashCode => Object.hashAll([id, isFavorite]);
}

const allFilms = [
  Film(id: '1', title: 'Spider-Man: No Way Home', description: 'Peter Parker is unmasked and no', isFavorite: true),
  Film(id: '2', title: 'Eternals', description: 'The Eternals are a team of ancient aliens', isFavorite: true),
  Film(id: '3', title: 'Shang-Chi and the Legend', description: 'Shang-Chi must confront the past', isFavorite: true),
  Film(id: '4', title: 'Black Widow', description: 'Natasha Romanoff, also known as Black', isFavorite: true),
  Film(id: '5', title: 'Spider-Man: Far from', description: 'Peter Parker and his friends go', isFavorite: true),
  Film(id: '6', title: 'Avengers: Endgame', description: 'After the devastating events', isFavorite: true),
  Film(id: '7', title: 'Captain Marvel', description: 'The story follows Carol Danvers', isFavorite: true)
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier(): super(allFilms);
  
  void update(Film film, bool isFavorite) {
    state = state.map((thisFilm) => 
      thisFilm.id == film.id
      ? thisFilm.copy(isFavorite: isFavorite)
      : thisFilm
    ).toList();
  }
}

enum FavoriteStatus {
  all,
  favorite,
  notFavorite
}

final favoriteStatusProvider = StateProvider<FavoriteStatus>((ref) {
  return FavoriteStatus.all;
});

final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>((ref) {
  return FilmsNotifier();
});

final favoriteFilmsProvider = Provider<Iterable<Film>>((ref) {
  return ref.watch(allFilmsProvider).where((film) => film.isFavorite);
});

final notFavoriteFilmsProvider = Provider<Iterable<Film>>((ref) {
  return ref.watch(allFilmsProvider).where((film) => !film.isFavorite);
});

class Learn4Screen extends ConsumerWidget {
  const Learn4Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Learn 4'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const FilterWidget(),
            Consumer(builder: (context, ref, child) {
              final filter = ref.watch(favoriteStatusProvider);

              switch (filter) {
                case FavoriteStatus.all:
                  return FilmsWidget(provider: allFilmsProvider);
                case FavoriteStatus.favorite:
                  return FilmsWidget(provider: favoriteFilmsProvider);
                case FavoriteStatus.notFavorite:
                  return FilmsWidget(provider: notFavoriteFilmsProvider);
              }
            })
          ],
        )
      ),
     
    );
  }
}

class FilmsWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsWidget({required this.provider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          final favoriteIcon = film.isFavorite
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border);
          
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              icon: favoriteIcon,
              onPressed: () {
                final isFavorite = !film.isFavorite;
                ref.watch(allFilmsProvider.notifier).update(film, isFavorite);
              },
            ),
          );
        },
      ),
    );
  }
}

class FilterWidget extends ConsumerWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      return DropdownButton(
        value: ref.watch(favoriteStatusProvider),
        items: FavoriteStatus.values.map((fs) => 
          DropdownMenuItem(
            value: fs,
            child: Text(fs.toString().split('.').last),
          )
        ).toList(),
        onChanged: (FavoriteStatus? fs) {
          ref.read(favoriteStatusProvider.notifier).state = fs!;
        },
      );
    });
  }
}