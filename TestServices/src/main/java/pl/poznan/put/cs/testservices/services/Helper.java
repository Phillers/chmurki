package pl.poznan.put.cs.testservices.services;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import pl.poznan.put.cs.testservices.domain.TestResource;

public class Helper {
	private Helper() {
		
	}
	
	public static void sendRequest(String resourcePath, TestResource testResource) {
		Client client = ClientBuilder.newClient();
		try {
			Response response = client.target("http://localhost:8080/testservices/" + resourcePath).request()
					.post(Entity.entity(testResource, MediaType.APPLICATION_JSON));
			response.close();
		} finally {
			client.close();
		}
	}
}
