class User {
  final int id;
  final String username;
  final double balance;
  final int vipLevel;
  String status;

  // TODO: 演示 2.1 - 后端加了 vipLevel 后，让 AI 同步更新这里的字段和 fromJson 方法

  User({
    required this.id,
    required this.username,
    required this.balance,
    this.vipLevel = 0,
    this.status = "ACTIVE",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // 安全处理null值，确保所有必需字段都存在
    if (json['id'] == null ||
        json['username'] == null ||
        json['balance'] == null) {
      throw FormatException('Invalid user data: missing required fields', json);
    }

    return User(
      id: json['id'] is int ? json['id'] : (json['id'] as num).toInt(),
      username: json['username'] as String,
      balance: json['balance'] is double
          ? json['balance'] as double
          : (json['balance'] as num).toDouble(),
      vipLevel: json['vipLevel'] != null
          ? (json['vipLevel'] is int
              ? json['vipLevel']
              : (json['vipLevel'] as num).toInt())
          : 0,
      status: json['status'] as String? ?? "ACTIVE",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'balance': balance,
      'vipLevel': vipLevel,
      'status': status,
    };
  }
}
