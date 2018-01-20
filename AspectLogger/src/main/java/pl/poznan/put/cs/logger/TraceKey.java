package pl.poznan.put.cs.logger;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;



public final class TraceKey {
	private static final int HASHCODE_PRIME1 = 113;
	private static final int HASHCODE_PRIME2 = 211;
	
	private final String r_id;
	private final int l_p_id;
	
	public TraceKey(String r_id, int l_p_id) {
		this.r_id = r_id;
		this.l_p_id = l_p_id;
	}
	
	@Override
	public int hashCode() {
		return new HashCodeBuilder(HASHCODE_PRIME1, HASHCODE_PRIME2)
				.append(r_id)
				.append(l_p_id)
				.toHashCode();
	}
	
	@Override
	public boolean equals(Object object) {
		if (!(object instanceof TraceKey)) {
			return false;
		}
		if (object == this) {
			return true;
		}
		
		TraceKey rhs = (TraceKey) object;
		return new EqualsBuilder()
				.append(r_id, rhs.r_id)
				.append(l_p_id, rhs.l_p_id)
				.isEquals();
	}
	
}
