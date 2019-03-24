<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
    <center>
        <h2>Servlet Application Login Example</h2>
        <form method="post" action="login">
            <div id="usernameDiv">
                <span id="user">Username: </span><input type="text" name="username" />
            </div>
            <div id="passwordDiv">
                <span id="pass">Password: </span><input type="password" name="password" />
            </div>
            <div id="loginBtn">
                <input type="submit" value="login" />
            </div>
        </form>
    </center>
</body>
</html>