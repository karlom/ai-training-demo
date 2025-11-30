import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // 先尝试获取第一个用户，如果没有则创建一个测试用户
      final users = await UserService.getUsers();
      if (users.isNotEmpty) {
        setState(() {
          user = users.first;
          isLoading = false;
        });
      } else {
        // 如果没有用户，创建一个测试用户
        final newUser = await UserService.createUser(
          User(id: 0, username: "JavaMaster", balance: 8888.88),
        );
        setState(() {
          user = newUser;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUser,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (user == null) {
      return const Center(child: Text('No user data available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Username: ${user!.username}",
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        Text(
          "Balance: \$${user!.balance}",
          style: const TextStyle(fontSize: 20, color: Colors.green),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loadUser,
          child: const Text('Refresh Data'),
        ),
        // TODO: 演示 2.1 - 让 AI 在这里自动根据 vipLevel 添加一个金色的 VIP 图标
      ],
    );
  }
}
