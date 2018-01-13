package aspects;

import javax.ws.rs.Path;

import org.aspectj.lang.ProceedingJoinPoint;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;

import java.util.UUID;

import javax.ws.rs.DELETE;

public aspect aspectLogger {


	aspectLogger() {

	}

	pointcut pathMethod(Path x, Object targ) : execution( * *.*(..)) && @annotation(x) && !@within(Path) && target(targ);
	pointcut pathClass(Path x, Object targ): execution(* *.*(..)) && @within(x) && !@annotation(Path)&& target(targ);
	pointcut pathBoth(Path p1, Path p2, Object targ): execution(* *.*(..)) && @annotation(p1) && @within(p2)&& target(targ);

	pointcut getExec() : @annotation(GET);
	pointcut postExec() : @annotation(POST);
	pointcut putExec() : @annotation(PUT);
	pointcut deleteExec() : @annotation(DELETE);
	
	pointcut getCall(Object targ) : call( * *.get(..)) && target(targ);
	pointcut postCall(Object targ) : call( * *.post(..)) && target(targ);
	pointcut putCall(Object targ) : call( * *.put(..)) && target(targ);
	pointcut deleteCall(Object targ) : call( * *.delete(..)) && target(targ);
	
	before(Path x, Object targ) : pathMethod(x,targ) && getExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"GET "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+x);
		System.out.println("c_id="+"?");
	}
	
	after(Path x, Object targ) : pathMethod(x,targ){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"return "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+x);
		System.out.println("destination="+"?");
		System.out.println("c_id="+"?");
	}
	
	before(Path x, Object targ) : pathMethod(x,targ) && postExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"POST "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+x);
		System.out.println("c_id="+"?");
	}
	
	before(Path x, Object targ) : pathMethod(x,targ) && putExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"PUT "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+x);
		System.out.println("c_id="+"?");
	}
	
	before(Path x, Object targ) : pathMethod(x,targ) && deleteExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"DELETE "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+x);
		System.out.println("c_id="+"?");
	}
	
	before(Path x, Object targ) : pathClass(x,targ) && getExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"GET "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+x);
		System.out.println("c_id="+"?");
	}
	
	after(Path x, Object targ) : pathClass(x,targ){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"return "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+x);
		System.out.println("destination="+"?");
		System.out.println("c_id="+"?");
	}
	
	before(Path x, Object targ) : pathClass(x,targ) && postExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"POST "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+x);
		System.out.println("c_id="+"?");
	}
	
	before(Path x, Object targ) : pathClass(x,targ) && putExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"PUT "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+x);
		System.out.println("c_id="+"?");
	}
	
	before(Path x, Object targ) : pathClass(x,targ) && deleteExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"DELETE "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+x);
		System.out.println("c_id="+"?");
	}	
	
	before(Path p1,Path p2, Object targ) : pathBoth(p1, p2,targ) && getExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"GET "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+p2+p1);
		System.out.println("c_id="+"?");
	}
	
	after(Path p1,Path p2, Object targ) : pathBoth(p1, p2,targ){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"return "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+p2+p1);
		System.out.println("destination="+"?");
		System.out.println("c_id="+"?");
	}
	
	before(Path p1,Path p2, Object targ) : pathBoth(p1, p2,targ) && postExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"POST "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+p2+p1);
		System.out.println("c_id="+"?");
	}
	
	before(Path p1,Path p2, Object targ) : pathBoth(p1, p2,targ) && putExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"PUT "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+p2+p1);
		System.out.println("c_id="+"?");
	}
	
	before(Path p1,Path p2, Object targ) : pathBoth(p1, p2,targ) && deleteExec(){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+targ.getClass());
		System.out.println("a_id="+"DELETE "+thisJoinPoint);
		System.out.println("l_p_id="+targ.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+p2+p1);
		System.out.println("c_id="+"?");
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
}
