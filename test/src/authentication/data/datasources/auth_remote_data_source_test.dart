import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user.dart';

class MockClient extends Mock implements Client {}

void main() {
  late Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSrcImplementation(client);
    // registerFallbackValue(Uri.parse('$baseUrl$userEndpoint'));
  });

  group('createUser', () {
    test('should successfully with status code 200 or 201', () async {
      when(
        () => client.post(
          Uri.parse('$baseUrl$userEndpoint'),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => Response('User create successfully', 201));

      final methodCall = remoteDataSource.createUser;

      expect(
          methodCall(
            createdAt: '2021-09-09',
            name: 'Test',
            avatar: 'https://test.com',
          ),
          completes);

      verify(
        () => client.post(
          Uri.parse('$baseUrl$userEndpoint'),
          body: jsonEncode({
            'createdAt': '2021-09-09',
            'name': 'Test',
            'avatar': 'https://test.com',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw ServerException when status code is not 200 or 201',
        () async {
      when(
        () => client.post(
          Uri.parse('$baseUrl$userEndpoint'),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => Response('Invalid email address', 404));

      final methodCall = remoteDataSource.createUser;

      expect(
        methodCall(
          createdAt: '2021-09-09',
          name: 'Test',
          avatar: 'https://test.com',
        ),
        throwsA(isA<ServerException>()),
      );

      verify(
        () => client.post(
          Uri.parse('$baseUrl$userEndpoint'),
          body: jsonEncode({
            'createdAt': '2021-09-09',
            'name': 'Test',
            'avatar': 'https://test.com',
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test('should return [List<User>] when status code is 200', () async {
      when(
        () => client.get(
          Uri.parse('$baseUrl$userEndpoint'),
        ),
      ).thenAnswer(
          (_) async => Response(jsonEncode([tUsers.first.toMap()]), 200));

      final res = await remoteDataSource.getUsers();

      expect(res, equals(tUsers));

      verify(
        () => client.get(
          Uri.parse('$baseUrl$userEndpoint'),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw ServerException when status code is not 200', () async {
      when(
        () => client.get(
          Uri.parse('$baseUrl$userEndpoint'),
        ),
      ).thenAnswer((_) async => Response('Invalid email address', 404));

      final methodCall = remoteDataSource.getUsers;

      expect(
        methodCall(),
        throwsA(isA<ServerException>()),
      );

      verify(
        () => client.get(
          Uri.parse('$baseUrl$userEndpoint'),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
