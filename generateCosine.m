function u = generateCosine(bufferLength, amplitude, omega, phase, sampleInterval)
	u = zeros(1, bufferLength);
	for n = 1 : bufferLength
		t = n * sampleInterval;
		angle = omega * t + phase;
		u(n) = amplitude * cos(angle);
	end
end