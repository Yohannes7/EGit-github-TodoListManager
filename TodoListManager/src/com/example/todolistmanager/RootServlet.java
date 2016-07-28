package com.example.todolistmanager;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

import javax.jdo.FetchGroup;
import javax.jdo.JDOObjectNotFoundException;
import javax.jdo.PersistenceManager;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
 
@SuppressWarnings("serial")
public class RootServlet extends HttpServlet {
	
	private static final Logger log = Logger.getLogger(RootServlet.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

		// set the response type to be html text
		resp.setContentType("text/html");
		
		// get access to the google user service
		UserService us = UserServiceFactory.getUserService();
		User user = us.getCurrentUser();
		String login_url = us.createLoginURL("/");
		String logout_url = us.createLogoutURL("/");
		
		// attach a few things to the request such that we can access them in the jsp
		req.setAttribute("user", user);
		req.setAttribute("login_url", login_url);
		req.setAttribute("logout_url", logout_url);
				
		PersistenceManager pm = PMF.get().getPersistenceManager();
		//MemcacheService ms = MemcacheServiceFactory.getMemcacheService();
			
		// get access to the user. if they do not exist in the datastore then
		// store a default version of them. of course we have to check that a user has logged in first
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
			
			req.setAttribute("currentUser",existingUser);
			
			pm.close();

			System.out.println("user is: " + existingUser.getId());
		}

		// get access to a request dispatcher and forward onto the root.jsp file
		RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/root.jsp");
		rd.forward(req, resp);
			
	}

	// simple post method that updates a users preferences with new email information
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
		UserService us = UserServiceFactory.getUserService();
		User user = us.getCurrentUser();
		PersistenceManager pm = PMF.get().getPersistenceManager();

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
	            //existingUser = new UserT(user.getEmail());
	            existingUser = new UserT();
	        	existingUser.setID(userKey);
	        	existingUser.setEmail(user.getEmail());
	            pm.makePersistent(existingUser);
	        }
			
			if (req.getParameter("save") != null) {
		         saveAction(req, resp,existingUser);
		         pm.makePersistent(existingUser);
		         pm.close();
			}
		}
		resp.sendRedirect("/");
	}

	private void saveAction(HttpServletRequest req, HttpServletResponse resp, UserT user){
			
		Todo settings;
	
		// get the new task from the form
		String newTask = "";
		String newTodo = "";
		String state = "incomplete";
		try{
			newTask = req.getParameter("t_name");
			newTodo = req.getParameter("t_task");
		} catch(Exception e) {return;}
				
		Date mydate = new Date();
		
		// update the task data in the datastore and then redirect to /
		Key todoKey = KeyFactory.createKey("Todo", mydate.getTime());
		try {
			settings = new Todo();
			settings.setUser(user);
			settings.setName(newTask);
			settings.setTask(newTodo);
			settings.setDate(mydate);
			settings.setID(todoKey);
			settings.setState(state);
			user.getTodos().add(settings);
			
		} catch (Exception e) {	// will only fail if the datastore goes down as this is already in the datastore  
		}
		
	}	
}
