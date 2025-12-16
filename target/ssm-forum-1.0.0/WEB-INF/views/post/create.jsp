<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "发帖");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 800px; margin-top: 30px;">
    <div style="background-color: #fff; padding: 30px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h2 style="margin-bottom: 30px;">发表新帖</h2>

        <form id="postForm">
            <div class="form-group">
                <label for="title">标题</label>
                <input type="text" class="form-control" id="title" name="title" required placeholder="请输入帖子标题">
            </div>

            <div class="form-group">
                <label for="sectionId">版块</label>
                <select class="form-control" id="sectionId" name="sectionId" required>
                    <option value="">请选择版块</option>
                    <c:forEach items="${sections}" var="section">
                        <option value="${section.id}">${section.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="content">内容</label>
                <textarea class="form-control" id="content" name="content" rows="15" required placeholder="请输入帖子内容"></textarea>
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn btn-primary" style="padding: 10px 40px;">发表帖子</button>
                <a href="${pageContext.request.contextPath}/post/list" class="btn btn-secondary" style="padding: 10px 40px; margin-left: 20px;">返回</a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    document.getElementById('postForm').onsubmit = function(e) {
        e.preventDefault();

        var title = document.getElementById('title').value;
        var sectionId = document.getElementById('sectionId').value;
        var content = document.getElementById('content').value;

        if (!title.trim()) {
            showMessage('请输入帖子标题', 'error');
            return;
        }

        if (!sectionId) {
            showMessage('请选择版块', 'error');
            return;
        }

        if (!content.trim()) {
            showMessage('请输入帖子内容', 'error');
            return;
        }

        var _ctx = '${pageContext.request.contextPath}';
        ajaxRequest(_ctx + '/post/create', 'POST', {
            title: title,
            sectionId: sectionId,
            content: content
        }, function(response) {
            if (response.success) {
                showMessage(response.message, 'success');
                setTimeout(function() {
                    window.location.href = _ctx + '/post/detail/' + response.postId;
                }, 1500);
            } else {
                showMessage(response.message, 'error');
            }
        });
    };
</script>