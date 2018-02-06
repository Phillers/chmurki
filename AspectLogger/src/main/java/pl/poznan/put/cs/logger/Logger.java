package pl.poznan.put.cs.logger;

import java.util.HashMap;
import java.util.Map;

public final class Logger {
	private String baseOutputPath;
	private Map<LogKey, LogMapper> logMappers;
	
	public Logger() {
		this.baseOutputPath = "aspect-logs/";
		this.logMappers = new HashMap<LogKey, LogMapper>();
	}
	
	public int getNewEventID(LogKey logKey, TraceKey traceKey) {
		LogMapper logMapper = this.getLogMapper(logKey);
		return logMapper.getNewEventId(traceKey);
	}
	
	public void log(LogKey logKey, String key, String value) {
		this.log(logKey, null, null, key, value);
	}
	
	public void log(LogKey logKey, TraceKey traceKey, String key, String value) {
		this.log(logKey, traceKey, null, key, value);
	}
	
	public void log(LogKey logKey, TraceKey traceKey, EventKey eventKey, String key, String value) {
		LogMapper logMapper = this.getLogMapper(logKey);
		if (traceKey == null) {
			logMapper.log(key, value);
		} else if (eventKey == null) {
			logMapper.log(traceKey, key, value);
		} else {
			logMapper.log(traceKey, eventKey, key, value);
		}
	}
	
	public void serializeLog(LogKey logKey, String outputFilename) {
		LogMapper logMapper = this.getLogMapper(logKey);
		logMapper.serializeLog(this.baseOutputPath + outputFilename);
	}
	
	public void serializeAll(String baseOutputFilename) {
		for (LogKey key : this.logMappers.keySet()) {
			this.serializeLog(key, baseOutputFilename + "_" + key.getId());
		}
	}
	
	private LogMapper getLogMapper(LogKey logKey) {
		LogMapper logMapper = this.logMappers.get(logKey);
		if (logMapper == null) {
			logMapper = new LogMapper();
			this.logMappers.put(logKey, logMapper);
		}
		return logMapper;
	}
	
	
}
