package pl.poznan.put.cs.testservices.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

@ApplicationPath(Constants.APPLICATION_PATH)
public class TestService1Application extends Application {
	private final Set<Class<?>> classes = new HashSet<Class<?>>();
	
	public TestService1Application() {
		this.classes.add(ResourceOne.class);
		this.classes.add(ResourceTwo.class);
		this.classes.add(ResourceThree.class);
	}

	@Override
	public Set<Class<?>> getClasses() {
		return this.classes;
	}
}
