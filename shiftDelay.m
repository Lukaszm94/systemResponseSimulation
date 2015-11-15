function y = shiftDelay(buff, systemDelay, differentialDelay)
	[vectHeight bufferLength] = size(buff);
	shift = systemDelay - differentialDelay;
	if(shift > 0) %shift right and add zeros
		firstZeros = zeros(1, shift);
		y = horzcat(firstZeros, buff);
	elseif(shift < 0) %shift left and delete initial values
		shift = -shift;
		y = buff(shift + 1 : bufferLength);
	else
		y = buff;
	end
end