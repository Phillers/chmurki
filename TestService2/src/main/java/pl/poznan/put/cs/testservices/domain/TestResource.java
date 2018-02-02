package pl.poznan.put.cs.testservices.domain;

import pl.poznan.put.cs.testservices.services.Constants;

public class TestResource {
	private String string;
	
	public TestResource() {
		
	}
	
	public TestResource(String string) {
		this.string = string;
	}
	
	public String getString() {
		return this.string;
	}
	
	public char popFirstChar() {
		if (this.string.isEmpty()) {
			return Constants.END_TEST_CHAR;
		} else {
			char firstChar = string.charAt(0);
			this.string = this.string.substring(1);
			return firstChar;
		}
	}
}
