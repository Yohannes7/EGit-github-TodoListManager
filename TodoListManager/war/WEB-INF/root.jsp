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
			
			<!--***********************************-->
			<!--************ ACCORDION ************-->
			<!--***********************************-->
			
			.accordion, .accordion * {-webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
			.accordion {overflow:hidden; box-shadow:0px 1px 3px rgba(0,0,0,0.25); border-radius:3px; background:#060000;} 
			.accordion-section-title {width:100%; padding:0px; display:inline-block; border-bottom:1px solid #1a1a1a;
			    background:#333; transition:all linear 0.15s; font-size:1.200em; text-shadow:0px 1px 0px #1a1a1a; color:#fff;}
			.accordion-section-title.active, .accordion-section-title:hover {background:#e31414; text-decoration:none;}
			.accordion-section:last-child .accordion-section-title {border-bottom:none;}
			.accordion-section-content {padding:15px; display:none;}
			
			<!--***************************************-->										
			<!--************ SWITCH TOGGLE ************--> 
			<!--***************************************-->											
			.toggle {position: absolute; margin-left: -9999px; visibility: hidden;}
			.toggle + label {display: block; position: relative; cursor: pointer; outline: none; user-select: none;}					
			input.togglestate + label {padding: 2px; width: 150px; height: 60px; margin-left: auto; margin-right: auto;}
			input.togglestate + label:before, input.togglestate + label:after {display: block;
  				position: absolute; top: 0; left: 0; bottom: 0; right: 0; color: #000; font-family: "Roboto Slab", serif; 
  				font-size: 20px; text-align: center; line-height: 60px;}
  			input.togglestate + label:before {background-color: #dddddd; content: attr(data-off); transition: transform 0.5s; backface-visibility: hidden;}
			input.togglestate + label:after {background-color: #8ce196; content: attr(data-on); transition: transform 0.5s; 
				transform: rotateY(180deg); backface-visibility: hidden;}
			input.togglestate:checked + label:before {transform: rotateY(180deg);}
			input.togglestate:checked + label:after {transform: rotateY(0);}									
														
														
			
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
				
				<div class="accordion">
				<%
					for(int i = 0; i<currentUser.getTodos().size();i++){
						Long kid = null;
									  								
						out.println("<div class='accordion-section'>"
										+ "<a class='accordion-section-title' href='#accordion-"+i+"'><center>" + currentUser.getTodos().get(i).getName() + "</center></a>"
										+ "<div id='accordion-"+i+"' class='accordion-section-content'>"
											+ "<form name ='deleteForm' action='/' method='post'>"
												+ "<ta><tc> Decription : " + currentUser.getTodos().get(i).getTask() + "</tc><br><br>"
												+ "<tr><td align='center'><ta><input type='submit' value='edit' name='edit'></td></tr>"
												+ "<ta><tc>Current task state : <b>" + currentUser.getTodos().get(i).getState() + "</b></tc><br><br>"
												+ "<tr><td align='center'><ta><input type='submit' value='delete' name='delete'></td></tr>"
												+ "<input id='task_id' type='text' name='kid'  value='"+ currentUser.getTodos().get(i).getId().getId() +"' style='visibility: hidden;'/>"			
											+ "</form>"
											+ "<form id='"+ currentUser.getTodos().get(i).getId().getId() +"Tog' name ='stateForm' action='/' method='post'>"
													+ "<diva><aha><tc>Clic on the toggle button to change the state of the task.</tc></aha></diva>" 
													+ "<input  id='"+ currentUser.getTodos().get(i).getId().getId() +"'  class='toggle togglestate' type='checkbox' style='visibility: hidden;'>"
													+ "<label for='"+ currentUser.getTodos().get(i).getId().getId() +"' data-on='complete' data-off='incomplete'></label>"
													+ "<br><br><center><input type='submit' value='save state' name='savestate' onclick='state_submit()'></center>"	
													+ "<input id='togbtn_id_Tog' type='text' name='togbtn_id'  value='togbtn"+ i +"' style='visibility: hidden;'/>"
													+ "<p id='hidden'>"
													+ "<input id='task_id_Tog' type='text' name='kid'  value='"+ currentUser.getTodos().get(i).getId().getId() +"' style='visibility: hidden;'/>"
											+ "</form>"
										+ "</div>"
									+ "</div>"
						);
					}//TODO req.setParameter("state", doit prendre valeur de checkbox)
				 %>
				</div><!--end .accordion-->	
				
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
		
		//////////////////////////////
		// Accordion animation part //
		/////////////////////////////
		
		$(document).ready(function() {
			
			function close_accordion_section() {
				$('.accordion .accordion-section-title').removeClass('active');
				$('.accordion .accordion-section-content').slideUp(300).removeClass('open');
			}
		 			
			$('.accordion-section-title').click(function(e) {
				// Grab current anchor value
				var currentAttrValue = $(this).attr('href');
		 
				if($(e.target).is('.active')) {
					close_accordion_section();
					
				}else {
					close_accordion_section();
		 
					// Add active class to section title
					$(this).addClass('active');
					// Open up the hidden content panel
					$('.accordion ' + currentAttrValue).slideDown(300).addClass('open'); 
					
				}
		 
				e.preventDefault();
			});
		});
			
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