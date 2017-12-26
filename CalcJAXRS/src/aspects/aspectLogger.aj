package aspects;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.logging.log4j.*
;

public aspect aspectLogger {
	Logger logger;
	aspectLogger(){
		logger = LogManager.getRootLogger();	

	}
pointcut pathExec(Path x, double a, double b) : execution( * *.*(..)) && @annotation(x) && args(a, b);
pointcut getCall() : call( * *.get(..));

before(Path x, double a, double b) : pathExec(x, a , b){
		logger.error("PATH" + x.value()+a+thisJoinPoint.toString());
}
before() : getCall(){
	logger.error("GET"+thisJoinPoint.toString());
}
}
