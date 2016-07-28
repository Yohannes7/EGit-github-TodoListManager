package com.example.todolistmanager;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.SimpleTimeZone;
import java.util.logging.Logger;

import javax.jdo.FetchGroup;
import javax.jdo.JDOObjectNotFoundException;
import javax.jdo.PersistenceManager;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
 
@SuppressWarnings("serial")
public class EditServlet extends HttpServlet {
	
	private static final Logger log = Logger.getLogger(EditServlet.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

		Todo currentTodo = (Todo)req.getAttribute("currentTodo");
		
		// get access to a request dispatcher and forward onto the root.jsp file
		RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/edit.jsp");
		rd.forward(req, resp);
			
	}

	// simple post method that updates a users preferences with new email information
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		PersistenceManager pm = PMF.get().getPersistenceManager();				
		UserService us = UserServiceFactory.getUserService();
		User user = us.getCurrentUser();

		// get access to the user. if they do not exist in the datastore then
		// store a default version of them. of course we have to check that a user has
		// logged in first		
		UserT existingUser=null;
		if(user != null) {	
			pm.getFetchPlan().setGroup(FetchGroup.ALL);
			Key userKey = KeyFactory.createKey(UserT.class.getSimpleName(), user.getUserId());
			try {
	            existingUser = pm.getObjectById(UserT.class, userKey);
	        } catch (JDOObjectNotFoundException e) {
	        	existingUser = new UserT();
	        	existingUser.setID(userKey);
	        	existingUser.setEmail(user.getEmail());
	            pm.makePersistent(existingUser);
	        }
			Todo usingTodo=	Todo.getTodoUsingTheKey(req.getParameter("kid"), existingUser);

			// get the new task from the form
			String newTodo;
			String newTask;
			try{
				newTodo = req.getParameter("e_name");
				newTask = req.getParameter("e_todo");
			} catch(Exception e) {return;}
			
			Date mydate = new Date();
				
			// update the task data in the datastore and then redirect to /root
			try {
				usingTodo.setName(newTodo);
				usingTodo.setTask(newTask);
				usingTodo.setDate(mydate);
				pm.makePersistent(usingTodo);
			} catch (Exception e) {
				// will only fail if the datastore goes down as this is already in the datastore
			}
					
		}else{
			System.out.println("oups");
		}pm.close();

	resp.sendRedirect("/root");
	}
}
