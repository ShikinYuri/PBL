<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle", section != null ? section.name : "版块");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container">
    <!-- 版块信息 -->
    <c:if test="${section != null}">
        <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
            <h2 style="margin-bottom: 10px;">${section.name}</h2>
            <p style="color: #666; margin-bottom: 10px;">${section.description}</p>
            <small style="color: #999;">帖子总数: ${section.postCount}</small>
        </div>
    </c:if>

    <!-- 帖子列表 -->
    <div style="background-color: #fff; padding: 20px; border-radius: 5px;">
        <c:choose>
            <c:when test="${empty posts}">
                <div style="text-align: center; padding: 50px; color: #666;">
                    该版块暂无帖子
                </div>
            </c:when>
            <c:otherwise>
                <div>
                    <c:forEach items="${posts}" var="post">
                        <div style="border-bottom: 1px solid #eee; padding: 15px 0;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div style="flex: 1;">
                                    <a href="${pageContext.request.contextPath}/post/detail/${post.id}" style="color: #333; text-decoration: none; font-size: 16px;">
                                        <c:if test="${post.isTop eq 1}">
                                            <span style="color: #dc3545; font-weight: bold;">[置顶]</span>
                                        </c:if>
                                        <c:if test="${post.isEssence eq 1}">
                                            <span style="color: #ffc107; font-weight: bold;">[精华]</span>
                                        </c:if>
                                        ${post.title}
                                    </a>
                                    <div style="margin-top: 8px; color: #666; font-size: 14px;">
                                        作者: ${post.nickname ne null ? post.nickname : post.username} |
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
                        <a href="${pageContext.request.contextPath}/section/${section.id}?page=${currentPage - 1}">上一页</a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i eq currentPage}">
                                <a href="#" class="active">${i}</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/section/${section.id}?page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/section/${section.id}?page=${currentPage + 1}">下一页</a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>