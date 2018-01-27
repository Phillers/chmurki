package pl.poznan.put.cs.testservices;

import java.util.concurrent.ThreadLocalRandom;

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
		Client client = ClientBuilder.newClient();
		int startingNumber = ThreadLocalRandom.current().nextInt(0, 1024);
		try {
			Response response = client.target("http://localhost:8080/testservices/resource1/").request()
					.post(Entity.entity(new TestResource(startingNumber), MediaType.APPLICATION_JSON));
			if (response.getStatus() != 200) {
				throw new RuntimeException("Failed to send request");
			}
			response.close();
		} finally {
			client.close();
		}
	}
}
