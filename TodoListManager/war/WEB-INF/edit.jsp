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
<%@ page import="com.example.todolistmanager.Todo" %>


<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>TODO LIST MANAGER</title>
	</head>
	 <base href="${pageContext.request.contextPath}">
	<link rel="stylesheet" type="text/css" href="css/styles.css">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<style>		
		div {
		    list-style-type: none;
		    margin: 0;
		    padding: 0;
		    overflow: hidden;
		    background-color: #333333;
		}
		
		div a {
		    display: block;
		    color: white;
		    text-align: center;
		    padding: 16px;
		    text-decoration: none;
		}
		
		div a:hover {
		    background-color: #FA1F1F;
		}
		
		ta {
			margin-left: 90px;
		} 
		
		tc {
			color: white;
		}
		
	</style>
	<body>
		<!-- if the user is logged in then we need to render one version of the page
		consequently if the user is logged out we need to render a different version of the page -->
				
		<%
		    
			Todo currentTodo = (Todo)request.getAttribute("currentTodo");
			if (currentTodo != null) {
				
		%>
			<h3>Time to Edit a Task</h3>

				Let's do it<br/>
				
				<!-- add in a small form to allow the user to update the task descrition -->
				<form id="editform" name="editform" action="/edit" method="post" >
					<!-- buttons to work with tasks -->
					<br><br/>
					
					<div id="editTaskInfo"> 
						<!-- permits multiline text input -->
						<%
							out.println("<tc>Task name: </tc><br/>"
								+ "<input type='text' name='kid' value='"+ currentTodo.getId().getId()+"' style='visibility: hidden;'/><br/>"
								+ "<input id='task_name' type='text' name='e_name' value='"+ currentTodo.getName()+"'/><br/>"
								+ "<tc>Task description: </tc><br/>"
								+ "<input id='task_name' type='text' name='e_todo' value='"+ currentTodo.getTask()+"'/><br/>"
								+ "<input id='cancel' type='button' name='Cancel' value='cancel' onclick='leave()'/>"
								+ "<input type='submit' name='edit' value='save'/>"
							);
						%>					 
					</div>	
				</form>		
			<%}%>
	</body>
	<script type="text/javascript">
		
		function leave(){
			document.editform.e_name.value = "";
			document.editform.e_todo.value = "";
			window.location.replace("root");
		}
			
	</script>
</html>