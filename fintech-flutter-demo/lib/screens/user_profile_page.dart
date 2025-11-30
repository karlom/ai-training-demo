import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProfilePage extends StatelessWidget {
  // 模拟数据
  final User user = User(id: 1, username: "JavaMaster", balance: 8888.88);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Username: ${user.username}", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("Balance: \$${user.balance}", style: TextStyle(fontSize: 20, color: Colors.green)),
            
            // TODO: 演示 2.1 - 让 AI 在这里自动根据 vipLevel 添加一个金色的 VIP 图标
          ],
        ),
      ),
    );
  }
}
