<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.jvm.model.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css" href="css/styles.css"  />
<style>
.card {
  top: 50%;
  margin: 100px auto;
  padding: 0 20px;
  float: none;
}
</style>
</head>
<body>
    <div class="container-fluid">
    	<div class="card" style="width: 50vh;">
	    	<div class="card-body">
	        <form method="post" action="login">
				<div class="card-header">
				    <h4>User CRUD App</h4>
				    <h6 style="color:red;"><c:out value="${user_status}"/></h6>
				</div>
				<br>
	            <div>
	                <span class="font-weight-bold">Username</span>
	                <input class="form-control" type="text" name="username" />
	            </div>
	            <div>
	                <span class="font-weight-bold">Password</span>
	                <input class="form-control" type="password" name="password" />
	            </div>
	            <br>
	            <div>
	                <button class="btn btn-primary" type="submit">Login</button>
	            </div>
	        </form>
	        </div>
        </div>
    </div>
</body>
</html>