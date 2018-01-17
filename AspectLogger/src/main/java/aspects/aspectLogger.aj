package aspects;

import javax.ws.rs.Path;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.core.HttpHeaders;

import org.aspectj.lang.ProceedingJoinPoint;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;

import java.util.UUID;

import javax.ws.rs.DELETE;

public aspect aspectLogger {


	aspectLogger() {

	}

	//pointcut pathMethod(Path x, Object targ) : execution( * *.*(..)) && @annotation(x) && !@within(Path) && target(targ);
	pointcut pathClass(Path x, Object targ,HttpHeaders headers): execution(* *.*(..)) && @within(x) && !@annotation(Path)&& target(targ) && args(headers,..);
	pointcut pathBoth(Path p1, Path p2, Object targ,HttpHeaders headers): execution(* *.*(..)) && @annotation(p1) && @within(p2)&& target(targ)&& args(headers,..);

	pointcut getExec() : @annotation(GET);
	pointcut postExec() : @annotation(POST);
	pointcut putExec() : @annotation(PUT);
	pointcut deleteExec() : @annotation(DELETE);
	
	pointcut getCall(Object targ) : call( * *.get(..)) && target(targ);
	pointcut postCall(Object targ) : call( * *.post(..)) && target(targ);
	pointcut putCall(Object targ) : call( * *.put(..)) && target(targ);
	pointcut deleteCall(Object targ) : call( * *.delete(..)) && target(targ);
	
	pointcut requestCall(Object targ) : call(* *.request(..)) && target(targ);
	
//	before(Path x, Object targ) : pathMethod(x,targ) && getExec(){
//		System.out.println("e_id="+UUID.randomUUID());
//		System.out.println("r_id="+targ.getClass());
//		System.out.println("a_id="+"GET "+thisJoinPoint);
//		System.out.println("l_p_id="+targ.hashCode());
//		System.out.println("source="+"?");
//		System.out.println("destination="+x);
//		System.out.println("c_id="+"?");
//	}
//	
//	after(Path x, Object targ) : pathMethod(x,targ){
//		System.out.println("e_id="+UUID.randomUUID());
//		System.out.println("r_id="+targ.getClass());
//		System.out.println("a_id="+"return "+thisJoinPoint);
//		System.out.println("l_p_id="+targ.hashCode());
//		System.out.println("source="+x);
//		System.out.println("destination="+"?");
//		System.out.println("c_id="+"?");
//	}
//	
//	before(Path x, Object targ) : pathMethod(x,targ) && postExec(){
//		System.out.println("e_id="+UUID.randomUUID());
//		System.out.println("r_id="+targ.getClass());
//		System.out.println("a_id="+"POST "+thisJoinPoint);
//		System.out.println("l_p_id="+targ.hashCode());
//		System.out.println("source="+"?");
//		System.out.println("destination="+x);
//		System.out.println("c_id="+"?");
//	}
//	
//	before(Path x, Object targ) : pathMethod(x,targ) && putExec(){
//		System.out.println("e_id="+UUID.randomUUID());
//		System.out.println("r_id="+targ.getClass());
//		System.out.println("a_id="+"PUT "+thisJoinPoint);
//		System.out.println("l_p_id="+targ.hashCode());
//		System.out.println("source="+"?");
//		System.out.println("destination="+x);
//		System.out.println("c_id="+"?");
//	}
//	
//	before(Path x, Object targ) : pathMethod(x,targ) && deleteExec(){
//		System.out.println("e_id="+UUID.randomUUID());
//		System.out.println("r_id="+targ.getClass());
//		System.out.println("a_id="+"DELETE "+thisJoinPoint);
//		System.out.println("l_p_id="+targ.hashCode());
//		System.out.println("source="+"?");
//		System.out.println("destination="+x);
//		System.out.println("c_id="+"?");
//	}
	
	before(Path x, Object targ,HttpHeaders headers) : pathClass(x,targ,headers) && getExec(){
		logEvent(targ, "GET "+thisJoinPoint,""+x, headers);
	}
	
	after(Path x, Object targ,HttpHeaders headers) : pathClass(x,targ,headers){
		logEvent(targ, "return "+thisJoinPoint,""+x, headers);
	}
	
	before(Path x, Object targ,HttpHeaders headers) : pathClass(x,targ,headers) && postExec(){
		logEvent(targ, "POST "+thisJoinPoint,""+x, headers);
	}
	
	before(Path x, Object targ,HttpHeaders headers) : pathClass(x,targ,headers) && putExec(){
		logEvent(targ, "PUT "+thisJoinPoint,""+x, headers);
	}
	
	before(Path x, Object targ,HttpHeaders headers) : pathClass(x,targ,headers) && deleteExec(){
		logEvent(targ, "DELETE "+thisJoinPoint,""+x, headers);
	}	
	
	before(Path p1,Path p2, Object targ,HttpHeaders headers) : pathBoth(p1, p2,targ,headers) && getExec(){
		logEvent(targ, "GET "+thisJoinPoint,""+p2+p1, headers);
	}
	
	after(Path p1,Path p2, Object targ,HttpHeaders headers) : pathBoth(p1, p2,targ,headers){
		logEvent(targ, "return "+thisJoinPoint,""+p2+p1, headers);
	}
	
	before(Path p1,Path p2, Object targ,HttpHeaders headers) : pathBoth(p1, p2,targ,headers) && postExec(){
		logEvent(targ, "POST "+thisJoinPoint,""+p2+p1, headers);
	}
	
	before(Path p1,Path p2, Object targ,HttpHeaders headers) : pathBoth(p1, p2,targ,headers) && putExec(){
		logEvent(targ, "PUT "+thisJoinPoint,""+p2+p1, headers);
	}
	
	before(Path p1,Path p2, Object targ,HttpHeaders headers) : pathBoth(p1, p2,targ,headers) && deleteExec(){
		logEvent(targ, "DELETE "+thisJoinPoint,""+p2+p1, headers);
	}
	
	before (Object targ) : getCall(targ){
		System.out.println("GET " + targ + " " + thisJoinPoint);
	}
	
	before (Object targ) : postCall(targ){
		System.out.println("POST " + targ + " " + thisJoinPoint);
	}
	
	before (Object targ) : putCall(targ){
		System.out.println("PUT " + targ + " " + thisJoinPoint);
	}
	
	before (Object targ) : deleteCall(targ){
		System.out.println("DELETE " + targ + " " + thisJoinPoint);
	}
	
	after (Object targ, Object o) returning(Invocation.Builder ib): requestCall(targ) && this(o){
		System.out.println("REQUEST " + targ + " " + thisJoinPoint);
		System.out.println(ib.toString());
		ib.header("invoker", ""+o.hashCode());
	}
	
	void logEvent(Object target, String a_id,String path, HttpHeaders headers){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+target.getClass());
		System.out.println("a_id="+a_id);
		System.out.println("l_p_id="+target.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+path);
		System.out.println("c_id="+"?");
		System.out.println(headers.getRequestHeader("invoker").toString());

	}
	
}
