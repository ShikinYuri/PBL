<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle", "我的回复");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container">
    <!-- 我的回复列表 -->
    <div style="background-color: #fff; padding: 20px; border-radius: 5px;">
        <h2 style="margin-bottom: 20px;">我的回复</h2>

        <c:choose>
            <c:when test="${empty replies}">
                <div style="text-align: center; padding: 50px; color: #666;">
                    还没有任何回复
                </div>
            </c:when>
            <c:otherwise>
                <div>
                    <c:forEach items="${replies}" var="reply">
                        <div style="border-bottom: 1px solid #eee; padding: 15px 0;">
                            <div style="margin-bottom: 10px;">
                                <a href="/post/detail/${reply.postId}" style="color: #333; text-decoration: none; font-weight: bold;">
                                    查看原帖
                                </a>
                                <span style="color: #999; margin-left: 10px;">
                                    <fmt:formatDate value="${reply.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                </span>
                            </div>
                            <div style="line-height: 1.8; color: #333; white-space: pre-wrap; padding: 10px; background-color: #f5f5f5; border-radius: 5px;">
                                ${reply.content}
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 分页 -->
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="/reply/my?page=${currentPage - 1}">上一页</a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i eq currentPage}">
                                <a href="#" class="active">${i}</a>
                            </c:when>
                            <c:otherwise>
                                <a href="/reply/my?page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <a href="/reply/my?page=${currentPage + 1}">下一页</a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>