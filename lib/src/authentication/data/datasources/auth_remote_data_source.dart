import 'dart:convert';

import 'package:http/http.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/utils/constants.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const userEndpoint = '/users';

class AuthRemoteDataSrcImplementation
    implements AuthenticationRemoteDataSource {
  AuthRemoteDataSrcImplementation(this.client);

  final Client client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      final res = await client.post(
        Uri.parse('$baseUrl$userEndpoint'),
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          'avatar': avatar,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw ServerException(message: res.body, statusCode: res.statusCode);
      }
    } on ServerException catch (e) {
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final res = await client.get(Uri.parse('$baseUrl$userEndpoint'));

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw ServerException(message: res.body, statusCode: res.statusCode);
      }

      final List<dynamic> users = jsonDecode(res.body) as List<dynamic>;
      return users.map((e) => UserModel.fromMap(e as DataMap)).toList();
    } on ServerException catch (e) {
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }
}
