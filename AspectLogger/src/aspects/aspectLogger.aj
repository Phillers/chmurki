package aspects;

import javax.ws.rs.GET;

import org.apache.logging.log4j.*;

public aspect aspectLogger {
	Logger logger;

	aspectLogger() {
		logger = LogManager.getRootLogger();

	}

	pointcut pathExec(GET x) : execution( * *.*(..)) && @annotation(x);

	pointcut getCall() : call( * *.get(..));

	before(GET x) : pathExec(x){
		logger.error("GET" + thisJoinPoint.toString());
	}

	before() : getCall(){
		logger.error("GET" + thisJoinPoint.toString());
	}
}
