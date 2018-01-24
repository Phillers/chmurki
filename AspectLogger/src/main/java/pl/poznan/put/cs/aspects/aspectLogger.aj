package pl.poznan.put.cs.aspects;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;


import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.HEAD;
import javax.ws.rs.OPTIONS;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.Response;

import pl.poznan.put.cs.logger.EventKey;
import pl.poznan.put.cs.logger.LogKey;
import pl.poznan.put.cs.logger.Logger;
import pl.poznan.put.cs.logger.TraceKey;



public aspect aspectLogger {
	private Logger logger;
	private LogKey logKey;
	private static final int MAIN_LOG_ID = 0;
	private static final String LOCAL = "local";
	private static final String REQUEST_CREATION = "requestCreation";
	long c_id = 0;

	public class Properties {
		String address;
		int c_id;
		HashMap<Integer, String> c_address;
		int instanceNo;

		Properties() {
			c_address = new HashMap<>();
		}
	}

	private HashMap<Integer, Properties> propertiesMap;
	private int activeConnections = 0;
	private int loggedTraces = 0;
	private int tracesPerFile = 1;
	private SimpleDateFormat sdf;
	private SimpleDateFormat filenameDF;
	
	aspectLogger() {
		this.logger = new Logger();
		this.logKey = new LogKey(MAIN_LOG_ID);
		this.propertiesMap = new HashMap<Integer, Properties>();
		this.sdf = new SimpleDateFormat("yyyy-MM-dd;HH:mm:ss:SSS");
		this.filenameDF = new SimpleDateFormat("yyMMddHHmmssSSS");
	}

	pointcut pathClass(Path x):  @within(x);// && !@annotation(Path);
	// pointcut pathBoth(Path p1, Path p2): @annotation(p1) && @within(p2);

	pointcut methodProperties(Object targ, HttpHeaders headers, HttpServletRequest request) : target(targ) && args(headers,request,..);

	pointcut returningResponse() :  execution(Response *.*(..));

	pointcut returningVoid() :  execution(void *.*(..));

	pointcut returningObject() : execution(* *.*()) && !returningResponse() && !returningVoid();

	pointcut annotated() : @annotation(GET) || @annotation(POST)|| @annotation(PUT) || @annotation(DELETE)|| @annotation(HEAD)|| @annotation(OPTIONS);

	pointcut invokeClass(Invocation target, Class returnType, Object o) : call(* *.invoke(Class)) && target(target) && args(returnType) && this(o) && @within(Path);
	pointcut invokeGenType(Invocation target, GenericType returnType, Object o) : call(* *.invoke(Class)) && target(target) && args(returnType) && this(o) && @within(Path);
	
	pointcut getClass(Invocation.Builder target, Class returnType, Object o) : call( * *.get(..)) && target(target) && args(returnType) && this(o) && @within(Path);
	pointcut getGenType(Invocation.Builder target, GenericType returnType, Object o) : call( * *.get(..)) && target(target) && args(returnType) && this(o) && @within(Path);
	
	pointcut postClass(Invocation.Builder target, Class returnType, Object o, Entity arg) : call( * *.post(..)) && target(target) && args(arg, returnType) && this(o) && @within(Path);
	pointcut postGenType(Invocation.Builder target, GenericType returnType, Object o, Entity arg) : call( * *.post(..)) && target(target) && args(arg, returnType) && this(o) && @within(Path);
	
	pointcut putClass(Invocation.Builder target, Class returnType, Object o, Entity arg) : call( * *.put(..)) && target(target) && args(arg, returnType) && this(o) && @within(Path);
	pointcut putGenType(Invocation.Builder target, GenericType returnType, Object o, Entity arg) : call( * *.put(..)) && target(target) && args(arg, returnType) && this(o) && @within(Path);
	
	pointcut deleteClass(Invocation.Builder target, Class returnType, Object o) : call( * *.delete(..)) && target(target) && args(returnType) && this(o) && @within(Path);
	pointcut deleteGenType(Invocation.Builder target, GenericType returnType, Object o) : call( * *.delete(..)) && target(target) && args(returnType) && this(o) && @within(Path);
	
	pointcut optionsClass(Invocation.Builder target, Class returnType, Object o) : call( * *.options(..)) && target(target) && args(returnType) && this(o) && @within(Path);
	pointcut optionsGenType(Invocation.Builder target, GenericType returnType, Object o) : call( * *.options(..)) && target(target) && args(returnType) && this(o) && @within(Path);
	
	pointcut callReturningResponse(Object o) : call(Response *.*(..)) && @within(Path) &&this(o) && (target(Invocation.Builder) || target(Invocation));

	pointcut requestCall(WebTarget targ, Path p, Object o) : call(* *.request(..)) && target(targ) && @within(p) && this(o);

	Response around(Path x, Object target, HttpHeaders headers, HttpServletRequest request) : returningResponse() && annotated() && pathClass(x) && methodProperties(target, headers, request){
		String r_p_id = headers.getHeaderString("al_p_id");
		String source = headers.getHeaderString("al_url");
		String c_id = headers.getHeaderString("al_c_id");
		String local_addr = request.getRequestURL().toString();
		beforeProceed(target, local_addr, r_p_id, source, c_id, "executionResponse", thisJoinPoint.toString());
		Response response = proceed(x, target, headers, request);
		afterProceed(target, r_p_id, local_addr, source, c_id, "returningResponse", thisJoinPoint.toString());
		return Response.fromResponse(response).header("al_p_id", "" + target.hashCode()).header("al_c_id", c_id).build();
	}

	void around(Path x, Object target, HttpHeaders headers, HttpServletRequest request) : returningVoid() && annotated() && pathClass(x) && methodProperties(target, headers, request){
		String r_p_id = headers.getHeaderString("al_p_id");
		String source = headers.getHeaderString("al_url");
		String c_id = headers.getHeaderString("al_c_id");
		String local_addr = request.getRequestURL().toString();
		beforeProceed(target, local_addr, r_p_id, source, c_id, "executionNotResponse", thisJoinPoint.toString());
		proceed(x, target, headers, request);
		afterProceed(target, r_p_id, local_addr, source, c_id, "returningNotResponse", thisJoinPoint.toString());
	}
	
	Object around(Path x, Object target, HttpHeaders headers, HttpServletRequest request) : returningObject() && annotated() && pathClass(x) && methodProperties(target, headers, request){
		String r_p_id = headers.getHeaderString("al_p_id");
		String source = headers.getHeaderString("al_url");
		String c_id = headers.getHeaderString("al_c_id");
		String local_addr = request.getRequestURL().toString();
		if (source == null)
			source = request.getRemoteAddr();
		beforeProceed(target, local_addr, r_p_id, source, c_id, "executionNotResponse", thisJoinPoint.toString());
		Object response=proceed(x, target, headers, request);
		afterProceed(target, r_p_id, local_addr, source, c_id, "returningNotResponse", thisJoinPoint.toString());
		return response;
	}
	
	void beforeProceed(Object target, String local_addr, String r_p_id, String source, String c_id, String e_type, String a_id){	
		Properties props = new Properties();
		props.address = local_addr;
		props.c_id = 0;
		props.c_address = new HashMap<>();
		propertiesMap.put(target.hashCode(), props);
		logEvent(e_type, target, a_id, r_p_id, source, local_addr, c_id, new Date());
		activeConnections++;
	}
	
	void afterProceed(Object target, String r_p_id, String local_addr, String source, String c_id, String e_type, String a_id){
		activeConnections--;
		propertiesMap.remove(target.hashCode());
		logEvent(e_type, target, "return from " + a_id, r_p_id, local_addr, source, c_id,
				new Date());
		loggedTraces++;
		if (activeConnections == 0)
			if (loggedTraces >= tracesPerFile) {
				serialize(target.getClass().getSimpleName() +"_"+ target.hashCode() + "_" +filenameDF.format(new Date()));
				loggedTraces = 0;
			}
	}

	before(Path x, Object target, HttpHeaders headers, HttpServletRequest request) : cflowbelow(execution(* *.*(..)) && annotated() && pathClass(Path) && methodProperties(target, headers, request))&& pathClass(x){
		logEvent(target, thisJoinPoint.toString());
	}

	after(WebTarget targ, Object o, Path p) returning(Invocation.Builder ib): requestCall(targ,p,o) {
		int l_p_id = o.hashCode();
		Properties props = propertiesMap.get(l_p_id);
		if (props == null) {
			props = new Properties();
			props.address = "/client/";
			props.c_id = 0;
			propertiesMap.put(l_p_id, props);
		}
		String source = props.address;
		props.c_id++;
		String c_id = "" + props.c_id;
		String dest = targ.getUri().toString();
		props.c_address.put(props.c_id, dest);
		logTempEvent(o, thisJoinPoint.toString(), source, dest, c_id);
		ib.header("al_p_id", "" + o.hashCode()).header("al_url", source).header("al_c_id", c_id);
	}

	Response around(Object o)  : callReturningResponse(o) {		
		Date time1 = new Date();
		Response response = proceed(o);
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response;
	}
	
	Object around(Invocation target, Class returnType, Object o)  : invokeClass(target, returnType, o) {		
		Date time1 = new Date();
		Response response = target.invoke();
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation target, GenericType returnType, Object o)  : invokeGenType(target, returnType, o) {		
		Date time1 = new Date();
		Response response = target.invoke();
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, GenericType returnType, Object o) : getGenType(target, returnType, o){
		Date time1 = new Date();
		Response response = target.get();
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, Class returnType, Object o) : getClass(target, returnType, o){
		Date time1 = new Date();
		Response response = target.get();
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, Class returnType, Object o) : deleteClass(target, returnType, o){
		Date time1 = new Date();
		Response response = target.delete();
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, GenericType returnType, Object o) : deleteGenType(target, returnType, o){
		Date time1 = new Date();
		Response response = target.delete();
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, Class returnType, Object o) : optionsClass(target, returnType, o){
		Date time1 = new Date();
		Response response = target.options();
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, GenericType returnType, Object o) : optionsGenType(target, returnType, o){
		Date time1 = new Date();
		Response response = target.options();
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, Class returnType, Object o, Entity e) : postClass(target, returnType, o, e){
		Date time1 = new Date();
		Response response = target.post(e);
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, GenericType returnType, Object o, Entity e) : postGenType(target, returnType, o, e){
		Date time1 = new Date();
		Response response = target.post(e);
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, Class returnType, Object o, Entity e) : putClass(target, returnType, o, e){
		Date time1 = new Date();
		Response response = target.put(e);
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	Object around(Invocation.Builder target, GenericType returnType, Object o, Entity e) : putGenType(target, returnType, o, e){
		Date time1 = new Date();
		Response response = target.put(e);
		Date time2 = new Date();
		proceedResponse(response, time1, time2, o, thisJoinPoint.toString());
		return response.readEntity(returnType);
	}
	
	void proceedResponse(Response response, Date time1, Date time2, Object o, String joinPoint){
		int l_p_id = o.hashCode();
		String r_p_id = response.getHeaderString("al_p_id");
		String c_id = response.getHeaderString("al_c_id");

		Properties props = propertiesMap.get(l_p_id);
		int c_id_int;
		String r_address = "";
		String e_type = "";
		if (c_id != null) {
			c_id_int = new Integer(c_id);
			r_address = props.c_address.get(c_id_int);
			e_type = "service";
		} else {

			props.c_id++;
			c_id = "" + props.c_id;
			r_address = "" + response.getLocation();
			r_p_id = "";
			e_type = "external";
		}

		logEvent(e_type + "Call", o, "" + joinPoint, r_p_id, props.address, r_address, c_id, time1);

		logEvent(e_type + "Return", o, "return from " + joinPoint, r_p_id, r_address, props.address, c_id, time2);
	}


	void logEvent(Object target, String a_id) {
		String r_id = target.getClass().getName();
		Integer l_p_id = target.hashCode();
		
		System.out.println("e_type=" + this.LOCAL);
		System.out.println("r_id=" + r_id);
		System.out.println("a_id=" + a_id);
		System.out.println("l_p_id=" + l_p_id);
		System.out.println("time=" + sdf.format(new Date()));
		System.out.println("*************************************************");
		
		TraceKey traceKey = new TraceKey(r_id, l_p_id);
		Integer eventId = logger.getNewEventID(this.logKey, traceKey);
		EventKey eventKey = new EventKey(eventId);
		
		this.logger.log(this.logKey, traceKey, eventKey, "e_type", this.LOCAL);
		this.logger.log(this.logKey, traceKey, eventKey, "r_id", r_id);
		this.logger.log(this.logKey, traceKey, eventKey, "a_id", a_id);
		this.logger.log(this.logKey, traceKey, eventKey, "l_p_id", l_p_id.toString());
		this.logger.log(this.logKey, traceKey, eventKey, "time", sdf.format(new Date()));
	}


	void logEvent(String e_type, Object target, String a_id, String r_p_id, String source, String dest, String c_id,
			Date time) {
		String r_id = target.getClass().getName();
		Integer l_p_id = target.hashCode();
		
		System.out.println("e_type=" + e_type);
		System.out.println("r_id=" + r_id);
		System.out.println("a_id=" + a_id);
		System.out.println("l_p_id=" + l_p_id);
		System.out.println("r_p_id=" + r_p_id);
		System.out.println("source=" + source);
		System.out.println("destination=" + dest);
		System.out.println("c_id=" + c_id);
		System.out.println("time=" + sdf.format(time));
		System.out.println("*************************************************");
		
		TraceKey traceKey = new TraceKey(r_id, l_p_id);
		Integer eventId = logger.getNewEventID(this.logKey, traceKey);
		EventKey eventKey = new EventKey(eventId);
		
		this.logger.log(this.logKey, traceKey, eventKey, "e_type", e_type);
		this.logger.log(this.logKey, traceKey, eventKey, "r_id", r_id);
		this.logger.log(this.logKey, traceKey, eventKey, "a_id", a_id);
		this.logger.log(this.logKey, traceKey, eventKey, "l_p_id", l_p_id.toString());
		this.logger.log(this.logKey, traceKey, eventKey, "r_p_id", r_p_id);
		this.logger.log(this.logKey, traceKey, eventKey, "source", source);
		this.logger.log(this.logKey, traceKey, eventKey, "destination", dest);
		this.logger.log(this.logKey, traceKey, eventKey, "c_id", c_id);
		this.logger.log(this.logKey, traceKey, eventKey, "time", sdf.format(time));
	}

	void logTempEvent(Object target, String a_id, String source, String dest, String c_id) {
		String r_id = target.getClass().getName();
		Integer l_p_id = target.hashCode();
		
		System.out.println("e_type=" + this.REQUEST_CREATION);
		System.out.println("r_id=" + r_id);
		System.out.println("a_id=" + a_id);
		System.out.println("l_p_id=" + l_p_id);
		System.out.println("source=" + source);
		System.out.println("destination=" + dest);
		System.out.println("c_id=" + c_id);
		System.out.println("time=" + sdf.format(new Date()));
		System.out.println("*************************************************");
		
		TraceKey traceKey = new TraceKey(r_id, l_p_id);
		Integer eventId = logger.getNewEventID(this.logKey, traceKey);
		EventKey eventKey = new EventKey(eventId);
		
		this.logger.log(this.logKey, traceKey, eventKey, "e_type", this.REQUEST_CREATION);
		this.logger.log(this.logKey, traceKey, eventKey, "r_id", r_id);
		this.logger.log(this.logKey, traceKey, eventKey, "a_id", a_id);
		this.logger.log(this.logKey, traceKey, eventKey, "l_p_id", l_p_id.toString());
		this.logger.log(this.logKey, traceKey, eventKey, "source", source);
		this.logger.log(this.logKey, traceKey, eventKey, "destination", dest);
		this.logger.log(this.logKey, traceKey, eventKey, "c_id", c_id);
		this.logger.log(this.logKey, traceKey, eventKey, "time", sdf.format(new Date()));
	}

	void serialize(String filename){
		this.logger.serializeLog(this.logKey, filename);
	}
//	
//	private void logEventUsingLogger(Object target, String a_id) {
//		logEventUsingLogger(target, a_id, null, null, null, null, new Date());
//	}
//
//	private void logEventUsingLogger(Object target, String a_id, String r_p_id, String source, String destination,
//			String c_id, Date time) {
//		String r_id = target.getClass().getName();
//		Integer l_p_id = target.hashCode();
//
//		TraceKey traceKey = new TraceKey(r_id, l_p_id);
//		Integer eventId = logger.getNewEventID(this.logKey, traceKey);
//		EventKey eventKey = new EventKey(eventId);
//
//		this.logger.log(this.logKey, traceKey, eventKey, "e_id", eventId.toString());
//		this.logger.log(this.logKey, traceKey, eventKey, "r_id", r_id);
//		this.logger.log(this.logKey, traceKey, eventKey, "a_id", a_id);
//		this.logger.log(this.logKey, traceKey, eventKey, "l_p_id", l_p_id.toString());
//
//		if (r_p_id != null) {
//			this.logger.log(this.logKey, traceKey, eventKey, "r_p_id", r_p_id);
//			this.logger.log(this.logKey, traceKey, eventKey, "source", source);
//			this.logger.log(this.logKey, traceKey, eventKey, "destination", destination);
//			this.logger.log(this.logKey, traceKey, eventKey, "c_id", c_id);
//		}
//
//		this.logger.log(this.logKey, traceKey, eventKey, "time", time.toString());
//	}

	protected void finalize() {
		this.logger.serializeAll("logs");
	}
}
