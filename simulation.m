%system and simulation settings
steps = 1000; %simulation steps
T_p = 0.1; %simulation time step [s]

%system constants
T_1 = 3;
T_2 = 25;
T_3 = 5;
T_d = 9;
b_1 = 2;
b_0 = 1.4;

%input signal parameters
pulseWidth = 1; %pulse width[s]
amplitude = 1; %input signal amplitude
cosineOmega = 0.2; %angular speed of cosine [rad/s]
cosinePhase = 60; %phase shift of cosine [deg]

%input type selection - step, pulse, cosine
%u = generateStep(steps, amplitude, 10/T_p);
%u = generatePulse(steps, amplitude, 10/T_p, 1/T_p);
u = generateCosine(steps, amplitude, cosineOmega, 2*pi*cosinePhase/360, T_p);




y=zeros(1,steps);

a_3 = T_1 * T_2;
a_2 = T_1 * T_3 + T_2;
a_1 = T_1 + T_3;

if(a_3 != 0)
	y = calculateResponseThirdOrder(u, T_p, [a_3, a_2, a_1, b_1, b_0], T_d);
elseif(a_2 != 0)
	y = calculateResponseSecondOrder(u, T_p, [a_2, a_1, b_1, b_0], T_d);
elseif(a_1 != 0)
	y = calculateResponseFirstOrder(u, T_p, [a_1, b_1, b_0], T_d);
else
	y = calculateResponseZeroOrder(u, T_p, [b_1, b_0], T_d);
end

t = 0 : steps-1;
if(size(y)(2) > steps)
	y = y(1 : steps); %adjust y vector length to match length of t
elseif((size(y)(2)) < steps)
	t = t(1 : (size(y)(2)));
	u = u(1 : size(y)(2));
end

plot(t*T_p, u,':', 'LineWidth', 2, t*T_p, y, 'LineWidth', 2);
title('System response - sinusoidal input, w=0.2rad/s', 'FontSize', 20);
%title('System response - step input', 'FontSize', 20);
xlabel('t[s]', 'FontSize', 20);
plotLegend = legend('u', 'y');
set(plotLegend, 'FontSize', 20);
grid;