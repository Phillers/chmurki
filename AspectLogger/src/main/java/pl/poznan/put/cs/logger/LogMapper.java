package pl.poznan.put.cs.logger;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import org.deckfour.xes.model.XAttributeMap;
import org.deckfour.xes.model.XLog;
import org.deckfour.xes.model.impl.XAttributeLiteralImpl;
import org.deckfour.xes.model.impl.XAttributeMapImpl;
import org.deckfour.xes.model.impl.XLogImpl;
import org.deckfour.xes.out.XesXmlSerializer;

class LogMapper {
	private XLog log;
	private Map<TraceKey, TraceMapper> traceMappers;
	
	public LogMapper() {
		this.log = new XLogImpl(new XAttributeMapImpl());
		this.traceMappers = new HashMap<TraceKey, TraceMapper>();
	}
	
	public void log(String key, String value) {
		XAttributeMap attributes = this.log.getAttributes();
		attributes.put(key, new XAttributeLiteralImpl(key, value));
		this.log.setAttributes(attributes);
	}
	
	public void log(TraceKey traceId, String key, String value) {
		log(traceId, null, key, value);
	}
	
	public void log(TraceKey traceId, EventKey eventId, String key, String value) {
		TraceMapper traceMapper = this.getTraceMapper(traceId);
		if (eventId == null) {
			traceMapper.log(key, value);
		} else {
			traceMapper.log(eventId, key, value);
		}
	}
	
	public void serializeLog(String outputFileName) {
		XesXmlSerializer serializer = new XesXmlSerializer();
		OutputStream outputStream = null;
		
		try {
			outputStream = new FileOutputStream(outputFileName + ".xes");
			serializer.serialize(this.log, outputStream);
		} catch (FileNotFoundException fileNotFoundException) {
			System.err.println("Can't create file for output log: " + fileNotFoundException.getMessage());
		} catch (IOException ioException) {
			System.err.println("Can't serialize output log to file: " + ioException.getMessage());
		}
	}
	
	private TraceMapper getTraceMapper(TraceKey traceId) {
		TraceMapper traceMapper = this.traceMappers.get(traceId);
		if (traceMapper == null) {
			traceMapper = new TraceMapper(this.log);
			this.traceMappers.put(traceId, traceMapper);
		}
		return traceMapper;
	}
}


