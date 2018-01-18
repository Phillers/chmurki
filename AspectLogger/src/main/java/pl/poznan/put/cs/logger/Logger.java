package pl.poznan.put.cs.logger;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import org.deckfour.xes.model.XLog;
import org.deckfour.xes.model.impl.XAttributeMapImpl;
import org.deckfour.xes.model.impl.XLogImpl;
import org.deckfour.xes.out.XesXmlSerializer;

public class Logger {
	private XLog log;
	private Map<Integer, Mapper> mappers;
	private int uniqueId;
	
	
	public enum AttributeTypes {
		STRING("LITERAL");
		
		private String attributeType;
		
		AttributeTypes(String attributeType) {
			this.attributeType = attributeType;
		}
	}
	
	public Logger() {
		this.log = new XLogImpl(new XAttributeMapImpl());
		this.mappers = new HashMap<Integer, Mapper>();
		this.uniqueId = 0;
	}
	
	public Integer getNewTraceId() {
		return this.uniqueId++;
	}
	
	public Integer getNewEventId(Integer traceId) {
		Mapper mapper = this.getMapper(traceId);
		return mapper.getNewEventId();
	}
	
	public void log(Integer traceId, String key, String value) {
		log(traceId, null, key, value);
	}
	
	public void log(Integer traceId, Integer eventId, String key, String value) {
		Mapper mapper = this.getMapper(traceId);
		if (eventId == null) {
			mapper.log(key, value);
		} else {
			mapper.log(eventId, key, value);
		}
	}
	
	public void serializeLog(String outputFileName) {
		XesXmlSerializer serializer = new XesXmlSerializer();
		OutputStream outputStream = null;
		
		try {
			outputStream = new FileOutputStream(outputFileName);
			serializer.serialize(this.log, outputStream);
		} catch (FileNotFoundException fileNotFoundException) {
			System.err.println("Can't create file for output log: " + fileNotFoundException.getMessage());
		} catch (IOException ioException) {
			System.err.println("Can't serialize output log to file: " + ioException.getMessage());
		}
	}
	
	private Mapper getMapper(Integer traceId) {
		Mapper mapper = this.mappers.get(traceId);
		if (mapper == null) {
			mapper = new Mapper();
			this.mappers.put(traceId, mapper);
		}
		return mapper;
	}
}


