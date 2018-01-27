package pl.poznan.put.cs.testservices.domain;

import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class TestResource {
	private static final int DIVISOR = 4;
	private int number;
	
	public TestResource() {
		
	}
	
	public TestResource(int number) {
		this.number = number;
	}
	
	public static TestResource createFromRequest(String message) {
		try {
			DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			Document document = builder.parse(message);
			Element root = document.getDocumentElement();
			NodeList nodes = root.getChildNodes();
			int number = -1;
			for (int i = 0; i < nodes.getLength(); i++) {
				Element element = (Element) nodes.item(i);
				if (element.getTagName().equals("number")) {
					number = Integer.parseInt((element.getTextContent()));
				}
			}
			return new TestResource(number);
			}
		catch (Exception ex) {
			throw new WebApplicationException(ex, Response.Status.BAD_REQUEST);
		}
	}
	
	public static String makeInitialRequest(int number) {
		return "<testResource>"
				+ "<number>" + number + "</number>"
				+ "</testResource>";
	}
	
	public String makeRequest() {
		return "<testResource>"
				+ "<number>" + this.getNextNumber() + "</number>"
				+ "</testResource>";
	}
	
	public int getRemainder() {
		return this.number % DIVISOR;
	}
	
	private int getNextNumber() {
		return this.number / DIVISOR;
	}
}
