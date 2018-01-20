package pl.poznan.put.cs.logger;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

public class EventKey {
	private static final int HASHCODE_PRIME1 = 37;
	private static final int HASHCODE_PRIME2 = 199;

	private final int id;
	
	public EventKey(int id) {
		this.id = id;
	}
	
	@Override
	public int hashCode() {
		return new HashCodeBuilder(HASHCODE_PRIME1, HASHCODE_PRIME2)
				.append(id)
				.toHashCode();
	}
	
	@Override
	public boolean equals(Object object) {
		if (!(object instanceof EventKey)) {
			return false;
		}
		if (object == this) {
			return true;
		}
		
		EventKey rhs = (EventKey) object;
		return new EqualsBuilder()
				.append(id, rhs.id)
				.isEquals();
	}
}
