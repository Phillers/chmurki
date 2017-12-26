package com.theopentutorials.jaxrs.calc;

import java.io.IOException;
import com.sun.jersey.api.container.httpserver.HttpServerFactory;
import com.sun.jersey.api.core.PackagesResourceConfig;
import com.sun.jersey.api.core.ResourceConfig;
import com.sun.net.httpserver.HttpServer;

public class CalcRESTStartUp {

	static final String BASE_URI = "http://localhost:9999/calcrest/";

	public static void main(String[] args) {
		try {
			ResourceConfig rc = new PackagesResourceConfig("com.theopentutorials.jaxrs.calc");
			HttpServer server = HttpServerFactory.create(BASE_URI,rc);
			server.start();
			System.out.println("Press Enter to stop the server. ");
			System.in.read();
			server.stop(0);
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}