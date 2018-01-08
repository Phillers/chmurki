package aspects;

import javax.ws.rs.Path;

public aspect aspectLogger {


	aspectLogger() {

	}

	pointcut pathMethod(Path x, Object targ) : execution( * *.*(..)) && @annotation(x) && !@within(Path) && target(targ);
	pointcut pathClass(Path x, Object targ): execution(* *.*(..)) && @within(x) && !@annotation(Path)&& target(targ);
	pointcut pathBoth(Path p1, Path p2, Object targ): execution(* *.*(..)) && @annotation(p1) && @within(p2)&& target(targ);
	
	pointcut getCall() : call( * *.get(..));

	before(Path x, Object targ) : pathMethod(x,targ){
		System.out.println(x.value() +" "+ targ.hashCode() +" "+ this.hashCode());
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
		System.out.println(p1.value()+" "+p2.value() +" "+ targ.hashCode() +" "+ this.hashCode() +" "+x.toString());
	}

	before() : getCall(){
		System.out.println("GET" + thisJoinPoint.toString() + this.hashCode());
	}
}
