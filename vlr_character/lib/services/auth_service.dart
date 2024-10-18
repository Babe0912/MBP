import 'package:pocketbase/pocketbase.dart';
import '../models/user.dart';

class AuthService {
  final PocketBase pb = PocketBase('http://127.0.0.1:8090');

  Future<User> register(String email, String password, String passwordConfirm, String role) async {
  try {
    final authData = await pb.collection('users').create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'role': role,
    });
    return User.fromJson(authData.toJson());
  } catch (e) {
    if (e is ClientException) {
      // จัดการข้อผิดพลาดเฉพาะของ PocketBase
      if (e.response['data']?['email'] != null) {
        throw 'Email is invalid or already in use';
      }
    }
    throw 'Registration failed: $e';
  }
}

  Future<bool> isEmailTaken(String email) async {
  try {
    final result = await pb.collection('users').getList(
      filter: 'email = "$email"',
      page: 1,
      perPage: 1,
    );
    return result.items.isNotEmpty;
  } catch (e) {
    print('Error checking email: $e');
    return false;
  }
}

  Future<User> login(String email, String password) async {
    final authData = await pb.collection('users').authWithPassword(email, password);
    return User.fromJson(authData.record!.toJson());
  }

  Future<void> logout() async {
    pb.authStore.clear();
  }

  bool get isLoggedIn => pb.authStore.isValid;

  String get token => pb.authStore.token;

  User? get currentUser => 
      pb.authStore.model != null ? User.fromJson(pb.authStore.model!.toJson()) : null;
}