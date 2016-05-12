function [value,pos] = extensiveSearch(frequency,y_real,y_imag,n,alpha_km,Lmax,signature)

%% Initializations

L_simple  = 1:1:Lmax;              % Possible fault position candidates.
c         = 299792458;             % Light speed in vacuum.
k0        = 2*pi*frequency/(c/n);  % Wave number inside the fiber.
[L,k]     = meshgrid(L_simple,k0); % Constructs all possible candidates.
alpha     = (alpha_km/4.34)*1e-3;  % linear alpha in meters

N         = length(frequency);

% Equation (6):
exp_alpha = exp(-2*alpha*L);           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
exp_k     = exp(2*1i*k.*L);            %%       THEORETICAL       %%
den       = 2*1i*k.*L - 2*alpha*L;     %%          MODEL          %%
modelFunc = (exp_k.*exp_alpha-1)./den; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear memory. Vectors ans matrices might get really big.
clear L;
clear exp_alpha;
clear exp_k;
clear den;

%% Creating Inputs for Extensive Search

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

%% Extensive Search Loop

% We wish to find the better approximation for the measured signal given
% the fiber's signature (as-built) and an additional fault candidate.

Y = [y_real;y_imag];
X = [X_real;X_imag];

signaturePositions = [signature(:,1); Lmax];
signatureFaults    = signature(:,2);

% Get coeficients from fault magnitudes. These are passed in the as-built 
% event list in dB. Now, we must use Equation (8) of the article that
% describes the technique in order to transform deltas in coefficients.

signatureFaults = [10.^(-signatureFaults/10); 0]; 
r               = length(signatureFaults);
coeffs          = zeros(r,1);
% Equation (8):
coeffs(1)       = (1-signatureFaults(1)^2);
for i = 2:r
    coeffs(i) = prod(signatureFaults(1:i-1).^2) * (1-signatureFaults(i)^2);
end

Xsignature         = X(:,signaturePositions);
weightedXsignature = Xsignature*coeffs;
Xfit               = sum(weightedXsignature,2);

t = 1:length(Xfit);
figure();
plot(t',Xfit,t',Y);

errorActual = inf;
for i = 1:Lmax
    for newCoeff = 0:0.01:5
        Xgoal       = Xfit + newCoeff*X(:,i);
        error = sum((Xgoal - Y).^2)/N;
        if error < errorActual
            errorActual = error;
            pos         = i;
            value       = newCoeff;
        end
    end
end

FinalX = Xfit + value*X(:,pos);

figure();
plot(t',FinalX,t',Y);