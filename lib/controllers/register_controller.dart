// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _apiService = ApiService();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Digite seu nome';
    if (value.length < 3) return 'Nome muito curto';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Digite seu email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) return 'Senha deve ter 6 caracteres';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) return 'As senhas não coincidem';
    return null;
  }

  Future<bool> register() async {
    try {
      await _apiService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      return true;
    } catch (e) {
      print('Erro no cadastro: $e');
      rethrow;
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}