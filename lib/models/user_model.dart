class UserModel {
  const UserModel({
    required this.fullName,
    required this.studentId,
    required this.universityEmail,
    required this.password,
  });

  final String fullName;
  final String studentId;
  final String universityEmail;
  final String password;

  UserModel copyWith({String? password}) => UserModel(
        fullName: fullName,
        studentId: studentId,
        universityEmail: universityEmail,
        password: password ?? this.password,
      );
}
