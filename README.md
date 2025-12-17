# SSM论坛项目

基于Spring + SpringMVC + MyBatis框架开发的论坛系统

## 项目功能

### 用户管理
- 用户注册、登录
- 个人资料管理
- 普通用户和超级用户权限区分
- 超级用户可管理普通用户（启用/禁用）

### 论坛功能
- 版块管理
- 发帖、编辑帖子和删除帖子
- 回复帖子
- 帖子置顶和精华标记
- 帖子搜索功能
- 查看我的帖子和我的回复

## 技术栈
- **后端框架**: Spring 4.3.30, SpringMVC, MyBatis 3.5.13
- **数据库**: MySQL 8.0
- **连接池**: Druid
- **前端技术**: JSP, JSTL, JavaScript
- **分页插件**: PageHelper
- **构建工具**: Maven

## 项目结构

```
forum
├── src/main/java/com/forum
│   ├── controller     // 控制器层
│   ├── entity         // 实体类
│   ├── interceptor    // 拦截器
│   ├── mapper         // 数据访问层接口
│   └── service        // 业务逻辑层
├── src/main/resources
│   ├── mapper         // MyBatis映射文件
│   ├── spring         // Spring配置文件
│   └── jdbc.properties // 数据库配置
├── src/main/webapp
│   └── WEB-INF
│       └── views      // JSP页面
└── database
    └── forum.sql      // 数据库初始化脚本
```

## 数据库表结构

1. **user** - 用户表
   - id, username, password, email, nickname
   - role (0-普通用户，1-超级用户)
   - status (0-禁用，1-正常)

2. **section** - 版块表
   - id, name, description, post_count

3. **post** - 帖子表
   - id, title, content, user_id, section_id
   - view_count, reply_count
   - is_top (置顶), is_essence (精华)

4. **reply** - 回复表
   - id, content, post_id, user_id, floor
   - reply_user_id (回复的目标用户ID)

## 部署步骤

1. **环境要求**
   - JDK 1.8+
   - MySQL 8.0+
   - Tomcat 8.5+
   - Maven 3.6+

2. **数据库配置**
   ```sql
   -- 创建数据库并导入数据
   mysql -u root -p < database/forum.sql
   ```

3. **修改数据库连接**
   - 编辑 `src/main/resources/jdbc.properties`
   - 修改数据库连接信息（用户名、密码等）

4. **编译打包**
   ```bash
   mvn clean package
   ```

5. **部署到Tomcat**
   - 将生成的 `forum.war` 复制到Tomcat的webapps目录
   - 启动Tomcat

6. **访问系统**
   - 浏览器访问: http://localhost:8080/forum/

## 默认账号

- **超级用户**: admin / admin123
  - 用户名: admin
  - 密码: admin123

## 注意事项

1. 数据库配置文件中的密码需要根据实际环境修改
2. 项目默认使用UTF-8编码，确保MySQL数据库也使用UTF-8字符集
3. Tomcat版本建议使用8.5或更高版本
4. 确保MySQL服务已启动并可正常连接

## 功能扩展建议

1. 添加文件上传功能（头像、附件）
2. 集成富文本编辑器
3. 添加邮件验证功能
4. 实现帖子审核功能
5. 添加积分等级系统
6. 实现消息通知功能
7. 添加站内搜索功能（使用Elasticsearch）
8. 实现缓存机制（Redis）