import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketbaseNotifier extends StateNotifier<PocketBase> {
  PocketbaseNotifier(): super(PocketBase('https://base.viethung.fun'));
  PocketBase? get value => state;
}

final pocketbaseProvider = StateNotifierProvider<PocketbaseNotifier, PocketBase>((ref) => PocketbaseNotifier());