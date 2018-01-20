package pl.poznan.put.cs.logger;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

public final class LogKey {
	private static final int HASHCODE_PRIME1 = 191;
	private static final int HASHCODE_PRIME2 = 11;

	private final int id;
	
	public LogKey(int id) {
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
		if (!(object instanceof LogKey)) {
			return false;
		}
		if (object == this) {
			return true;
		}
		
		LogKey rhs = (LogKey) object;
		return new EqualsBuilder()
				.append(id, rhs.id)
				.isEquals();
	}
}
