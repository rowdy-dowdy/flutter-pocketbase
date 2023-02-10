// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_pocketbase/models/contact_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_pocketbase/models/user_model.dart';
import 'package:flutter_pocketbase/services/dio_service.dart';

class ContactRepository {
  Ref? _ref;
  Dio? dio;

  ContactRepository(Ref ref) {
    _ref = ref;
    dio = ref.read(dioProvider);
  }

  Future<ContactModel?> fetchContact() async {
    try {
      Response response = await dio!.get('/api/v1/users');

      ContactModel contacts = ContactModel.fromMap(response.data);
      return contacts;
      
    } catch (e) {
      print({e});
      return null;
    }
  }
}

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository(ref);
});