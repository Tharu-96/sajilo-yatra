import 'package:flutter/foundation.dart';

import 'auth_user.dart';

/// App-wide auth state used by GoRouter's [refreshListenable] to gate routes.
///
/// A single shared instance keeps navigation and the router in sync without
/// pulling Riverpod into the router configuration.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier._();

  static final AuthChangeNotifier instance = AuthChangeNotifier._();

  bool _isLoggedIn = false;
  AuthUser? _user;

  bool get isLoggedIn => _isLoggedIn;
  AuthUser? get user => _user;

  void setLoggedIn(AuthUser user) {
    _isLoggedIn = true;
    _user = user;
    notifyListeners();
  }

  void setLoggedOut() {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}
