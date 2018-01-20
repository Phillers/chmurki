import pl.poznan.put.cs.logger.EventKey;
import pl.poznan.put.cs.logger.LogKey;
import pl.poznan.put.cs.logger.Logger;
import pl.poznan.put.cs.logger.TraceKey;

public class Test {
	public static void main(String[] args) {
		Logger logger = new Logger();
		LogKey logKey = new LogKey(0);
		TraceKey traceKey = new TraceKey("traceKey1", 1);
		EventKey eventKey = new EventKey(0);
		logger.log(logKey, traceKey, eventKey, "testkey", "testvalue");
		TraceKey traceKey2 = new TraceKey("traceKey1", 1);
		EventKey eventKey2 = new EventKey(0);
		logger.log(logKey, traceKey2, eventKey2, "testkey2", "testvalue2");
		logger.serializeAll("log");
	}
}
