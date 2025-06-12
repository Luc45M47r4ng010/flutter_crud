// import 'dart:convert';
import '../services/api_service.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _apiService = ApiService();

  Future<bool> login() async {
    try {
      await _apiService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      return true;
    } catch (e) {
      print('Erro no login: $e');
      rethrow;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Digite um e-mail';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Digite a senha';
    if (value.length < 6) return 'Senha deve ter ao menos 6 caracteres';
    return null;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}