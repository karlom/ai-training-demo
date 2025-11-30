# AI Training Demo - Fintech Application

一个用于 AI 训练演示的金融科技应用，采用前后端分离架构，包含 Spring Boot 后端和 Flutter 移动端前端。

## 📋 项目概述

本项目是一个金融科技（Fintech）演示应用，主要用于展示 AI 辅助开发的工作流程。项目包含用户管理、余额查询、收益计算等核心功能，并预留了多个 TODO 任务供 AI 自动完成，展示了 AI 在代码生成、重构和功能扩展方面的能力。

## 🏗️ 项目结构

```
ai-training-demo/
├── fintech-backend-demo/          # Spring Boot 后端项目
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/demo/fintech/
│   │   │   │   ├── controller/   # REST API 控制器
│   │   │   │   ├── entity/        # 实体类
│   │   │   │   ├── repository/   # 数据访问层
│   │   │   │   ├── service/       # 业务逻辑层
│   │   │   │   └── FintechApplication.java
│   │   │   └── resources/
│   │   │       └── application.properties
│   │   └── test/
│   └── pom.xml                    # Maven 依赖配置
│
└── fintech-flutter-demo/          # Flutter 前端项目
    ├── lib/
    │   ├── main.dart              # 应用入口
    │   ├── models/                # 数据模型
    │   │   └── user_model.dart
    │   └── screens/               # 页面组件
    │       └── user_profile_page.dart
    └── pubspec.yaml               # Flutter 依赖配置
```

## 🛠️ 技术栈

### 后端技术栈
- **框架**: Spring Boot 2.7.5
- **语言**: Java 11
- **数据访问**: Spring Data JPA
- **数据库**: H2 Database (内存数据库)
- **构建工具**: Maven
- **工具库**: Lombok

### 前端技术栈
- **框架**: Flutter
- **语言**: Dart (SDK >= 2.17.0)
- **UI**: Material Design

## 🚀 快速开始

### 前置要求

- **后端**:
  - JDK 11 或更高版本
  - Maven 3.6+

- **前端**:
  - Flutter SDK 2.17.0 或更高版本
  - Dart SDK

### 后端启动步骤

1. 进入后端项目目录：
```bash
cd fintech-backend-demo
```

2. 使用 Maven 构建项目：
```bash
mvn clean install
```

3. 运行应用：
```bash
mvn spring-boot:run
```

4. 应用将在 `http://localhost:8080` 启动

5. 访问 H2 控制台（可选）：
   - URL: `http://localhost:8080/h2-console`
   - JDBC URL: `jdbc:h2:mem:testdb`
   - 用户名: `sa`
   - 密码: (留空)

### 前端启动步骤

1. 进入前端项目目录：
```bash
cd fintech-flutter-demo
```

2. 安装依赖：
```bash
flutter pub get
```

3. 运行应用：
```bash
flutter run
```

## 📡 API 接口

### 用户管理接口

#### 获取所有用户
```
GET /api/users
```

**响应示例**:
```json
[
  {
    "id": 1,
    "username": "JavaMaster",
    "balance": 8888.88
  }
]
```

#### 创建用户
```
POST /api/users
Content-Type: application/json
```

**请求体示例**:
```json
{
  "username": "NewUser",
  "balance": 10000.00
}
```

**响应示例**:
```json
{
  "id": 2,
  "username": "NewUser",
  "balance": 10000.00
}
```

## 📦 核心功能模块

### 1. 用户实体 (User Entity)
- **字段**:
  - `id`: 用户唯一标识
  - `username`: 用户名
  - `balance`: 账户余额

### 2. 用户服务 (UserService)
- `findAll()`: 查询所有用户
- `createUser(User user)`: 创建新用户

### 3. 收益计算器 (RewardCalculator)
- `calculateCompoundInterest()`: 计算阶梯式复利收益
  - 本金 < 10,000，年化 3%
  - 10,000 <= 本金 < 50,000，年化 4%
  - 本金 >= 50,000，年化 5%
  - VIP 用户额外加 1%
  - 按天计算复利

### 4. Flutter 用户界面
- **UserProfilePage**: 显示用户资料页面
  - 用户名显示
  - 余额显示

## 🎯 AI 训练演示任务

本项目包含多个 TODO 任务，用于演示 AI 辅助开发的能力：

### 后端任务
1. **演示 2.1**: 在 User 实体中添加 `vipLevel` 字段
2. **演示 2.2**: 
   - 在 User 实体中添加 `status` 字段（ACTIVE/FROZEN）
   - 实现 `freezeUser()` 方法
   - 生成 `/api/users/{id}/freeze` 接口
3. **演示 2.3**: 实现 `RewardCalculator.calculateCompoundInterest()` 完整算法

### 前端任务
1. **演示 2.1**: 
   - 同步更新 User 模型的 `vipLevel` 字段
   - 更新 `fromJson` 方法
   - 在用户资料页面添加 VIP 图标显示

## 🔧 配置说明

### 后端配置 (application.properties)
```properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.h2.console.enabled=true
server.port=8080
```

### 前端配置
- Flutter SDK 版本要求: >= 2.17.0 < 3.0.0
- Material Design 支持已启用

## 📝 开发说明

### 代码规范
- 后端使用 Lombok 简化代码
- 遵循 Spring Boot 最佳实践
- 使用 JPA 进行数据持久化
- Flutter 代码遵循 Dart 风格指南

### 数据库
- 使用 H2 内存数据库，数据在应用重启后会丢失
- 适合开发和演示使用
- 生产环境建议替换为 MySQL、PostgreSQL 等持久化数据库

## 🤝 贡献指南

本项目主要用于 AI 训练演示，欢迎提出改进建议和问题反馈。

## 📄 许可证

本项目仅用于演示和学习目的。

## 🔗 相关链接

- [Spring Boot 官方文档](https://spring.io/projects/spring-boot)
- [Flutter 官方文档](https://flutter.dev/docs)
- [H2 Database 文档](https://www.h2database.com/html/main.html)

---

**注意**: 本项目是一个演示项目，不应用于生产环境。数据库使用内存存储，应用重启后数据会丢失。

