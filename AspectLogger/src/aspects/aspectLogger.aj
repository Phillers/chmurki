package aspects;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

import org.apache.logging.log4j.*;

public aspect aspectLogger {
	Logger logger;

	aspectLogger() {
		logger = LogManager.getRootLogger();

	}

	pointcut pathMethod(Path x) : execution( * *.*(..)) && @annotation(x) && !@within(Path);
	pointcut pathClass(Path x): execution(* *.*(..)) && @within(x) && !@annotation(Path);
	pointcut pathBoth(Path p1, Path p2): execution(* *.*(..)) && @annotation(p1) && @within(p2);
	
	pointcut getCall() : call( * *.get(..));

	before(Path x) : pathMethod(x){
		System.out.println(x.value());
	}
	
	before(Path x) : pathClass(x){
		System.out.println(x.value());
	}
	
	before(Path p1, Path p2) : pathBoth(p1, p2){
		System.out.println(p1.value()+" "+p2.value());
	}

	before() : getCall(){
		logger.error("GET" + thisJoinPoint.toString());
	}
}
