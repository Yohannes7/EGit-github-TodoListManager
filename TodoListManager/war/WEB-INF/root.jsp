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
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<style>
			<!--********************************-->
			<!--************ BASICS ************-->
			<!--********************************-->
					
			div {list-style-type: none; margin: 0; padding: 0; overflow: hidden; background-color: #333333;}
			div a {display: block; color: white; text-align: center; padding: 16px; text-decoration: none;}
			div a:hover {background-color: #FA1F1F;}
			ta {margin-left: 90px;} 
			tc {color: white;}
			diva {list-style-type: none; margin: 0; padding: 0; overflow: hidden;}
			diva aha {display: block; color: white; text-align: center; padding: 16px; text-decoration: none;}
			
	
		</style>
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
				
				<br>
				<!-- add in a small form to allow the user to update the timezone with a number -->
				<form id="taskform" name="taskform" action="/" method="post" onSubmit="return verif_form()">
					<!-- button to add a task -->
					<input id="create" type="button" name="Create a task" value="New task" onclick="CreateTask();"/>
					
					<div id="newTaskInfo">
						<!-- permits multiline text input -->
						Task name: <br/>
						<input id="task_name" type="text" name="t_name"/><br/> 
						Task description: <br/>
						<textarea id="editarea" rows="5" cols="40" name="t_task"></textarea><br/>
						<input id="cancel" type="button" name="Cancel" value="cancel" onclick="CancelTask();"/>
						<input type="submit" name="save" value="save task"/>
					</div>	
				</form>		
		<%
			} else {
		%>
				<p>Welcome!<a href="${login_url}">Sign in or register</a></p>	
		<%
			}
		%>
		
		<script type="text/javascript">
		//////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		
		document.getElementById("newTaskInfo").style.visibility="hidden";
			
		function CreateTask(){
			document.getElementById("newTaskInfo").style.visibility="visible";
			document.getElementById("create").style.visibility="hidden";
			//return true;
		}
		
		function CancelTask(){
			document.getElementById("newTaskInfo").style.visibility="hidden";
			document.getElementById("create").style.visibility="visible";
			document.taskform.t_name.value = "";
			document.taskform.t_task.value = ""
			//return true;
		}
	
		function verif_form(){
		 	if(document.taskform.t_name.value.replace(/\s/, "") == "")  {
		   		alert("What is the task name?");
		   		document.taskform.t_name.focus();
		   		return false;
			}
		 	if(document.taskform.t_task.value.replace(/\s/, "") == "") {
		   		alert("What is the task description?");
		   		document.taskform.t_task.focus();
		   		return false;
		  	}
		}
				
		</script>
	</body>
</html>