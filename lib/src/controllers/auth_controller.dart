import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider((ref) => AuthService());
final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(authServiceProvider)));

class CurrentUserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return ref.watch(authRepositoryProvider).currentUser;
  }

  void setUser(UserModel? user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}

final currentUserProvider = NotifierProvider<CurrentUserNotifier, UserModel?>(CurrentUserNotifier.new);
