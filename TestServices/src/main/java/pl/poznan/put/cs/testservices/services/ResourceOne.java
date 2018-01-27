package pl.poznan.put.cs.testservices.services;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import pl.poznan.put.cs.testservices.domain.TestResource;

@Path("/resource1")
public class ResourceOne {
	
	public ResourceOne() {
		
	}
	
	@GET
	public void test() {
		System.out.println("GET\n");
	}

	
	@POST
	@Consumes(MediaType.APPLICATION_JSON)
	public Response processResource(@Context HttpHeaders httpHeaders,
			@Context HttpServletRequest httpServletRequest, TestResource testResource) {
		System.out.println("Received request\n");
		return Response.ok().build();
	}
}
