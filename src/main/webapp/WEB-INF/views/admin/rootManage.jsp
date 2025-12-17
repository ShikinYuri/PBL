<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle", "Root 管理");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 1200px; margin-top: 30px;">
    <div style="background-color: #fff; padding: 30px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h2 style="margin-bottom: 20px;">Root 权限管理</h2>

        <div style="margin-bottom: 20px; display:flex; gap:10px; align-items:center;">
            <input id="addUsername" type="text" class="form-control" placeholder="用户名（username）">
            <input id="addUserId" type="number" class="form-control" placeholder="或输入 UserId">
            <button onclick="addRoot()" class="btn btn-primary">添加/激活</button>
        </div>

        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                    <th style="padding: 12px; text-align: left;">UserId</th>
                    <th style="padding: 12px; text-align: left;">用户名</th>
                    <th style="padding: 12px; text-align: left;">昵称</th>
                    <th style="padding: 12px; text-align: left;">生效</th>
                    <th style="padding: 12px; text-align: left;">添加时间</th>
                    <th style="padding: 12px; text-align: center;">操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${roots}" var="item">
                    <c:set var="r" value="${item.root}"/>
                    <c:set var="u" value="${item.user}"/>
                    <tr style="border-bottom: 1px solid #dee2e6;">
                        <td style="padding: 12px;">${r.userId}</td>
                        <td style="padding: 12px;">${u.username}</td>
                        <td style="padding: 12px;">${u.nickname ne null ? u.nickname : '-'}</td>
                        <td style="padding: 12px;">
                            <c:choose>
                                <c:when test="${r.active eq 1}">
                                    <span style="color: #28a745; font-weight: bold;">生效</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #dc3545; font-weight: bold;">失效</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 12px;">
                            <fmt:formatDate value="${r.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>
                        <td style="padding: 12px; text-align: center;">
                            <c:choose>
                                <c:when test="${r.active eq 1}">
                                    <button onclick="toggleRoot(${r.userId}, 0)" class="btn btn-secondary">停用</button>
                                </c:when>
                                <c:otherwise>
                                    <button onclick="toggleRoot(${r.userId}, 1)" class="btn btn-primary">启用</button>
                                </c:otherwise>
                            </c:choose>
                            <button onclick="deleteRoot(${r.userId})" class="btn btn-danger" style="margin-left:8px;">删除</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="pagination" style="margin-top: 20px;">
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/user/rootManage?page=${currentPage - 1}">上一页</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i eq currentPage}">
                        <a href="#" class="active">${i}</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/user/rootManage?page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/user/rootManage?page=${currentPage + 1}">下一页</a>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    var _ctx = '${pageContext.request.contextPath}';

    function addRoot() {
        var username = document.getElementById('addUsername').value;
        var userId = document.getElementById('addUserId').value;
        if (!username && !userId) {
            showMessage('请输入用户名或用户ID', 'error');
            return;
        }
        ajaxRequest(_ctx + '/user/root/add', 'POST', { username: username, userId: userId }, function(res) {
            if (res.success) {
                showMessage(res.message, 'success');
                setTimeout(function(){ location.reload(); }, 800);
            } else {
                showMessage(res.message, 'error');
            }
        });
    }

    function toggleRoot(userId, active) {
        ajaxRequest(_ctx + '/user/root/toggle', 'POST', { userId: userId, active: active }, function(res) {
            if (res.success) {
                showMessage(res.message, 'success');
                setTimeout(function(){ location.reload(); }, 800);
            } else {
                showMessage(res.message, 'error');
            }
        });
    }

    function deleteRoot(userId) {
        if (!confirm('确定要删除此 root 记录吗？')) return;
        ajaxRequest(_ctx + '/user/root/delete', 'POST', { userId: userId }, function(res) {
            if (res.success) {
                showMessage(res.message, 'success');
                setTimeout(function(){ location.reload(); }, 800);
            } else {
                showMessage(res.message, 'error');
            }
        });
    }
</script>
