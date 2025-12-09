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
          User(id: 0, username: "JavaMaster", balance: 8888.88, vipLevel: 2),
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

  Future<void> _freezeUser() async {
    if (user == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      final updatedUser = await UserService.freezeUser(user!.id);

      setState(() {
        user = updatedUser;
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User account has been frozen successfully'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to freeze user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _unfreezeUser() async {
    if (user == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      final updatedUser = await UserService.unfreezeUser(user!.id);

      setState(() {
        user = updatedUser;
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User account has been unfrozen successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unfreeze user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: user!.status == "FROZEN" ? Colors.red[50] : null,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (user!.status == "FROZEN") ...[
                      const Text(
                        '🚫 ',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                    Text(
                      "Username: ${user!.username}",
                      style: const TextStyle(fontSize: 24),
                    ),
                    if (user!.vipLevel > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'VIP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: user!.status == "FROZEN" ? _unfreezeUser : _freezeUser,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  user!.status == "FROZEN" ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              user!.status == "FROZEN" ? 'Unfreeze Account' : 'Freeze Account',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // TODO: 演示 2.1 - 让 AI 在这里自动根据 vipLevel 添加一个金色的 VIP 图标
      ],
    );
  }
}
