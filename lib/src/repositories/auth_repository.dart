import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<UserModel> login(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<UserModel> register(String name, String email, String password) async {
    return await _authService.register(name, email, password);
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  UserModel? get currentUser => _authService.currentUser;
}
