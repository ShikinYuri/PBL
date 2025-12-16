<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SSM论坛 - ${pageTitle}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }
        .header {
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }
        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            text-decoration: none;
        }
        .nav {
            display: flex;
            gap: 20px;
        }
        .nav a {
            color: #666;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 3px;
            transition: all 0.3s;
        }
        .nav a:hover {
            background-color: #f0f0f0;
            color: #333;
        }
        .nav a.active {
            background-color: #007bff;
            color: white;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .user-info span {
            color: #666;
        }
        .btn {
            padding: 5px 15px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-control:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }
        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        .alert-error {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        .pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 20px;
        }
        .pagination a {
            padding: 5px 10px;
            border: 1px solid #ddd;
            color: #666;
            text-decoration: none;
        }
        .pagination a:hover {
            background-color: #f0f0f0;
        }
        .pagination .active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <div class="header-content">
                <a href="${pageContext.request.contextPath}/" class="logo">SSM论坛</a>
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/" class="${pageTitle eq '首页' ? 'active' : ''}">首页</a>
                    <a href="${pageContext.request.contextPath}/post/list" class="${pageTitle eq '所有帖子' ? 'active' : ''}">所有帖子</a>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/post/create">发帖</a>
                        <a href="${pageContext.request.contextPath}/post/my">我的帖子</a>
                        <a href="${pageContext.request.contextPath}/reply/my">我的回复</a>
                        <c:if test="${sessionScope.user.role eq 1}">
                            <a href="${pageContext.request.contextPath}/user/manage" style="color: #dc3545;">用户管理</a>
                        </c:if>
                    </c:if>
                </nav>
                <div class="user-info">
                    <c:choose>
                        <c:when test="${empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/user/login" class="btn btn-primary">登录</a>
                            <a href="${pageContext.request.contextPath}/user/register" class="btn btn-secondary">注册</a>
                        </c:when>
                        <c:otherwise>
                            <span>欢迎, ${sessionScope.user.nickname ne null ? sessionScope.user.nickname : sessionScope.user.username}</span>
                            <c:if test="${sessionScope.user.role eq 1}">
                                <span style="color: #dc3545; font-weight: bold;">[管理员]</span>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary">个人中心</a>
                            <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-danger">退出</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>