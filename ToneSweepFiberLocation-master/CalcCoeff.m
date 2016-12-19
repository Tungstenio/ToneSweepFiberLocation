function[originalCoeffs,newCoeff] = CalcCoeff(signatureFaults,newFault,InputPos)

%Includes the new fault in the correct order.
FaultListNew    = [signatureFaults(1:InputPos-1,1) ; newFault ; signatureFaults(InputPos:end,1)];
%Faults in dB are transformed to phasor amplitude coefficients.
FaultListLin    = [10.^(-FaultListNew/10); 0]; 
r               = length(FaultListLin);
coeffs          = zeros(r,1);
% Equation (8):
coeffs(1)       = (1-FaultListLin(1)^2);
for j = 2:r
    coeffs(j)   = prod(FaultListLin(1:j-1).^2) * (1-FaultListLin(j)^2);
end
originalCoeffs = [coeffs(1:InputPos-1,1) ; coeffs(InputPos+1:end,1)];
newCoeff       = coeffs(InputPos);