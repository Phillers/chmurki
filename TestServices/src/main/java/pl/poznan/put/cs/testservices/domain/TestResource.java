package pl.poznan.put.cs.testservices.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown=true)
public class TestResource {
	private static final int MASK = 3;
	private static final int SHIFT = 2;
	private int number;
	
	public TestResource() {
		
	}
	
	public TestResource(int number) {
		this.number = number;
	}
	
	public int getNumber() {
		return this.number;
	}
	
	public int getRemainder() {
		return this.number & MASK;
	}
	
	public void shiftNumber() {
		this.number = (this.number >> SHIFT);
	}
}
