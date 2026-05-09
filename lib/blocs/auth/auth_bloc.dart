import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/api_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final data = await ApiService.login(
        username: event.username,
        password: event.password,
      );
      emit(Authenticated(
        userId:   data['userId']   as String,
        username: data['username'] as String,
      ));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await ApiService.register(
        username: event.username,
        password: event.password,
        email:    event.email,
      );
      // Auto-login after successful register
      final data = await ApiService.login(
        username: event.username,
        password: event.password,
      );
      emit(Authenticated(
        userId:   data['userId']   as String,
        username: data['username'] as String,
      ));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    ApiService.logout();
    emit(Unauthenticated());
  }
}
