function y = calculateResponseThirdOrder(u, sampleInterval, coefficients, systemDelay)
	systemOrder = 3;
	startIndex = 1 + systemOrder;
	a3 = coefficients(1);
	a2 = coefficients(2);
	a1 = coefficients(3);
	b1 = coefficients(4);
	b0 = coefficients(5);
	
	simulationSteps = size(u)(2);
	y = zeros(1, simulationSteps);
	for k = startIndex : simulationSteps
		A = b1 * (u(k-2) - u(k-3)) / sampleInterval;
		B = b0 * u(k-3);
		C = a2 * (y(k-1) - 2 * y(k-2) + y(k-3)) / (sampleInterval^2);
		D = a1 * (y(k-2) - y(k-3)) / sampleInterval;
		E = y(k-3);
		F = 3 * y(k-1) - 3 * y(k-2) + y(k-3);
		y(k) = sampleInterval^3 / a3 * (A + B - C - D - E) + F;
	end
	y = shiftDelay(y, systemDelay / sampleInterval, 1); %system delay and index shifting taken into account
end