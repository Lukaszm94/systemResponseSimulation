function u = generatePulse(bufferLength, amplitude, pulseIndex, pulseLength)
	u = zeros(1, bufferLength);
	pulseEndIndex = pulseIndex + pulseLength;
	if(pulseEndIndex > bufferLength)
		pulseEndIndex = bufferLength;
	end
	for i = pulseIndex : pulseEndIndex
		u(i) = amplitude;
end