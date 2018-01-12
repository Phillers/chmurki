package aspects;

import javax.ws.rs.Path;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
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
	
	pointcut getCall() : call( * *.get(..));
	pointcut postCall() : call( * *.post(..));
	pointcut putCall() : call( * *.put(..));
	pointcut deleteCall() : call( * *.delete(..));
	
	before(Path x, Object targ) : pathMethod(x,targ){
		System.out.println(x.value() +" "+ targ.hashCode() +" "+ this.hashCode());
		targ.getClass();
	}
	
	before(Path x, Object targ) : pathClass(x,targ){
		System.out.println(x.value() +" "+ targ.hashCode() +" "+ this.hashCode());
	}
	
	before(Path p1, Path p2, Object targ) : pathBoth(p1, p2,targ){
		System.out.print(p1.value()+" "+p2.value() +" "+ targ.hashCode() +" "+ this.hashCode());
		for(Object x : thisJoinPoint.getArgs()) System.out.print(" "+x);
		System.out.println();
	}
	
	after(Path p1, Path p2, Object targ) returning(Object x): pathBoth(p1, p2,targ){
		System.out.println(p1.value()+" "+p2.value() +" "+ targ.hashCode() +" "+ this.hashCode() +" "+x);
	}

	before() : getCall(){
		System.out.println("GET " + thisJoinPoint.toString() + this.hashCode());
	}
	
	before() : postCall(){
		System.out.println("POST " + thisJoinPoint.toString() + this.hashCode());
	}
	
	before() : putCall(){
		System.out.println("PUT " + thisJoinPoint.toString() + this.hashCode());
	}
	
	before() : deleteCall(){
		System.out.println("DELETE " + thisJoinPoint.toString() + this.hashCode());
	}
}
