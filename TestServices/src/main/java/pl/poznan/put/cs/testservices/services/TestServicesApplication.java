package pl.poznan.put.cs.testservices.services;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

@ApplicationPath("/testservices")
public class TestServicesApplication extends Application {
	private final Set<Class<?>> classes = new HashSet<Class<?>>();
	
	public TestServicesApplication() {
		this.classes.add(ResourceOne.class);
		this.classes.add(ResourceTwo.class);
		this.classes.add(ResourceThree.class);
		this.classes.add(ResourceFour.class);
		this.classes.add(ResourceFive.class);
		this.classes.add(ResourceSix.class);
	}

	@Override
	public Set<Class<?>> getClasses() {
		return this.classes;
	}
}
