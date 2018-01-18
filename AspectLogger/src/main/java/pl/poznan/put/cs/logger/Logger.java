package pl.poznan.put.cs.logger;

import java.util.HashMap;
import java.util.Map;

public class Logger {
	private Map<Integer, LogMapper> logMappers;
	int uniqueId;
	
	public Logger() {
		this.logMappers = new HashMap<Integer, LogMapper>();
	}
	
	public Integer getNewLogId() {
		return this.uniqueId++;
	}
	
	public Integer getNewTraceId(Integer logId) {
		LogMapper logMapper = this.getLogMapper(logId);
		return logMapper.getNewTraceId();
	}
	
	public Integer getNewEventId(Integer logId, Integer traceId) {
		LogMapper logMapper = this.getLogMapper(logId);
		return logMapper.getNewEventId(traceId);
	}
	
	public void log(Integer logId, String key, String value) {
		log(logId, null, null, key, value);
	}
	
	public void log(Integer logId, Integer traceId, String key, String value) {
		log(logId, traceId, null, key, value);
	}
	
	public void log(Integer logId, Integer traceId, Integer eventId, String key, String value) {
		LogMapper logMapper = this.getLogMapper(logId);
		if (traceId == null) {
			logMapper.log(key, value);
		} else if (eventId == null) {
			logMapper.log(traceId, key, value);
		} else {
			logMapper.log(traceId, eventId, key, value);
		}
	}
	
	public void serializeLog(Integer logId, String outputFileName) {
		LogMapper logMapper = this.getLogMapper(logId);
		logMapper.serializeLog(outputFileName);
	}
	
	public void serializeAll(String baseOutputFileName) {
		for (Integer key : this.logMappers.keySet()) {
			serializeLog(key, baseOutputFileName + key);
		}
	}
	
	private LogMapper getLogMapper(Integer logId) {
		LogMapper logMapper = this.logMappers.get(logId);
		if (logMapper == null) {
			logMapper = new LogMapper();
			this.logMappers.put(logId, logMapper);
		}
		return logMapper;
	}
	
	
}
