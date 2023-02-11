import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_pocketbase/providers/chat_provider.dart';
import 'package:flutter_pocketbase/providers/router_provider.dart';
import 'package:flutter_pocketbase/services/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketProvider = Provider((ref) {
  final router = ref.watch(routerProvider);

  IO.Socket socket = IO.io('http://localhost:5173', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  socket.connect();

  // socket.on('message', (data) {
  //   print(data['message']['roomId']);
  //   ref.read(chatStreamProvider(data['message']['roomId']).stream);
  //   // print(ref.read(chatControllerProvider).chatStream(data['message']['roomId'])).va;
  // });

  return socket;
});
