package pl.poznan.put.cs.testservices.services;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import pl.poznan.put.cs.testservices.domain.TestResource;

@Path("/starttest")
public class ResourceStartTest {
	
	/* Endpoint for starting the test by POSTing starting test string to ResourceOne
	 * Starting test string is supplied as path parameter
	 * Usage:
	 * curl -X GET "http://localhost:8080/testresources/starttest/{testString}"
	 * Example:
	 * curl -X GET "http://localhost:8080/testresources/starttest/A2B3C"
	 * This will result in flow: 1 -> A -> 2 -> B -> 3 -> C
	 */
	@GET
	@Path("{testString}")
	public Response startTest(@Context HttpHeaders httpHeaders,
			@Context HttpServletRequest httpServletRequest, @PathParam("testString") String testString) {
		String targetPort = Constants.TESTSERVICE1_PORT;
		String targetResourcePath = Constants.RESOURCE_ONE_PATH;
		TestResource testResource = new TestResource(testString);
		Client client = ClientBuilder.newClient();
		try {
			Response response = client.target(RequestHelper.prepareRequestString(targetPort, targetResourcePath))
					.request().post(Entity.entity(testResource, MediaType.APPLICATION_JSON));
			response.close();
		} finally {
			client.close();
		}
		
		return Response.ok().entity("Succesful test!\n").build();
	}
}
