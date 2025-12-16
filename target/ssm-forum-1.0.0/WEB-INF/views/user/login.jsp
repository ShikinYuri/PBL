<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "用户登录");
%>
<jsp:include page="../common/header.jsp"/>

<div class="container" style="max-width: 500px; margin-top: 50px;">
    <div style="background-color: #fff; padding: 30px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h2 style="text-align: center; margin-bottom: 30px;">用户登录</h2>

        <form id="loginForm">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn btn-primary" style="width: 100%;">登录</button>
            </div>
        </form>

        <div style="text-align: center; margin-top: 20px;">
            <p>还没有账号？ <a href="/user/register">立即注册</a></p>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script>
    document.getElementById('loginForm').onsubmit = function(e) {
        e.preventDefault();

        var username = document.getElementById('username').value;
        var password = document.getElementById('password').value;

        if (!username || !password) {
            showMessage('请填写用户名和密码', 'error');
            return;
        }

        ajaxRequest('/user/login', 'POST', {
            username: username,
            password: password
        }, function(response) {
            if (response.success) {
                showMessage(response.message, 'success');
                setTimeout(function() {
                    window.location.href = '/';
                }, 1000);
            } else {
                showMessage(response.message, 'error');
            }
        });
    };
</script>