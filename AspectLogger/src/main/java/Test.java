import pl.poznan.put.cs.logger.Logger;

public class Test {
	public static void main(String[] args) {
		Logger logger = new Logger();
		Integer newLogId = logger.getNewLogId();
		logger.log(newLogId, "logtestkey", "logtestvalue");
		Integer newTraceId = logger.getNewTraceId(newLogId);
		logger.log(newLogId, newTraceId, "tracetestkey", "tracetestvalue");
		Integer newEventId = logger.getNewEventId(newLogId, newTraceId);
		logger.log(newLogId, newTraceId, newEventId, "eventtestkey", "eventtestvalue");
		logger.serializeAll("log");
	}
}
