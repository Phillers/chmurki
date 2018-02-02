package pl.poznan.put.cs.testservices.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

@ApplicationPath(Constants.APPLICATION_PATH)
public class TestService2Application extends Application {
	private final Set<Class<?>> classes = new HashSet<Class<?>>();
	
	public TestService2Application() {
		this.classes.add(ResourceA.class);
		this.classes.add(ResourceB.class);
		this.classes.add(ResourceC.class);
	}

	@Override
	public Set<Class<?>> getClasses() {
		return this.classes;
	}
}
