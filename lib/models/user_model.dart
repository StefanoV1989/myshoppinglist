class UserModel {
  final String? uuid;
  final String? email;
  final String? name;
  final String? surname;
  final String? avatar;

  UserModel({required this.uuid, this.name, this.surname, required this.email, this.avatar});

  UserModel copyWith({String? uuid, String? email, String? name, String? surname, String? avatar}) {
    return UserModel(
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      avatar: avatar ?? this.avatar,
    );
  }
}