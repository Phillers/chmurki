package pl.poznan.put.cs.testservices.services;

import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
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
import static pl.poznan.put.cs.testservices.services.Constants.*;

@Path(RESOURCE_TWO_PATH)
public class ResourceTwo {
	
	private static final Logger LOGGER = Logger.getLogger(ResourceTwo.class.getName());
	
	public ResourceTwo() {
		
	}
	
	@POST
	@Consumes(MediaType.APPLICATION_JSON)
	public Response processResourceTwo(@Context HttpHeaders httpHeaders,
			@Context HttpServletRequest httpServletRequest, TestResource testResource) {
		String targetPort = "";
		String targetResourcePath = "";
		char lastCharacterInTestString = testResource.popFirstChar();
		if (lastCharacterInTestString != END_TEST_CHAR && lastCharacterInTestString != RESOURCE_TWO_CHAR)
		{
			LOGGER.log(Level.INFO, "Started processing request for ResourceTwo");
			switch (lastCharacterInTestString) {
			case RESOURCE_ONE_CHAR:
				targetPort = TESTSERVICE1_PORT;
				targetResourcePath = RESOURCE_ONE_PATH;
				break;
			case RESOURCE_THREE_CHAR:
				targetPort = TESTSERVICE1_PORT;
				targetResourcePath = RESOURCE_THREE_PATH;
				break;
			case RESOURCE_A_CHAR:
				targetPort = TESTSERVICE2_PORT;
				targetResourcePath = RESOURCE_A_PATH;
				break;
			case RESOURCE_B_CHAR:
				targetPort = TESTSERVICE2_PORT;
				targetResourcePath = RESOURCE_B_PATH;
				break;
			case RESOURCE_C_CHAR:
				targetPort = TESTSERVICE2_PORT;
				targetResourcePath = RESOURCE_C_PATH;
				break;
			default:
				break;
			}
			Client client = ClientBuilder.newClient();
			try {
				Response response = client.target("http://localhost:" + targetPort + Constants.APPLICATION_PATH + targetResourcePath)
						.request().post(Entity.entity(testResource, MediaType.APPLICATION_JSON));
				response.close();
			} finally {
				client.close();
			}
			LOGGER.log(Level.INFO, "Finished processing request for ResourceTwo");
		}
		return Response.ok().build();
	}
}
