package com.example.todolistmanager;
            
import java.io.Serializable;
import java.util.List;
import java.util.ArrayList;

import javax.jdo.annotations.*;


import com.google.appengine.api.datastore.Key;

      
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
		
}
