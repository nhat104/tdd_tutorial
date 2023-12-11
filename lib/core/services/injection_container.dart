import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tdd_tutorial/src/authentication/data/auth_repo_implementation.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App logic
    ..registerFactory(
      () => AuthenticationCubit(createUser: sl(), getUsers: sl()),
    )

    // Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // Repository
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))

    // Data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthRemoteDataSrcImplementation(sl()))

    // External Dependencies
    ..registerLazySingleton(Client.new);
}
