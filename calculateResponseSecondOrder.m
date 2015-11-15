function y = calculateResponseSecondOrder(u, sampleInterval, coefficients, systemDelay)
	systemOrder = 2;
	startIndex = 1 + systemOrder;
	a2 = coefficients(1);
	a1 = coefficients(2);
	b1 = coefficients(3);
	b0 = coefficients(4);
	
	simulationSteps = size(u)(2);
	y = zeros(1, simulationSteps);
	for k = startIndex : simulationSteps
		A = b1 * (u(k-1) - u(k-2)) / sampleInterval;
		B = b0 * u(k-2);
		C = a1 * (y(k-1) - y(k-2)) / sampleInterval;
		D = y(k-2);
		E = 2 * y(k-1) - y(k-2);
		y(k) = sampleInterval^2 / a2 * (A + B - C - D) + E;
	end
	y = shiftDelay(y, systemDelay / sampleInterval, 1); %system delay and index shifting taken into account
end