<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle", "回复列表");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 1000px;">
    <!-- 帖子信息 -->
    <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
        <h3 style="margin-bottom: 10px;">
            <a href="/post/detail/${post.id}" style="color: #333; text-decoration: none;">
                ${post.title}
            </a>
        </h3>
        <div style="color: #666; font-size: 14px;">
            作者: ${post.nickname ne null ? post.nickname : post.username} |
            回复数: ${post.replyCount}
        </div>
    </div>

    <!-- 回复列表 -->
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
                        <div style="border-bottom: 1px solid #eee; padding: 15px 0;">
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
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 分页 -->
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="/reply/list/${post.id}?page=${currentPage - 1}">上一页</a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i eq currentPage}">
                                <a href="#" class="active">${i}</a>
                            </c:when>
                            <c:otherwise>
                                <a href="/reply/list/${post.id}?page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="/reply/list/${post.id}?page=${currentPage + 1}">下一页</a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>