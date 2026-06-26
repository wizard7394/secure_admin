import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isSuccess = await _authRepository.login(
        event.username,
        event.password,
      );

      if (isSuccess) {
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure('Login failed. Please check your credentials.'));
      }
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      emit(AuthFailure(errorMsg));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      if (isAuthenticated) {
        emit(AuthSuccess());
      } else {
        emit(AuthInitial());
      }
    } catch (_) {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(AuthInitial());
  }
}
