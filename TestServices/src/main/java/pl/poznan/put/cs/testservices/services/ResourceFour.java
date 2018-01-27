package pl.poznan.put.cs.testservices.services;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import pl.poznan.put.cs.testservices.domain.TestResource;

@Path("/resource4")
public class ResourceFour {
	
	public ResourceFour() {
		
	}
	
	@POST
	@Consumes(MediaType.APPLICATION_JSON)
	public Response processResourceFour(@Context HttpHeaders httpHeaders,
			@Context HttpServletRequest httpServletRequest, TestResource testResource) {
		if (testResource.getRemainder() >= 1 && testResource.getRemainder() <= 3) {
			String targetResourcePath = "";
			switch (testResource.getRemainder()) {
			case 1:
				targetResourcePath = "resource5/";
				break;
			case 2:
				targetResourcePath = "resource6/";
				break;
			case 3:
				targetResourcePath = "resource3/";
				break;
			default:
				break;
			}
			testResource.shiftNumber();
			Client client = ClientBuilder.newClient();
			try {
				Response response = client.target("http://localhost:8080/testservices/" + targetResourcePath).request()
						.post(Entity.entity(testResource, MediaType.APPLICATION_JSON));
				response.close();
			} finally {
				client.close();
			}
		}
		return Response.ok().build();
	}
}
