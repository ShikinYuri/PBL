<%-- detail page removed. Redirect users to reply list if accessed directly --%>
<%
    String refer = request.getRequestURI();
    // Try to extract id from URI like /context/post/detail/{id}
    String[] parts = refer != null ? refer.split("/") : new String[0];
    String id = "";
    if (parts.length > 0) {
        id = parts[parts.length - 1];
    }
    response.sendRedirect(request.getContextPath() + (id != null && !id.isEmpty() ? ("/reply/list/" + id) : "/"));
%>