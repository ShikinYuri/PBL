<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "编辑帖子");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 800px; margin-top: 30px;">
    <div style="background-color: #fff; padding: 30px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h2 style="margin-bottom: 30px;">编辑帖子</h2>

        <form id="editForm">
            <input type="hidden" id="postId" name="id" value="${post.id}" />

            <div class="form-group">
                <label for="title">标题</label>
                <input type="text" class="form-control" id="title" name="title" required placeholder="请输入帖子标题" value="${post.title}">
            </div>

            <div class="form-group">
                <label for="section">版块</label>
                <select class="form-control" id="section" disabled>
                    <c:forEach items="${sections}" var="section">
                        <option value="${section.id}" <c:if test="${section.id == post.sectionId}">selected</c:if>>${section.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="content">内容</label>
                <textarea class="form-control" id="content" name="content" rows="15" required placeholder="请输入帖子内容">${post.content}</textarea>
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn btn-primary" style="padding: 10px 40px;">保存修改</button>
                <a href="${pageContext.request.contextPath}/post/list" class="btn btn-secondary" style="padding: 10px 40px; margin-left: 20px;">返回</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    document.getElementById('editForm').onsubmit = function(e) {
        e.preventDefault();

        var id = document.getElementById('postId').value;
        var title = document.getElementById('title').value;
        var content = document.getElementById('content').value;

        if (!title.trim()) {
            showMessage('请输入帖子标题', 'error');
            return;
        }

        if (!content.trim()) {
            showMessage('请输入帖子内容', 'error');
            return;
        }

        var _ctx = '${pageContext.request.contextPath}';
        ajaxRequest(_ctx + '/post/edit', 'POST', {
            id: id,
            title: title,
            content: content
        }, function(response) {
            if (response.success) {
                showMessage(response.message, 'success');
                setTimeout(function() {
                    window.location.href = _ctx + '/reply/list/' + id;
                }, 1200);
            } else {
                showMessage(response.message, 'error');
            }
        });
    };
</script>
