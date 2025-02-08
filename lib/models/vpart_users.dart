enum AccountType { fan, famoso }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final AccountType accountType;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.accountType,
  });

  // Convierte un Map en una instancia de UserModel.
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] as String,
      email: data['email'] as String,
      accountType: data['accountType'] == 'famoso'
          ? AccountType.famoso
          : AccountType.fan,
    );
  }

  // Convierte la instancia de UserModel en un Map.
  Map<String, dynamic> toMap() {
    return {
      'name' : name ,
      'email': email,
      'accountType': accountType == AccountType.famoso ? 'famoso' : 'fan',
    };
  }
}
