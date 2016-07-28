package com.example.todolistmanager;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.example.todolistmanager.UserT;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;
       
    
@PersistenceCapable
public class Todo implements Serializable{
    
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key id;
	    
	@Persistent
	private String t_name;
	      
	@Persistent 
	private Date t_date;
	
	@Persistent
	private String t_task;
	
	@Persistent
	private String t_state;
	   
	         
	public Todo() {this.id = id;}
	 
	// setter and getter for the id
	public Key getId() {return id;}
	public void setID(final Key id) { this.id = id; }
  
	// setter and getter for the task name
	public void setName(final String t_name) {this.t_name = t_name;}
	public String getName() {return t_name;}
	   
	// setter and getter for the task date
	public void setDate(final Date t_date) {this.t_date = t_date;}
	public Date getDate() {return t_date;}
	  
	// setter and getter for the task information
	public void setTask(final String t_task) {this.t_task = t_task;}
	public String getTask() {return t_task;}

	// setter and getter for the task state
	public void setState(final String t_state) {this.t_state = t_state;}
	public String getState() {return t_state;}
	
	
	public Todo(String todo_name, String todo_task) {
        t_name = todo_name;
        t_task = todo_task;
        //t_date = todo_date;
    }
	   
	public void setUser(UserT us)
	{
 		this.user=us;
	}  
                     
	@Persistent
	private UserT user;
	
}
