<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<head>
    <title>users Store Application</title>
</head>
<body>
    <div align="center">
        <table border="1" cellpadding="5">
            <caption><h2>List of users</h2></caption>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Author</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
            <c:forEach var="user" items="${listUser}">
                <tr>
                    <td><c:out value="${user.id}" /></td>
                    <td><c:out value="${user.username}" /></td>
                    <td><c:out value="${user.role}" /></td>
                    <td><c:out value="${user.department}" /></td>
                    <td>
                        <a href="/edit?id=<c:out value='${user.id}' />">Edit</a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="/delete?id=<c:out value='${user.id}' />">Delete</a>                     
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
    <script>
    var users = [
    	<c:forEach var="user" items="${listUser}">
    	    {
    	    	id: '${user.id}',
    	    	username: '${user.username}',
    	    	password: '${user.password}',
    	    	role: '${user.role}',
    	    	department: '${user.department}',
    	    	phone: '${user.phone}',
    	    	email: '${user.email}'
    	    }  
   	    </c:forEach>  
    	]; 
    
    alert(users);
    </script>  
</body>
</html>