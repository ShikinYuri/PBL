<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "用户注册");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 500px; margin-top: 50px;">
    <div style="background-color: #fff; padding: 30px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h2 style="text-align: center; margin-bottom: 30px;">用户注册</h2>

        <form id="registerForm">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">确认密码</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
            </div>

            <div class="form-group">
                <label for="email">邮箱</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>

            <div class="form-group">
                <label for="nickname">昵称</label>
                <input type="text" class="form-control" id="nickname" name="nickname">
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn btn-primary" style="width: 100%;">注册</button>
            </div>
        </form>

            <div style="text-align: center; margin-top: 20px;">
            <p>已有账号？ <a href="${pageContext.request.contextPath}/user/login">立即登录</a></p>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    document.getElementById('registerForm').onsubmit = function(e) {
        e.preventDefault();

        var username = document.getElementById('username').value;
        var password = document.getElementById('password').value;
        var confirmPassword = document.getElementById('confirmPassword').value;
        var email = document.getElementById('email').value;
        var nickname = document.getElementById('nickname').value;

        if (!username || !password || !confirmPassword || !email) {
            showMessage('请填写所有必填项', 'error');
            return;
        }

        if (password !== confirmPassword) {
            showMessage('两次输入的密码不一致', 'error');
            return;
        }

        if (password.length < 6) {
            showMessage('密码长度不能少于6位', 'error');
            return;
        }

        var _ctx = '${pageContext.request.contextPath}';
        ajaxRequest(_ctx + '/user/register', 'POST', {
            username: username,
            password: password,
            email: email,
            nickname: nickname
        }, function(response) {
            if (response.success) {
                showMessage(response.message, 'success');
                setTimeout(function() {
                    window.location.href = _ctx + '/user/login';
                }, 1500);
            } else {
                showMessage(response.message, 'error');
            }
        });
    };
</script>