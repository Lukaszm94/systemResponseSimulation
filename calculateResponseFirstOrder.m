function y = calculateResponseFirstOrder(u, sampleInterval, coefficients, systemDelay)
	systemOrder = 1;
	startIndex = 1 + systemOrder;
	a1 = coefficients(1);
	b1 = coefficients(2);
	b0 = coefficients(3);
	
	simulationSteps = size(u)(2);
	y = zeros(1, simulationSteps);
	for k = startIndex : simulationSteps
		A = b1 * (u(k) - u(k-1)) / sampleInterval;
		B = b0 * u(k-1);
		C = y(k-1);
		D = y(k-1);
		y(k) = sampleInterval / a1 * (A + B - C) + D;
	end
	y = shiftDelay(y, systemDelay / sampleInterval, 0); %system delay and index shifting taken into account
end