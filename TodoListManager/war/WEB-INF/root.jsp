<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.example.todolistmanager.UserT" %>


<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>TODO LIST MANAGER</title>
		<base href="${pageContext.request.contextPath}">
		<link rel="stylesheet" type="text/css" href="css/styles.css">
	</head>
	<body>
		<!-- if the user is logged in then we need to render one version of the page
		consequently if the user is logged out we need to render a different version of the page -->
		
		<%
		    String userName = request.getParameter("user");
			UserT currentUser = (UserT)request.getAttribute("currentUser");
		    
			if (userName == null) {
		        userName = "default";
		    }
		    
		    pageContext.setAttribute("user", userName);
		    UserService userService = UserServiceFactory.getUserService();
		    User user = userService.getCurrentUser();
		
			if (user != null) {
				pageContext.setAttribute("user", user);
		%>
				<br/>Welcome ${user.nickname} ! 
				<a href="${logout_url}">Sign out</a><br/><br/>
				
				
		<%
			} else {
		%>
				<p>Welcome!<a href="${login_url}">Sign in or register</a></p>	
		<%
			}
		%>
		
	</body>
</html>