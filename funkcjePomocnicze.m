% PLIK generateStep.m
function u = generateStep(bufferLength, amplitude, pulseStartIndex)
	u = zeros(1, bufferLength);
	if(pulseStartIndex < 1)
		pulseLength = 1;
	end
	for i = pulseStartIndex : bufferLength
		u(i) = amplitude;
	end
end

% PLIK generatePulse.m
function u = generatePulse(bufferLength, amplitude, pulseIndex, pulseLength)
	u = zeros(1, bufferLength);
	pulseEndIndex = pulseIndex + pulseLength;
	if(pulseEndIndex > bufferLength)
		pulseEndIndex = bufferLength;
	end
	for i = pulseIndex : pulseEndIndex
		u(i) = amplitude;
end

% PLIK generateCosine.m
function u = generateCosine(bufferLength, amplitude, omega, phase, sampleInterval)
	u = zeros(1, bufferLength);
	for n = 1 : bufferLength
		t = n * sampleInterval;
		angle = omega * t + phase;
		u(n) = amplitude * cos(angle);
	end
end

%PLIK calculateResponseThirdOrder.m
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
	y = shiftDelay(y, systemDelay / sampleInterval, 1); %uwzglednienie przesuniec indeksow wynikajacych z opoznienia transportowego i sposobu wyznaczania y(k)
end

% PLIK calculateResponseSecondOrder.m
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
	y = shiftDelay(y, systemDelay / sampleInterval, 1); %uwzglednienie przesuniec indeksow wynikajacych z opoznienia transportowego i sposobu wyznaczania y(k)
end

% PLIK calculateResponseFirstOrder.m
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
	y = shiftDelay(y, systemDelay / sampleInterval, 0); %uwzglednienie przesuniec indeksow wynikajacych z opoznienia transportowego i sposobu wyznaczania y(k)
end

% PLIK calculateResponseZeroOrder.m
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
	y = shiftDelay(y, systemDelay / sampleInterval, 0); %uwzglednienie przesuniec indeksow wynikajacych z opoznienia transportowego i sposobu wyznaczania y(k)
end

% PLIK shiftDelay.m
function y = shiftDelay(buff, systemDelay, differentialDelay)
	[vectHeight bufferLength] = size(buff);
	shift = systemDelay - differentialDelay;
	if(shift > 0) %przesun w prawo i dodaj zera na poczatku
		firstZeros = zeros(1, shift);
		y = horzcat(firstZeros, buff);
	elseif(shift < 0) %przesun w lewo usuwajac poczatkowe wartosci
		shift = -shift;
		y = buff(shift + 1 : bufferLength);
	else
		y = buff;
	end
end