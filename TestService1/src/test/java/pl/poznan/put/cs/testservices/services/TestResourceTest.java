package pl.poznan.put.cs.testservices.services;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.junit.Test;

import pl.poznan.put.cs.testservices.domain.TestResource;

public class TestResourceTest {

	@Test
	public void test() {
		String testString = "A2B3C";
		String targetPort = Constants.TESTSERVICE1_PORT;
		String targetResourcePath = Constants.RESOURCE_ONE_PATH;
		TestResource testResource = new TestResource(testString);
		
		Client client = ClientBuilder.newClient();
		try {
			Response response = client.target("http://localhost:" + targetPort + Constants.APPLICATION_PATH + targetResourcePath)
					.request().post(Entity.entity(testResource, MediaType.APPLICATION_JSON));
			response.close();
		} finally {
			client.close();
		}
	}
}
