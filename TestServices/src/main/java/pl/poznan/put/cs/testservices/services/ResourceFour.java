package pl.poznan.put.cs.testservices.services;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;

@Path("/resource4")
public class ResourceFour {
	
	@GET
	@Consumes("application/xml")
	public Response processResource() {
		return Response.ok().build();
	}
}
