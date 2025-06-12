class AuthService {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return email == 'admin@email.com' && password == '123456';
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simula sucesso de cadastro
    return true;
  }
}
