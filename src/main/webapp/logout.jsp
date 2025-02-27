<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logout</title>
        <script>
            // Prevent the user from going back to the previous page after logout
            history.forward();
        </script>
    </head>
    <body>
        <%
            // Get the session and invalidate it
            session = request.getSession(false);
            if (session != null) {
                String username = (String) session.getAttribute("LogUsername");
                session.removeAttribute("LogUsername");
                session.invalidate();
            }
            
            // Redirect the user to the login or home page after logout
            response.sendRedirect("Login"); // Replace with your desired page
        %>
    </body>
</html>
