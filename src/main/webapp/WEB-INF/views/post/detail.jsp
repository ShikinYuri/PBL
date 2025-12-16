<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle", "帖子详情");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 1000px;">
    <!-- 帖子内容 -->
    <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
        <div style="border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px;">
            <h1 style="margin-bottom: 10px;">
                ${post.title}
                <c:if test="${post.isTop eq 1}">
                    <span style="color: #dc3545; font-size: 16px; font-weight: bold;">[置顶]</span>
                </c:if>
                <c:if test="${post.isEssence eq 1}">
                    <span style="color: #ffc107; font-size: 16px; font-weight: bold;">[精华]</span>
                </c:if>
            </h1>
            <div style="color: #666; font-size: 14px;">
                作者: ${post.nickname ne null ? post.nickname : post.username} |
                版块: ${post.sectionName} |
                浏览: ${post.viewCount} |
                回复: ${post.replyCount} |
                时间: <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                <c:if test="${post.lastReplyTime ne null}">
                    | 最后回复: <fmt:formatDate value="${post.lastReplyTime}" pattern="yyyy-MM-dd HH:mm"/>
                </c:if>
            </div>
        </div>

        <div style="line-height: 1.8; color: #333; white-space: pre-wrap;">${post.content}</div>

        <c:if test="${not empty sessionScope.user and (sessionScope.user.id eq post.userId or sessionScope.user.role eq 1)}">
            <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
                <a href="${pageContext.request.contextPath}/post/edit/${post.id}" class="btn btn-secondary">编辑</a>
                <button onclick="deletePost(${post.id})" class="btn btn-danger">删除</button>
            </div>
        </c:if>
    </div>

    <!-- 回复表单 -->
    <c:if test="${not empty sessionScope.user}">
        <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
            <h3 style="margin-bottom: 15px;">发表回复</h3>
            <form id="replyForm">
                <input type="hidden" name="postId" value="${post.id}">
                <div class="form-group">
                    <textarea class="form-control" name="content" rows="4" placeholder="请输入回复内容..." required></textarea>
                </div>
                <button type="button" id="replySubmit" class="btn btn-primary">发表回复</button>
            </form>
        </div>
    </c:if>

    <!-- 回复列表 -->
    <div style="background-color: #fff; padding: 20px; border-radius: 5px;">
        <h3 style="margin-bottom: 15px;">全部回复 (${post.replyCount})</h3>
        <div id="replyList">
            <!-- 回复将通过AJAX加载 -->
        </div>
        <div id="replyPagination" class="pagination">
            <!-- 分页将通过AJAX加载 -->
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    var postId = ${post.id};
    var currentPage = 1;

    var _ctx = '${pageContext.request.contextPath}';
    // 加载回复列表
    function loadReplies(page) {
        currentPage = page || 1;
        ajaxRequest(_ctx + '/reply/list/' + postId + '?page=' + currentPage, 'GET', {}, function(response) {
            // 这里假设返回HTML，实际应该返回JSON
            window.location.href = _ctx + '/reply/list/${post.id}?page=' + currentPage;
        });
    }

    // 提交回复（按钮型，避免表单默认提交）
    document.getElementById('replySubmit').onclick = function(e) {
        var content = document.querySelector('textarea[name="content"]').value;
        if (!content || !content.trim()) {
            showMessage('回复内容不能为空', 'error');
            return;
        }

        ajaxRequest(_ctx + '/reply/create', 'POST', {
            postId: postId,
            content: content
        }, function(response) {
            if (response.success) {
                showMessage(response.message, 'success');
                document.querySelector('textarea[name="content"]').value = '';
                // 刷新当前回复列表（可改为局部更新）
                setTimeout(function() {
                    window.location.reload();
                }, 800);
            } else {
                showMessage(response.message, 'error');
            }
        });
    };

    // 删除帖子
    function deletePost(id) {
        if (confirm('确定要删除这个帖子吗？')) {
            ajaxRequest(_ctx + '/post/delete', 'POST', {
                id: id
            }, function(response) {
                if (response.success) {
                    showMessage(response.message, 'success');
                    setTimeout(function() {
                        window.location.href = _ctx + '/post/list';
                    }, 1000);
                } else {
                    showMessage(response.message, 'error');
                }
            });
        }
    }

    // 页面加载时加载第一页回复
    loadReplies(1);
</script>