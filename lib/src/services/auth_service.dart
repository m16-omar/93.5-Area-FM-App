import '../models/user_model.dart';
import '../../const/app_assets.dart';

class AuthService {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      id: 'user_1',
      name: 'Alex Johnson',
      email: email,
      avatarUrl: AppAssets.userAvatarPlaceholder,
    );
    return _currentUser!;
  }

  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      avatarUrl: AppAssets.userAvatarPlaceholder,
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }
}
