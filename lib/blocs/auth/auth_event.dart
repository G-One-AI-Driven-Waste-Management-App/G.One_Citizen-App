import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  LoginRequested(this.username, this.password);
  @override
  List<Object?> get props => [username, password];
}

// NEW — used by the Register button on the login page
class RegisterRequested extends AuthEvent {
  final String username;
  final String password;
  final String? email;
  RegisterRequested({required this.username, required this.password, this.email});
  @override
  List<Object?> get props => [username, password, email];
}

class LogoutRequested extends AuthEvent {}
