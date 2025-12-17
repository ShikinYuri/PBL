<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle", "用户管理");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 1200px; margin-top: 30px;">
    <div style="background-color: #fff; padding: 30px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h2 style="margin-bottom: 30px;">用户管理</h2>

        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                    <th style="padding: 12px; text-align: left;">ID</th>
                    <th style="padding: 12px; text-align: left;">用户名</th>
                    <th style="padding: 12px; text-align: left;">昵称</th>
                    <th style="padding: 12px; text-align: left;">邮箱</th>
                    <th style="padding: 12px; text-align: left;">角色</th>
                    <th style="padding: 12px; text-align: left;">状态</th>
                    <th style="padding: 12px; text-align: left;">注册时间</th>
                    <th style="padding: 12px; text-align: center;">操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${users}" var="user">
                    <tr style="border-bottom: 1px solid #dee2e6;">
                        <td style="padding: 12px;">${user.id}</td>
                        <td style="padding: 12px;">${user.username}</td>
                        <td style="padding: 12px;">${user.nickname ne null ? user.nickname : '-'}</td>
                        <td style="padding: 12px;">${user.email ne null ? user.email : '-'}</td>
                        <td style="padding: 12px;">
                            <c:choose>
                                <c:when test="${user.role eq 1}">
                                    <span style="color: #dc3545; font-weight: bold;">超级用户</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #666;">普通用户</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 12px;">
                            <c:choose>
                                <c:when test="${user.status eq 1}">
                                    <span style="color: #28a745; font-weight: bold;">正常</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #dc3545; font-weight: bold;">禁用</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 12px;">
                            <fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/>
                        </td>
                        <td style="padding: 12px; text-align: center;">
                            <c:choose>
                                <c:when test="${user.role eq 1}">
                                    <button onclick="setRole(${user.id}, 0)" class="btn btn-secondary" style="padding: 5px 15px;">取消超级管理员</button>
                                </c:when>
                                <c:otherwise>
                                    <button onclick="setRole(${user.id}, 1)" class="btn btn-warning" style="padding: 5px 15px;">设为超级管理员</button>
                                </c:otherwise>
                            </c:choose>
                            <span style="display:inline-block; width:8px;"></span>
                            <c:choose>
                                <c:when test="${user.status eq 1}">
                                    <button onclick="updateUserStatus(${user.id}, 0)" class="btn btn-danger" style="padding: 5px 15px;">禁用</button>
                                </c:when>
                                <c:otherwise>
                                    <button onclick="updateUserStatus(${user.id}, 1)" class="btn btn-primary" style="padding: 5px 15px;">启用</button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- 分页 -->
        <div class="pagination" style="margin-top: 30px;">
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/user/manage?page=${currentPage - 1}">上一页</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i eq currentPage}">
                        <a href="#" class="active">${i}</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/user/manage?page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/user/manage?page=${currentPage + 1}">下一页</a>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    function updateUserStatus(userId, status) {
        var action = status == 1 ? '启用' : '禁用';
        if (confirm('确定要' + action + '这个用户吗？')) {
            var _ctx = '${pageContext.request.contextPath}';
            ajaxRequest(_ctx + '/user/updateStatus', 'POST', {
                userId: userId,
                status: status
            }, function(response) {
                if (response.success) {
                    showMessage(response.message, 'success');
                    setTimeout(function() {
                        location.reload();
                    }, 1000);
                } else {
                    showMessage(response.message, 'error');
                }
            });
        }
    }

    function setRole(userId, role) {
        var action = role == 1 ? '设为超级管理员' : '取消超级管理员';
        if (!confirm('确定要' + action + '吗？')) return;
        var _ctx = '${pageContext.request.contextPath}';
        ajaxRequest(_ctx + '/user/setRole', 'POST', { userId: userId, role: role }, function(response) {
            if (response.success) {
                showMessage(response.message, 'success');
                setTimeout(function() { location.reload(); }, 800);
            } else {
                showMessage(response.message, 'error');
            }
        });
    }
</script>