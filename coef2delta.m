function [ delta ] = coef2delta( coef )
%COEF2DELTA Summary of this function goes here
%   Detailed explanation goes here

delta=zeros(size(coef));

delta(1)=sqrt( 1-coef(1) );

for i = 2 : length(coef)
    
    delta(i)=sqrt( 1- coef(i)/(prod(delta(1:(i-1)).^2))  );    
    
end

delta=(delta);

%delta(end)=sqrt( coef(i)/(prod(delta(1:(end-1)).^2))  );