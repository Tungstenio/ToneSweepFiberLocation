function[Y,X] = InputNorm(y_real,y_imag,modelFunc,k,k0)

% Fitting as real and imaginary yields better results than doing it as
% magnitude and phase.

% Weighting Frequency (Y and X). We multiply by the sqrt of the frequency
% in order to compensate the 1/f limitation which may cause the fitting
% procedure to prioritize approximating the lower frequencies in detriment
% of the higher frequencies.

y_real    = sqrt(k0).*y_real;
y_imag    = sqrt(k0).*y_imag;

X_real    = real(sqrt(k).*modelFunc);
X_imag    = imag(sqrt(k).*modelFunc);

clear k;

% Weighting Distance (X and Y). Weighting the distance is also necessary in
% order to fit the data without bias.
WgtAvgY   = sqrt(1:(length(y_real)));
y_real    = y_real.*WgtAvgY';
y_imag    = y_imag.*WgtAvgY';

WgtAvgX   = repmat(WgtAvgY',1,size(X_real,2));
X_real    = X_real.*WgtAvgX;
X_imag    = X_imag.*WgtAvgX;

% Subtracting mean
y_real    = y_real - mean(y_real);
y_imag    = y_imag - mean(y_imag);

meanXReal = repmat(mean(X_real),length(X_real(:,1)),1);
X_real    = X_real - meanXReal;
meanXImag = repmat(mean(X_imag),length(X_imag(:,1)),1);
X_imag    = X_imag - meanXImag;

Y = [y_real;y_imag];
X = [X_real;X_imag];