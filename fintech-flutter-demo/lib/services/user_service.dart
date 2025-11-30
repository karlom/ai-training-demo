import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = 'http://localhost:8080/api/users';

  // 获取所有用户
  static Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        // 过滤掉空对象和无效数据
        final List<User> users = [];
        for (var jsonItem in jsonList) {
          if (jsonItem is Map<String, dynamic> && 
              jsonItem['id'] != null && 
              jsonItem['username'] != null && 
              jsonItem['balance'] != null) {
            try {
              users.add(User.fromJson(jsonItem));
            } catch (e) {
              // 跳过无效的用户数据
              print('Skipping invalid user data: $jsonItem, error: $e');
            }
          }
        }
        return users;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // 获取单个用户（通过ID）
  static Future<User?> getUserById(int id) async {
    try {
      final users = await getUsers();
      return users.firstWhere(
        (user) => user.id == id,
        orElse: () => throw Exception('User not found'),
      );
    } catch (e) {
      return null;
    }
  }

  // 创建用户
  static Future<User> createUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': user.username,
          'balance': user.balance,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }
}

