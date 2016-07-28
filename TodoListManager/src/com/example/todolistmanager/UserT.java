package com.example.todolistmanager;
            
import java.io.Serializable;
import java.util.List;
import java.util.ArrayList;

import javax.jdo.annotations.*;
import javax.jdo.JDOObjectNotFoundException;
import javax.jdo.PersistenceManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import org.datanucleus.FetchGroup;
      
@PersistenceCapable(identityType = IdentityType.APPLICATION, detachable = "true")
public class UserT implements Serializable {
	
	@PrimaryKey 
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key id;
	  
	@Persistent
	private String email;
	   
	@Persistent(mappedBy="user")
	@Element(dependent = "true")
	@Order(extensions = @Extension(vendorName="datanucleus",key="list-ordering", value="id ASC"))
	private List<Todo> todos = new ArrayList<Todo>();
	    
	// getter and setter for the id
    public Key getId() {return id;}
    public void setID(final Key id) { this.id = id; }

    // getter and setter for the email
    public String getEmail() {return email;}
    public void setEmail(String email) {this.email = email;}

    // getter for the list of todos
    public List<Todo> getTodos() {
        //if(todos == null) todos = new ArrayList<Todo>();
        return todos;
    }
 
    	 
	public UserT() {this.id = id;}
    public UserT(String email) {this.email = email;}
	
	private static UserService u = UserServiceFactory.getUserService();
	
    private static UserT registerUser(User us) {
        PersistenceManager pm = PMF.get().getPersistenceManager();
        UserT user = new UserT(us.getEmail());
        pm.makePersistent(user);
        pm.close();
        return user;
    }
	
	public static UserT getRegisteredUser(com.google.appengine.api.users.User user) {
        PersistenceManager pm = PMF.get().getPersistenceManager();
        pm.getFetchPlan().setGroup(FetchGroup.ALL);
        Key userKey = KeyFactory.createKey(UserT.class.getSimpleName(), user.getEmail());
        UserT knownUser;
        try {
            knownUser = pm.getObjectById(UserT.class, userKey);
        } catch (JDOObjectNotFoundException e) {
            knownUser = null;
        } finally {
            pm.close();
        }
        return knownUser;
    }
	
    public static UserT getCurrentUser() {
    	//UserService u = UserServiceFactory.getUserService();
    	User us = u.getCurrentUser();
        UserT user = getRegisteredUser(us);
        if(user != null) {
            return user;
        } else {
            return registerUser(us);
        }
    }
	 
	 public static String createLogoutURL(String logoutURL) {
		//UserService u = UserServiceFactory.getUserService();
		 return u.createLogoutURL(logoutURL);
	 }
	 
	 public static String createLoginURL(String loginURL) {
		 //UserService u = UserServiceFactory.getUserService();
		 return u.createLoginURL(loginURL);
	 }
	public void addToDo(Todo settings) {
		todos.add(settings);
		
	}
	
}
