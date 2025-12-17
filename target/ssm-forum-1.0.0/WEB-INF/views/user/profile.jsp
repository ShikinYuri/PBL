<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "个人中心");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 800px; margin-top: 30px;">
    <div style="background-color: #fff; padding: 30px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h2 style="margin-bottom: 30px;">个人中心</h2>

        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 30px;">
            <!-- 左侧用户信息 -->
            <div style="text-align: center;">
                <div style="position: relative; display: inline-block;">
                    <c:choose>
                        <c:when test="${not empty user.avatar}">
                            <img id="avatarImg" src="${pageContext.request.contextPath}${user.avatar}" 
                                 style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #ddd;">
                        </c:when>
                        <c:otherwise>
                            <div id="avatarImg" style="width: 120px; height: 120px; background-color: #f0f0f0; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 3px solid #ddd;">
                                <span style="font-size: 48px; color: #999;">👤</span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <label for="avatarInput" style="position: absolute; bottom: 0; right: 0; background-color: #007bff; color: white; border-radius: 50%; width: 30px; height: 30px; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 16px;">📷</label>
                    <input type="file" id="avatarInput" accept="image/*" style="display: none;">
                </div>
                <h3>${user.nickname ne null ? user.nickname : user.username}</h3>
                <c:if test="${not empty sessionScope.user and (sessionScope.user.role == 1 or sessionScope.user.role == '1')}">
                    <p style="color: #dc3545; font-weight: bold;">管理员</p>
                </c:if>
                <p style="color: #666; margin-top: 10px;">
                    注册时间: <fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd"/>
                </p>
            </div>

            <!-- 右侧编辑表单 -->
            <div>
                <h4 style="margin-bottom: 20px;">编辑资料</h4>
                <form id="profileForm">
                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" class="form-control" value="${user.username}" readonly style="background-color: #f5f5f5;">
                        <small style="color: #666;">用户名不可修改</small>
                    </div>

                    <div class="form-group">
                        <label for="email">邮箱</label>
                        <input type="email" class="form-control" id="email" value="${user.email}">
                    </div>

                    <div class="form-group">
                        <label for="nickname">昵称</label>
                        <input type="text" class="form-control" id="nickname" value="${user.nickname}">
                    </div>

                    <button type="submit" class="btn btn-primary">保存修改</button>
                </form>
            </div>
        </div>

        <hr style="margin: 30px 0;">

        <!-- 快捷链接 -->
        <div>
            <h4 style="margin-bottom: 15px;">快捷链接</h4>
            <div style="display: flex; gap: 15px;">
                <a href="${pageContext.request.contextPath}/post/my" class="btn btn-secondary">我的帖子</a>
                <a href="${pageContext.request.contextPath}/reply/my" class="btn btn-secondary">我的回复</a>
                <c:if test="${not empty sessionScope.user and (sessionScope.user.role == 1 or sessionScope.user.role == '1')}">
                    <a href="${pageContext.request.contextPath}/user/manage" class="btn btn-danger">用户管理</a>
                </c:if>
                <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-danger" style="margin-left: auto;">退出登录</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    document.getElementById('profileForm').onsubmit = function(e) {
        e.preventDefault();

        var email = document.getElementById('email').value;
        var nickname = document.getElementById('nickname').value;

        if (!email || !email.includes('@')) {
            showMessage('请输入有效的邮箱地址', 'error');
            return;
        }

        var _ctx = '${pageContext.request.contextPath}';
        ajaxRequest(_ctx + '/user/updateProfile', 'POST', {
            email: email,
            nickname: nickname
        }, function(response) {
            if (response.success) {
                showMessage(response.message, 'success');
                setTimeout(function() {
                    location.reload();
                }, 1000);
            } else {
                showMessage(response.message, 'error');
            }
        });
    };

    // 头像上传功能
    document.getElementById('avatarInput').onchange = function(e) {
        var file = e.target.files[0];
        if (!file) return;

        // 预览头像
        var reader = new FileReader();
        reader.onload = function(e) {
            var avatarImg = document.getElementById('avatarImg');
            if (avatarImg.tagName === 'IMG') {
                avatarImg.src = e.target.result;
            } else {
                // 如果是div，替换为img
                var img = document.createElement('img');
                img.id = 'avatarImg';
                img.src = e.target.result;
                img.style = 'width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid #ddd;';
                avatarImg.parentNode.replaceChild(img, avatarImg);
            }
        };
        reader.readAsDataURL(file);

        // 上传文件
        var formData = new FormData();
        formData.append('avatar', file);

        var _ctx = '${pageContext.request.contextPath}';
        var xhr = new XMLHttpRequest();
        xhr.open('POST', _ctx + '/user/uploadAvatar', true);
        xhr.onload = function() {
            if (xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                if (response.success) {
                    showMessage(response.message, 'success');
                } else {
                    showMessage(response.message, 'error');
                    // 恢复原头像
                    location.reload();
                }
            } else {
                showMessage('上传失败', 'error');
                location.reload();
            }
        };
        xhr.send(formData);
    };
</script>