<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle", request.getAttribute("pageTitle"));
%>
<jsp:include page="../common/header.jsp"/>

<div class="container">
    <!-- 搜索框 -->
    <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
        <form action="/post/search" method="get" style="display: flex; gap: 10px;">
            <input type="text" name="keyword" class="form-control" placeholder="搜索帖子..." value="${param.keyword}" style="flex: 1;">
            <button type="submit" class="btn btn-primary">搜索</button>
        </form>
    </div>

    <!-- 版块选择 -->
    <div style="background-color: #fff; padding: 20px; margin-bottom: 20px; border-radius: 5px;">
        <div style="display: flex; align-items: center; gap: 20px;">
            <span style="font-weight: bold;">版块:</span>
            <a href="/post/list" class="${empty sectionId ? 'active' : ''}" style="padding: 5px 10px; border-radius: 3px; text-decoration: none; ${empty sectionId ? 'background-color: #007bff; color: white;' : 'color: #666;'}">全部</a>
            <c:forEach items="${sections}" var="section">
                <a href="/post/list?sectionId=${section.id}" class="${sectionId == section.id ? 'active' : ''}" style="padding: 5px 10px; border-radius: 3px; text-decoration: none; ${sectionId == section.id ? 'background-color: #007bff; color: white;' : 'color: #666;'}">${section.name}</a>
            </c:forEach>
        </div>
    </div>

    <!-- 帖子列表 -->
    <div style="background-color: #fff; padding: 20px; border-radius: 5px;">
        <h2 style="margin-bottom: 20px;">${pageTitle}</h2>

        <c:choose>
            <c:when test="${empty posts}">
                <div style="text-align: center; padding: 50px; color: #666;">
                    暂无帖子
                </div>
            </c:when>
            <c:otherwise>
                <div>
                    <c:forEach items="${posts}" var="post">
                        <div style="border-bottom: 1px solid #eee; padding: 15px 0;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div style="flex: 1;">
                                    <a href="/post/detail/${post.id}" style="color: #333; text-decoration: none; font-size: 16px;">
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
                        <a href="/post/list?page=${currentPage - 1}${sectionId ne null ? '&sectionId=' : ''}${sectionId ne null ? sectionId : ''}">上一页</a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i eq currentPage}">
                                <a href="#" class="active">${i}</a>
                            </c:when>
                            <c:otherwise>
                                <a href="/post/list?page=${i}${sectionId ne null ? '&sectionId=' : ''}${sectionId ne null ? sectionId : ''}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="/post/list?page=${currentPage + 1}${sectionId ne null ? '&sectionId=' : ''}${sectionId ne null ? sectionId : ''}">下一页</a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>