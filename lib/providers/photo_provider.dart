import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoProvider extends ChangeNotifier {

  List photos = [];

  bool isLoading = false;

  String errorMessage = '';

  Future<void> getPhotos() async {

    try {

      isLoading = true;

      notifyListeners();

      final response = await http.get(
        Uri.parse(
          'https://picsum.photos/v2/list?page=2&limit=10',
        ),
      );

      if (response.statusCode == 200) {

        photos = json.decode(response.body);

      } else {

        errorMessage = 'Gagal mengambil data';
      }

    } catch (e) {

      errorMessage = e.toString();

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }
}