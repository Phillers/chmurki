package pl.poznan.put.cs.logger;

import java.util.HashMap;
import java.util.Map;

public class Logger {
	private Map<LogKey, LogMapper> logMappers;
	
	public Logger() {
		this.logMappers = new HashMap<LogKey, LogMapper>();
	}
	
	public void log(LogKey logKey, String key, String value) {
		log(logKey, null, null, key, value);
	}
	
	public void log(LogKey logKey, TraceKey traceKey, String key, String value) {
		log(logKey, traceKey, null, key, value);
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
	
	public void serializeLog(LogKey logKey, String outputFileName) {
		LogMapper logMapper = this.getLogMapper(logKey);
		logMapper.serializeLog(outputFileName);
	}
	
	public void serializeAll(String baseOutputFileName) {
		for (LogKey key : this.logMappers.keySet()) {
			serializeLog(key, baseOutputFileName + key);
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
