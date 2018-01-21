package pl.poznan.put.cs.aspects;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import javax.ws.rs.core.Response;

import pl.poznan.put.cs.logger.EventKey;
import pl.poznan.put.cs.logger.LogKey;
import pl.poznan.put.cs.logger.Logger;
import pl.poznan.put.cs.logger.TraceKey;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;

import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.ws.rs.DELETE;

public aspect aspectLogger {

	private Logger logger;
	private static final int MAIN_LOG_ID = 0;
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
	private int tracesPerFile = 2;
	private SimpleDateFormat sdf;

	aspectLogger() {
		this.logger = new Logger();
		propertiesMap = new HashMap<Integer, Properties>();
		sdf = new SimpleDateFormat("yyyy-MM-dd;HH:mm:ss:SSS");
	}

	pointcut pathClass(Path x):  @within(x);// && !@annotation(Path);
	// pointcut pathBoth(Path p1, Path p2): @annotation(p1) && @within(p2);

	pointcut methodProperties(Object targ, HttpHeaders headers, HttpServletRequest request) : target(targ) && args(headers,request,..);

	pointcut returningResponse() :  execution(Response *.*(..));

	pointcut returningVoid() :  execution(void *.*(..));

	pointcut returningObject() : execution(Object *.*()) && !returningResponse();

	pointcut annotated() : @annotation(GET) || @annotation(POST)|| @annotation(PUT) || @annotation(DELETE);

	pointcut getCall(Object targ) : call( * *.get(..)) && target(targ);

	pointcut postCall(Object targ) : call( * *.post(..)) && target(targ);

	pointcut putCall(Object targ) : call( * *.put(..)) && target(targ);

	pointcut deleteCall(Object targ) : call( * *.delete(..)) && target(targ);

	pointcut callFunction(Path p, Object o) : call(Response *.*(..)) && @within(p) &&this(o);

	pointcut syncInvokerCall(Path p, Object o) : call(Response *.*(..)) && @within(p) &&this(o) && (target(Invocation.Builder) || target(Invocation));

	pointcut requestCall(WebTarget targ, Path p) : call(* *.request(..)) && target(targ) && @within(p);

	Response around(Path x, Object target, HttpHeaders headers, HttpServletRequest request) : returningResponse() && annotated() && pathClass(x) && methodProperties(target, headers, request){
		String r_p_id = headers.getHeaderString("al_p_id");
		String source = headers.getHeaderString("al_url");
		String c_id = headers.getHeaderString("al_c_id");
		String local_addr = request.getRequestURL().toString();
		int l_p_id = target.hashCode();
		Properties props = new Properties();
		props.address = local_addr;
		props.c_id = 0;
		props.c_address = new HashMap<>();
		propertiesMap.put(l_p_id, props);
		if (source == "")
			source = request.getRemoteAddr();
		logEvent("executionResponse", target, "" + thisJoinPoint, r_p_id, source, local_addr, c_id, new Date());
		activeConnections++;
		Response response = proceed(x, target, headers, request);
		activeConnections--;
		propertiesMap.remove(l_p_id);
		logEvent("returningResponse", target, "return from " + thisJoinPoint, r_p_id, local_addr, source, c_id,
				new Date());
		loggedTraces++;
		if (activeConnections == 0)
			if (loggedTraces >= tracesPerFile) {
				this.logger.serializeAll(target.getClass().getSimpleName() + target.hashCode());
				loggedTraces = 0;
			}
		return Response.fromResponse(response).header("al_p_id", "" + l_p_id).header("al_c_id", c_id).build();
	}

	void around(Path x, Object target, HttpHeaders headers, HttpServletRequest request) : returningVoid() && annotated() && pathClass(x) && methodProperties(target, headers, request){
		String r_p_id = headers.getHeaderString("al_p_id");
		String source = headers.getHeaderString("al_url");
		String c_id = headers.getHeaderString("al_c_id");
		String local_addr = request.getRequestURL().toString();
		int l_p_id = target.hashCode();
		Properties props = new Properties();
		props.address = local_addr;
		props.c_id = 0;
		props.c_address = new HashMap<>();
		propertiesMap.put(l_p_id, props);
		if (source == "")
			source = request.getRemoteAddr();
		logEvent("executionNotResponse", target, "" + thisJoinPoint, r_p_id, source, local_addr, c_id, new Date());
		activeConnections++;
		proceed(x, target, headers, request);
		activeConnections--;
		propertiesMap.remove(l_p_id);
		logEvent("returningNotResponse", target, "return from " + thisJoinPoint, r_p_id, local_addr, source, c_id,
				new Date());
		loggedTraces++;
		if (activeConnections == 0)
			if (loggedTraces >= tracesPerFile) {
				this.logger.serializeAll(target.getClass().getSimpleName() + target.hashCode());
				loggedTraces = 0;
			}
	}

	before(Path x, Object target, HttpHeaders headers, HttpServletRequest request) : cflowbelow(execution(* *.*(..)) && annotated() && pathClass(Path) && methodProperties(target, headers, request))&& pathClass(x){
		logEvent(target, thisJoinPoint.toString());
	}

	after(WebTarget targ, Object o, Path p) returning(Invocation.Builder ib): requestCall(targ,p) && this(o){
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
		String dest=targ.getUri().toString();
		props.c_address.put(props.c_id, dest);
		logTempEvent(o, thisJoinPoint.toString(), source, dest, c_id);
		ib.header("al_p_id", "" + o.hashCode()).header("al_url", source).header("al_c_id", c_id);
	}

	Response around(Path p, Object o)  : syncInvokerCall(p,o) {
		int l_p_id = o.hashCode();
		Date time1 = new Date();

		Response response = proceed(p, o);

		Date time2 = new Date();
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
			e_type = "external";
		}

		logEvent(e_type+"Call", o, "" + thisJoinPoint, r_p_id, props.address, r_address, c_id, time1);

		logEvent(e_type+"Return", o, "return from " + thisJoinPoint, r_p_id, r_address, props.address, c_id, time2);

		return response;
	}

	Object around(Class T, Invocation.Builder x) : call(* *.*.get(..)) && target(x) && args(T){

		int l_p_id = thisJoinPoint.getThis().hashCode();
		Date time1 = new Date();

		Response response = x.get();

		Date time2 = new Date();
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
			e_type = "external";
		}

		logEvent(e_type+"Call", x, "" + thisJoinPoint, r_p_id, props.address, r_address, c_id, time1);

		logEvent(e_type+"Return", x, "return from " + thisJoinPoint, r_p_id, r_address, props.address, c_id, time2);

		return response.readEntity(T);
	}

	void logEvent(String e_type, Object target, String a_id, String r_p_id, String source, String dest, String c_id,
			Date time) {
		System.out.println("e_type=" + e_type);
		System.out.println("r_id=" + target.getClass().getName());
		System.out.println("a_id=" + a_id);
		System.out.println("l_p_id=" + target.hashCode());
		System.out.println("r_p_id=" + r_p_id);
		System.out.println("source=" + source);
		System.out.println("destination=" + dest);
		System.out.println("c_id=" + c_id);
		System.out.println("time=" + sdf.format(time));
		System.out.println("*************************************************");
		// logEventUsingLogger( target, a_id, r_p_id, source, dest, c_id,time);
	}

	void logEvent(Object target, String a_id) {
		System.out.println("e_type=" + "local");
		System.out.println("r_id=" + target.getClass().getName());
		System.out.println("a_id=" + a_id);
		System.out.println("l_p_id=" + target.hashCode());
		System.out.println("time=" + sdf.format(new Date()));
		System.out.println("*************************************************");
		// logEventUsingLogger(target, a_id);
	}

	void logTempEvent(Object target, String a_id, String source, String dest, String c_id) {
		System.out.println("e_type=" + "requestCreation");
		System.out.println("r_id=" + target.getClass().getName());
		System.out.println("a_id=" + a_id);
		System.out.println("l_p_id=" + target.hashCode());
		System.out.println("source=" + source);
		System.out.println("destination=" + dest);
		System.out.println("c_id=" + c_id);
		System.out.println("time=" + sdf.format(new Date()));
		System.out.println("*************************************************");
	}

	private void logEventUsingLogger(Object target, String a_id) {
		logEventUsingLogger(target, a_id, null, null, null, null, new Date());
	}

	private void logEventUsingLogger(Object target, String a_id, String r_p_id, String source, String destination,
			String c_id, Date time) {
		String r_id = target.getClass().getName();
		Integer l_p_id = target.hashCode();

		LogKey logKey = new LogKey(MAIN_LOG_ID);
		TraceKey traceKey = new TraceKey(r_id, l_p_id);
		Integer eventId = logger.getNewEventID(logKey, traceKey);
		EventKey eventKey = new EventKey(eventId);

		this.logger.log(logKey, traceKey, eventKey, "e_id", eventId.toString());
		this.logger.log(logKey, traceKey, eventKey, "r_id", target.getClass().getName());
		this.logger.log(logKey, traceKey, eventKey, "a_id", a_id);
		this.logger.log(logKey, traceKey, eventKey, "l_p_id", l_p_id.toString());

		if (r_p_id != null) {
			this.logger.log(logKey, traceKey, eventKey, "r_p_id", r_p_id);
			this.logger.log(logKey, traceKey, eventKey, "source", source);
			this.logger.log(logKey, traceKey, eventKey, "destination", destination);
			this.logger.log(logKey, traceKey, eventKey, "c_id", c_id);
		}

		this.logger.log(logKey, traceKey, eventKey, "time", time.toString());
	}

	protected void finalize() {
		this.logger.serializeAll("logs");
	}
}
