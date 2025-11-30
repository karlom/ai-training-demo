class User {
  final int id;
  final String username;
  final double balance;

  // TODO: 演示 2.1 - 后端加了 vipLevel 后，让 AI 同步更新这里的字段和 fromJson 方法

  User({required this.id, required this.username, required this.balance});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      balance: json['balance'].toDouble(),
    );
  }
}
