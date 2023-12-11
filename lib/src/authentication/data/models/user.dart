import 'dart:convert';

import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.avatar,
    required super.createdAt,
    required super.id,
    required super.name,
  });

  const UserModel.empty()
      : this(
          id: '1',
          createdAt: '',
          name: '_empty.name',
          avatar: '',
        );

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          avatar: map['avatar'] as String,
          createdAt: map['createdAt'] as String,
          name: map['name'] as String,
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel copyWith({
    String? id,
    String? avatar,
    String? createdAt,
    String? name,
  }) {
    return UserModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
    );
  }

  DataMap toMap() => {
        'id': id,
        'avatar': avatar,
        'createdAt': createdAt,
        'name': name,
      };

  String toJson() => jsonEncode(toMap());
}
