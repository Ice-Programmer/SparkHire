# SparkHire 简易项目说明

> 高效智能的求职平台后端服务，采用 Spring Boot 单体架构，内置 RBAC 鉴权、AI 简历优化、职位搜索与实时聊天等核心功能。

---

## ⚙️ 环境依赖

* JDK 21+
* Maven
* MySQL 5.7+ 或兼容数据库
* Redis（用于缓存权限与会话）

## 🚀 快速启动

1. 克隆代码仓库并进入目录：

   ```bash
   git clone https://github.com/Ice-Programmer/SparkHire.git
   cd SparkHire
   ```
2. 修改 `src/main/resources/application.yml` 中的数据库、Redis 等配置。
3. 使用 Maven 构建并启动服务：

   ```bash
   mvn clean package
   java -jar target/ice-sparkhire-backend-0.1.0.jar
   ```

4. 访问接口文档：
   `http://localhost:8000/doc.html`

## 💡 核心功能

* **账户系统**：注册/登录/角色&权限管理（RBAC）
* **企业与职位**：企业认证、职位发布与搜索
* **简历管理**：多版本管理、PDF 导出
* **AI 优化**：一键智能优化与改写建议
* **智能推荐**：基于技能与意向的个性化推荐
* **职位申请**：一键投递、投递状态跟踪
* **实时聊天**：求职者与 HR 即时通讯
* **社区与通知**：求职社区互动、系统通知推送

## 🔐 权限体系

* 采用 `role`, `permission`, `user_role`, `role_permission` 四表设计
* 支持基于接口与菜单的精细化控制
* 可配置化动态更新角色权限

## 📄 脚本与配置

* `init` 文件下含所有建表与初始数据（角色、权限、关联脚本）
* `application.yml` 支持多环境切换（dev/prod）

## 🤝 贡献指南

欢迎提交 PR、提 Issue，或加入讨论。请遵循 `git flow` 工作流，分支命名请遵循 `feature/xxx`、`bugfix/xxx`。

## 📄 License

此项目采用 MIT 协议，详情见 [LICENSE](LICENSE)。
