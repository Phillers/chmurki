package pl.poznan.put.cs.logger;

import java.util.HashMap;
import java.util.Map;

import org.deckfour.xes.model.XAttributeMap;
import org.deckfour.xes.model.XEvent;
import org.deckfour.xes.model.XLog;
import org.deckfour.xes.model.XTrace;
import org.deckfour.xes.model.impl.XAttributeLiteralImpl;
import org.deckfour.xes.model.impl.XAttributeMapImpl;
import org.deckfour.xes.model.impl.XEventImpl;
import org.deckfour.xes.model.impl.XTraceImpl;

class TraceMapper {
	private XTrace trace;
	private Map<EventKey, XEvent> eventMap;
	private int uniqueId;
	
	public TraceMapper(XLog log) {
		this.trace = new XTraceImpl(new XAttributeMapImpl());
		log.add(this.trace);
		this.eventMap = new HashMap<EventKey, XEvent>();
		this.uniqueId = 0;
	}
	
	public int getNewEventId() {
		return this.uniqueId++;
	}
	
	public void log(String key, String value) {
		XAttributeMap attributeMap = this.trace.getAttributes();
		attributeMap.put(key, new XAttributeLiteralImpl(key, value));
		this.trace.setAttributes(attributeMap);
	}
	
	public void log(EventKey eventKey, String key, String value) {
		XEvent event = this.getEvent(eventKey);
		XAttributeMap attributeMap = event.getAttributes();
		attributeMap.put(key, new XAttributeLiteralImpl(key, value));
		event.setAttributes(attributeMap);
	}
	
	private XEvent getEvent(EventKey eventKey) {
		XEvent event = this.eventMap.get(eventKey);
		if (event == null) {
			event = new XEventImpl(new XAttributeMapImpl());
			trace.add(event);
			this.eventMap.put(eventKey, event);
		}
		return event;
	}
}
