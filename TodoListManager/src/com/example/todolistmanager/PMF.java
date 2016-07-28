package com.example.todolistmanager;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;


public final class PMF {
	//instance of the factory manager
	private static final PersistenceManagerFactory pmf_instance = JDOHelper.getPersistenceManagerFactory("transactions-optional");
	
	//private constructor such that nothing can make an instance of this class
	private PMF() {
		
	}
	
	//returns the static instance of the factory manager
	public static PersistenceManagerFactory get() {
		return pmf_instance;
	}
	
	//update
	public static void updateEntity(Object o) {
        PersistenceManager pm = JDOHelper.getPersistenceManager(o);
        pm.currentTransaction().begin();
        pm.makePersistent(o);
        pm.currentTransaction().commit();
    }
}