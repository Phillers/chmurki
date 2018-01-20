package pl.poznan.put.cs.aspects;

import java.util.HashMap;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

import pl.poznan.put.cs.logger.EventKey;
import pl.poznan.put.cs.logger.LogKey;
import pl.poznan.put.cs.logger.Logger;
import pl.poznan.put.cs.logger.TraceKey;


public aspect aspectLogger {
	
	private Logger logger;
	private static final int MAIN_LOG_ID = 0;
	long c_id=0;
	
	private class Properties{
		String address;
		
	}
	
	private HashMap<Integer,Properties> propertiesMap;
	private int activeConnections=0;
	
	aspectLogger() {
		this.logger = new Logger();
		propertiesMap=new HashMap<Integer,Properties>();
	}

		
	pointcut pathClass(Path x):  @within(x) && !@annotation(Path);
	pointcut pathBoth(Path p1, Path p2):  @annotation(p1) && @within(p2);

	pointcut methodProperties(Object targ,HttpHeaders headers, HttpServletRequest request) : target(targ) && args(headers,request,..);
	
	pointcut returningResponse() :  execution(Response *.*(..));
	pointcut returningVoid() :  execution(void *.*(..));
	pointcut returningObject() : execution(Object *.*()) && !returningResponse();
	
	pointcut annotated() : @annotation(GET) || @annotation(POST)|| @annotation(PUT) || @annotation(DELETE);
	
	pointcut getCall(Object targ) : call( * *.get(..)) && target(targ);
	pointcut postCall(Object targ) : call( * *.post(..)) && target(targ);
	pointcut putCall(Object targ) : call( * *.put(..)) && target(targ);
	pointcut deleteCall(Object targ) : call( * *.delete(..)) && target(targ);
	
	pointcut callFunction(Path p, Object o) : call(Response *.*(..)) && @within(p) &&this(o);
	
	pointcut requestCall(WebTarget targ, Path p) : call(* *.request(..)) && target(targ) && @within(p);
		

	Response around(Path x,Object target,HttpHeaders headers, HttpServletRequest request) : returningResponse() && annotated() && pathClass(x) && methodProperties(target, headers, request){
		logEvent(target, ""+thisJoinPoint,""+x.value(), headers);
		System.out.println(request.getRequestURL()+request.getRequestURI() +" "+request.getRemoteHost()+" "+request.getRemoteAddr());
		Response response = proceed(x,target,headers,request);
		System.out.println(response.getLocation());
		System.out.println(response);                              
		return Response.fromResponse(response).header("invoker", ""+target.hashCode()).build();
	}

	Response around(Path p1,Path p2,Object target,HttpHeaders headers, HttpServletRequest request) : returningResponse() && annotated() && pathBoth(p1,p2) && methodProperties(target, headers, request){
		logEvent(target, ""+thisJoinPoint,""+p2.value()+p1.value(), headers);
		System.out.println(request.getRequestURL()+request.getRequestURI() +" "+request.getRemoteHost()+" "+request.getRemoteAddr());
		Response response = proceed(p1,p2,target,headers,request);
		System.out.println(response.getLocation());
		System.out.println(response);                              
		return Response.fromResponse(response).header("invoker", ""+target.hashCode()).build();
	}
	
	Response around(Path x,Object target,HttpHeaders headers, HttpServletRequest request) : returningVoid() && annotated() && pathClass(x) && methodProperties(target, headers, request){
		logEvent(target, ""+thisJoinPoint,""+x.value(), headers);
		System.out.println(request.getRequestURL()+request.getRequestURI() +" "+request.getRemoteHost()+" "+request.getRemoteAddr());
		proceed(x,target,headers,request);
		proceed(x,target,headers,request);                              
		return Response.noContent().header("invoker", ""+target.hashCode()).build();
	}

	Response around(Path p1,Path p2,Object target,HttpHeaders headers, HttpServletRequest request) : returningVoid() && annotated() && pathBoth(p1,p2) && methodProperties(target, headers, request){
		logEvent(target, ""+thisJoinPoint,""+p2.value()+p1.value(), headers);
		System.out.println(request.getRequestURL()+request.getRequestURI() +" "+request.getRemoteHost()+" "+request.getRemoteAddr());
		proceed(p1,p2,target,headers,request);                              
		return Response.noContent().header("invoker", ""+target.hashCode()).build();
	}
	
	after (WebTarget targ, Object o,Path p) returning(Invocation.Builder ib): requestCall(targ,p) && this(o){
		System.out.println("REQUEST from "+ p.value() +" to "+ targ.getUri() + " " + thisJoinPoint);
		System.out.println(ib.toString());
		ib.header("invoker", ""+o.hashCode());
	}
	
	after(Path p, Object o) returning (Response response) : callFunction(p,o){
		System.out.println(p.value()+" "+""+o.hashCode());
		MultivaluedMap<String, Object> headers = response.getHeaders();
		for (String key : headers.keySet()) {
			System.out.println(key+" "+headers.getFirst(key));
		}
	}
	void logEvent(Object target, String a_id,String path, HttpHeaders headers){
		System.out.println("e_id="+UUID.randomUUID());
		System.out.println("r_id="+target.getClass());
		System.out.println("a_id="+a_id);
		System.out.println("l_p_id="+target.hashCode());
		System.out.println("source="+"?");
		System.out.println("destination="+path);
		System.out.println("c_id="+"?");
		MultivaluedMap<String, String> hdrs = headers.getRequestHeaders();
		for (String key : hdrs.keySet()) {
			System.out.println(key+" "+hdrs.getFirst(key));
		}
		
	}
	
	private void logEventUsingLogger(Object target, String a_id) {
		logEventUsingLogger(target, a_id, null, null, null, null);
	}
	
	private void logEventUsingLogger(Object target, String a_id, String l_p_id, String source, String destination, String c_id) {
		LogKey logKey = new LogKey(MAIN_LOG_ID);
		TraceKey traceKey = new TraceKey(target.getClass().getName(), target.hashCode());
		Integer eventId = logger.getNewEventID(logKey, traceKey);
		EventKey eventKey = new EventKey(eventId);
		
		this.logger.log(logKey, traceKey, eventKey, "e_id", eventId.toString());
		this.logger.log(logKey, traceKey, eventKey, "r_id", target.getClass().getName());
		this.logger.log(logKey, traceKey, eventKey, "a_id", a_id);
		
		if (l_p_id != null) {
			this.logger.log(logKey, traceKey, eventKey, "l_p_id", l_p_id);
			this.logger.log(logKey, traceKey, eventKey, "source", source);
			this.logger.log(logKey, traceKey, eventKey, "destination", destination);
			this.logger.log(logKey, traceKey, eventKey, "c_id", c_id);
		}
	}
	
}
