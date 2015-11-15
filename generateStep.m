function u = generateStep(bufferLength, amplitude, pulseStartIndex)
	u = zeros(1, bufferLength);
	if(pulseStartIndex < 1)
		pulseLength = 1;
	end
	for i = pulseStartIndex : bufferLength
		u(i) = amplitude;
	end
end