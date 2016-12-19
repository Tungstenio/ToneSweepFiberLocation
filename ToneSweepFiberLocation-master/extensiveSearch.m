function [value,pos,Xfit,Y,FinalX] = extensiveSearch(frequency,y_real,y_imag,ng,alpha_km,Lmax,signature)

%% Initializations

L_simple  = 1:1:Lmax;               % Possible fault position candidates.
c         = 299792458;              % Light speed in vacuum.
k0        = 2*pi*frequency/(c/ng);  % Wave number inside the fiber.
[L,k]     = meshgrid(L_simple,k0);  % Constructs all possible candidates.
alpha     = (alpha_km/4.34)*1e-3;   % linear alpha in meters

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

[Y,X] = InputNorm(y_real,y_imag,modelFunc,k,k0);

%% Extensive Search

signaturePositions = [signature(:,1); Lmax];
signatureFaults    = signature(:,2);

% Get coeficients from fault magnitudes. These are passed in the as-built 
% event list in dB. Now, we must use Equation (8) of the article that
% describes the technique in order to transform deltas in coefficients.

Xsignature = X(:,signaturePositions);

errorActual = inf;
% for i = 1:Lmax-1
for i = 1:Lmax-1
    %Determine in which position of the vector the new candidate should be
    %included.
    PosListNew   = [signaturePositions ; i];
    [~,T]       = sort(PosListNew);
    InputPos     = find(T==length(PosListNew));
    for newFault = 0.1:0.1:5
        [originalCoeffs,newCoeff] = CalcCoeff(signatureFaults,newFault,InputPos);
        Xfit           = sum(Xsignature*originalCoeffs,2);
        Xgoal          = Xfit + newCoeff*X(:,i);
        error          = mean( (Xgoal-Y).^2 );%immse(Xgoal,Y);
        if error < errorActual
            errorActual = error;
            pos         = i;
            coeffFinal  = newCoeff;
            value       = newFault;
            XfitFinal   = Xfit;
        end
    end
end

FinalX = XfitFinal + coeffFinal*X(:,pos);

%Compensating for differences in refractive index from OTDR and standard
%values.
pos = ceil(pos*1.4682/1.447);