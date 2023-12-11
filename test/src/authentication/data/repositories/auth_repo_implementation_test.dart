import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/auth_repo_implementation.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;
  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  group('createUser', () {
    const createdAt = '2021-09-01';
    const name = 'Test';
    const avatar = 'https://test.com';

    test(
        'should call the [RemoteDataSource.createUser] and complete successfully '
        'when the call to the remote source is successful', () async {
      when(() => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenAnswer((_) async => Future.value());

      final res = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      expect(res, equals(const Right(null)));

      verify(() => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return [ServerFailure] when unsuccessful', () async {
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenThrow(
          const ServerException(message: 'Server Error', statusCode: 500));

      final res = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      expect(
          res,
          equals(const Left(
              ServerFailure(message: 'Server Error', statusCode: 500))));
      verify(() => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUser', () {
    test(
        'should call the [RemoteDataSource.getUsers] and return List<User> when successful',
        () async {
      when(() => remoteDataSource.getUsers())
          .thenAnswer((_) async => Future.value([]));

      final res = await repoImpl.getUsers();

      expect(res, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return [ServerFailure] when unsuccessful', () async {
      when(() => remoteDataSource.getUsers()).thenThrow(
          const ServerException(message: 'Server Error', statusCode: 500));

      final res = await repoImpl.getUsers();

      expect(
          res,
          equals(const Left(
              ServerFailure(message: 'Server Error', statusCode: 500))));
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
