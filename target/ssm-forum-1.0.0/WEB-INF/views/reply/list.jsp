<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 1000px;">
    <!-- 帖子信息 -->
            <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
                <h3 style="margin-bottom: 10px;">
                    <span style="color: #333; text-decoration: none;">${post.title}</span>
                </h3>
                <div style="margin-bottom:10px; color:#333; white-space:pre-wrap;">${post.content}</div>
                <div style="color: #666; font-size: 14px;">
                    作者: ${post.nickname ne null ? post.nickname : post.username} |
                    回复数: <span id="reply-count-${post.id}">${post.replyCount}</span>
                </div>
            </div>

    <!-- 回复列表 -->
    <c:if test="${not empty sessionScope.user}">
        <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
            <h3 style="margin-bottom: 15px;">发表评论</h3>
            <form id="replyForm">
                <input type="hidden" name="postId" value="${post.id}">
                <div class="form-group">
                    <textarea class="form-control" name="content" rows="4" placeholder="请输入回复内容..." required></textarea>
                </div>
                <div style="text-align: center; margin-top: 10px;">
                    <button type="button" id="replySubmit" class="btn btn-primary">发表回复</button>
                </div>
            </form>
        </div>
    </c:if>
    <div style="background-color: #fff; padding: 20px; border-radius: 5px;">
        <h3 style="margin-bottom: 20px;">全部回复</h3>

        <c:choose>
            <c:when test="${empty replies}">
                <div style="text-align: center; padding: 50px; color: #666;">
                    暂无回复
                </div>
            </c:when>
            <c:otherwise>
                <div>
                    <c:forEach items="${replies}" var="reply">
                        <div id="reply-${reply.id}" style="border-bottom: 1px solid #eee; padding: 15px 0;">
                            <div style="display: flex; align-items: flex-start; gap: 15px;">
                                <!-- 头像 -->
                                <div style="width: 50px; height: 50px; background-color: #f0f0f0; border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                    <span style="font-size: 24px; color: #999;">👤</span>
                                </div>

                                <!-- 回复内容 -->
                                <div style="flex: 1;">
                                    <div style="margin-bottom: 10px;">
                                        <strong>${reply.nickname ne null ? reply.nickname : reply.username}</strong>
                                        <span style="color: #999; margin-left: 10px;">${reply.floor}楼</span>
                                        <c:if test="${reply.replyUserId ne null and reply.replyNickname ne null}">
                                            <span style="color: #666; margin-left: 10px;">回复 ${reply.replyNickname}</span>
                                        </c:if>
                                        <span style="color: #999; float: right; font-size: 14px;">
                                            <fmt:formatDate value="${reply.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                        </span>
                                    </div>
                                    <div style="line-height: 1.8; color: #333; white-space: pre-wrap;">${reply.content}</div>
                                    <div style="margin-top:8px; text-align: right;">
                                        <c:if test="${not empty sessionScope.user and (sessionScope.user.id eq reply.userId or (sessionScope.user.role == 1 or sessionScope.user.role == '1'))}">
                                            <button type="button" onclick="deleteReply(${reply.id})" class="btn btn-danger" style="padding:4px 8px;">删除</button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 分页 -->
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/reply/list/${post.id}?page=${currentPage - 1}">上一页</a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i eq currentPage}">
                                <a href="#" class="active">${i}</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/reply/list/${post.id}?page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/reply/list/${post.id}?page=${currentPage + 1}">下一页</a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    var _ctx = '${pageContext.request.contextPath}';
    var postId = ${post.id};
    document.addEventListener('DOMContentLoaded', function() {
        var btn = document.getElementById('replySubmit');
        if (!btn) return;
        btn.onclick = function() {
            var contentEl = document.querySelector('textarea[name="content"]');
            var content = contentEl ? contentEl.value : '';
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
                    setTimeout(function() {
                        // 刷新到回复页第一页以查看新回复
                        window.location.href = _ctx + '/reply/list/' + postId + '?page=1';
                    }, 800);
                } else {
                    showMessage(response.message, 'error');
                }
            });
        };
    });
</script>
<script>
    function deleteReply(id) {
        if (!confirm('确定要删除这条回复吗？')) return;
        ajaxRequest(_ctx + '/reply/delete', 'POST', { id: id }, function(response) {
            if (response.success) {
                showMessage(response.message, 'success');
                // 移除回复元素
                var el = document.getElementById('reply-' + id);
                if (el) el.parentNode.removeChild(el);
                // 更新当前帖子的回复计数（如果存在展示元素）
                var countEl = document.getElementById('reply-count-' + postId);
                if (countEl) {
                    var val = parseInt(countEl.innerText) || 0;
                    if (val > 0) countEl.innerText = val - 1;
                }
                // 还尝试更新帖子列表页中的计数（如果存在）
                var listCountEl = document.getElementById('reply-count-' + postId);
                if (listCountEl && listCountEl !== countEl) {
                    var v2 = parseInt(listCountEl.innerText) || 0;
                    if (v2 > 0) listCountEl.innerText = v2 - 1;
                }
            } else {
                showMessage(response.message, 'error');
            }
        });
    }
</script>