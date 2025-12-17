<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle", "首页");
%>
<jsp:include page="common/header.jsp"/>

<div class="container">
    <!-- 版块列表 -->
    <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
        <h2 style="margin-bottom: 15px;">论坛版块</h2>
        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 15px;">
            <c:forEach items="${sections}" var="section">
                    <a href="${pageContext.request.contextPath}/section/${section.id}" style="display: block; padding: 15px; background-color: #f8f9fa; border-radius: 5px; text-decoration: none; color: #333; transition: all 0.3s;">
                    <h3 style="margin-bottom: 5px;">${section.name}</h3>
                    <p style="color: #666; font-size: 14px;">${section.description}</p>
                    <small style="color: #999;">帖子数: ${section.postCount}</small>
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- 置顶/精华帖子 -->
    <c:if test="${not empty topPosts}">
        <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
            <h2 style="margin-bottom: 15px; color: #dc3545;">置顶/精华帖子</h2>
            <div>
                <c:forEach items="${topPosts}" var="post">
                    <div style="border-bottom: 1px solid #eee; padding: 15px 0;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                    <a href="${pageContext.request.contextPath}/reply/list/${post.id}" style="color: #333; text-decoration: none; font-size: 16px;">
                                    <c:if test="${post.isTop eq 1}">
                                        <span style="color: #dc3545; font-weight: bold;">[置顶]</span>
                                    </c:if>
                                    <c:if test="${post.isEssence eq 1}">
                                        <span style="color: #ffc107; font-weight: bold;">[精华]</span>
                                    </c:if>
                                    ${post.title}
                                </a>
                                <div style="margin-top: 5px; color: #666; font-size: 14px;">
                                    作者: ${post.nickname ne null ? post.nickname : post.username} |
                                    版块: ${post.sectionName} |
                                    回复: ${post.replyCount} |
                                    浏览: ${post.viewCount} |
                                    时间: <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- 最新帖子 -->
    <div style="background-color: #fff; padding: 20px; border-radius: 5px;">
        <h2 style="margin-bottom: 15px;">最新帖子</h2>
        <div>
            <c:forEach items="${recentPosts}" var="post">
                <div style="border-bottom: 1px solid #eee; padding: 15px 0;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <a href="${pageContext.request.contextPath}/reply/list/${post.id}" style="color: #333; text-decoration: none; font-size: 16px;">
                                ${post.title}
                            </a>
                            <div style="margin-top: 5px; color: #666; font-size: 14px;">
                                作者: ${post.nickname ne null ? post.nickname : post.username} |
                                版块: ${post.sectionName} |
                                回复: ${post.replyCount} |
                                浏览: ${post.viewCount} |
                                时间: <fmt:formatDate value="${post.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 分页 -->
        <div class="pagination">
                <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/?page=${currentPage - 1}">上一页</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i eq currentPage}">
                        <a href="#" class="active">${i}</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/?page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
                <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/?page=${currentPage + 1}">下一页</a>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp"/>