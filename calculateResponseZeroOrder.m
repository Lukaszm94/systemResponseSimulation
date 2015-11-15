function y = calculateResponseZeroOrder(u, sampleInterval, coefficients, systemDelay)
	systemOrder = 0;
	startIndex = 2 + systemOrder;
	b1 = coefficients(1);
	b0 = coefficients(2);
	
	simulationSteps = size(u)(2);
	y = zeros(1,simulationSteps);
	for k = startIndex : simulationSteps
		A = b1 * (u(k) - u(k-1)) / sampleInterval;
		B = b0 * u(k);
		y(k) = A + B;
	end
	y = shiftDelay(y, systemDelay / sampleInterval, 0); %system delay and index shifting taken into account
end