part of 'bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

class AuthenticationError extends AuthenticationState {
  const AuthenticationError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class CreatingUser extends AuthenticationState {
  const CreatingUser();
}

class UserCreated extends AuthenticationState {
  const UserCreated();
}

class ErrorCreateUser extends AuthenticationState {
  const ErrorCreateUser({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingUsers extends AuthenticationState {
  const GettingUsers();
}

class UsersLoaded extends AuthenticationState {
  const UsersLoaded({required this.users});

  final List<User> users;

  @override
  List<Object> get props => users.map((user) => user.id).toList();
}

class ErrorGetUsers extends AuthenticationState {
  const ErrorGetUsers({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
