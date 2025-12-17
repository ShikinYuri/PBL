<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div style="background-color: #333; color: #fff; padding: 20px 0; margin-top: 40px;">
    <div class="container">
        <div style="text-align: center;">
            <p>&copy; 2024 SSM论坛. All rights reserved.</p>
            <p>基于 Spring + SpringMVC + MyBatis 框架开发</p>
        </div>
    </div>
</div>

<script>
    function showMessage(message, type) {
        type = type || 'success';
        var alertClass = type === 'error' ? 'alert-error' : 'alert-success';
        var alertDiv = document.createElement('div');
        alertDiv.className = 'alert ' + alertClass;
        alertDiv.textContent = message;
        alertDiv.style.position = 'fixed';
        alertDiv.style.top = '20px';
        alertDiv.style.right = '20px';
        alertDiv.style.zIndex = '9999';
        alertDiv.style.minWidth = '300px';
        document.body.appendChild(alertDiv);

        setTimeout(function() {
            alertDiv.remove();
        }, 3000);
    }

    // AJAX请求封装
    function ajaxRequest(url, method, data, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open(method, url, true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        callback(response);
                    } catch (e) {
                        callback({success: false, message: '响应解析失败'});
                    }
                } else {
                    callback({success: false, message: '请求失败: ' + xhr.status});
                }
            }
        };

        var postData = [];
        for (var key in data) {
            if (data.hasOwnProperty(key)) {
                postData.push(encodeURIComponent(key) + '=' + encodeURIComponent(data[key]));
            }
        }
        xhr.send(postData.join('&'));
    }

    // 格式化日期
    function formatDate(dateString) {
        if (!dateString) return '';
        var date = new Date(dateString);
        return date.getFullYear() + '-' +
               String(date.getMonth() + 1).padStart(2, '0') + '-' +
               String(date.getDate()).padStart(2, '0') + ' ' +
               String(date.getHours()).padStart(2, '0') + ':' +
               String(date.getMinutes()).padStart(2, '0');
    }
</script>
</body>
</html>