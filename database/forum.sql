CREATE DATABASE IF NOT EXISTS forum DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE forum;

-- 用户表
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `nickname` varchar(50) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `role` tinyint(4) NOT NULL DEFAULT '0' COMMENT '角色：0-普通用户，1-超级用户',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-正常',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 版块表
CREATE TABLE `section` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '版块ID',
  `name` varchar(50) NOT NULL COMMENT '版块名称',
  `description` varchar(200) DEFAULT NULL COMMENT '版块描述',
  `post_count` int(11) NOT NULL DEFAULT '0' COMMENT '帖子数量',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-正常',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='版块表';

-- 帖子表
CREATE TABLE `post` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `content` text NOT NULL COMMENT '内容',
  `user_id` bigint(20) NOT NULL COMMENT '发帖人ID',
  `section_id` bigint(20) NOT NULL COMMENT '版块ID',
  `view_count` int(11) NOT NULL DEFAULT '0' COMMENT '浏览次数',
  `reply_count` int(11) NOT NULL DEFAULT '0' COMMENT '回复数量',
  `last_reply_time` datetime DEFAULT NULL COMMENT '最后回复时间',
  `last_reply_user_id` bigint(20) DEFAULT NULL COMMENT '最后回复人ID',
  `is_top` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否置顶：0-否，1-是',
  `is_essence` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否精华：0-否，1-是',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0-删除，1-正常',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_section_id` (`section_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='帖子表';

-- 回复表
CREATE TABLE `reply` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '回复ID',
  `content` text NOT NULL COMMENT '回复内容',
  `post_id` bigint(20) NOT NULL COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '回复人ID',
  `floor` int(11) NOT NULL COMMENT '楼层',
  `reply_user_id` bigint(20) DEFAULT NULL COMMENT '回复的目标用户ID（用于回复某人的回复）',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态：0-删除，1-正常',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_post_id` (`post_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回复表';

-- 初始化超级用户数据
INSERT INTO `user` (`username`, `password`, `email`, `nickname`, `role`) VALUES
('admin', '$2a$10$ekUb0QJ4/Q5dCQAj8Li9beUG8YjPjwz2WzT1jEdlO5pJ8j9O2O9G2', 'admin@forum.com', '超级管理员', 1);

-- 初始化版块数据
INSERT INTO `section` (`name`, `description`, `sort`) VALUES
('技术讨论', '分享技术心得，讨论技术问题', 1),
('生活随笔', '记录生活点滴，分享个人感悟', 2),
('问答求助', '遇到问题？来这里寻求帮助', 3),
('闲聊灌水', '轻松愉快，畅所欲言', 4);

-- 超级权限控制表：root 表用于额外指定某些用户为 root（超级管理员），
-- 当 root 表中存在且 active=1 时，系统会将该用户视为 role=1。
CREATE TABLE `root` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID，关联 user.id',
  `active` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否生效：0-无效，1-生效',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='root 权限表（指定哪些用户具有超级权限）';

-- 将已插入的 admin 用户同步到 root 表（如果存在且尚未加入）
INSERT INTO `root` (`user_id`, `active`)
SELECT id, 1 FROM `user` WHERE username = 'admin' AND NOT EXISTS (SELECT 1 FROM `root` r WHERE r.user_id = (SELECT id FROM `user` WHERE username = 'admin'));