function[F] = CalculaSinc(amp, alpha, L, xdata)

F = amp*(exp(-2*alpha*L)*exp(2*1i*xdata*L)-1)./(2*1i*xdata*L-2*alpha*L);