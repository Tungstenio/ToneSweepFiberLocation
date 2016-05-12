clear;
clc;
close all;

% Reads previously callibrated data.
Data         = csvread('CallibratedData.csv');
frequency    = Data(:,1);

%% Simulation Parameters

FiberEnd = 5500;   % Fibre Link Distance [m]
ng       = 1.447;  % Group Refraction Index
alpha_km = 0.21;   % Average fibre attenuation coefficient [db/km]
    
% The "real" parameters are a result of the standard
% OTDR probing of each testbench fiber.
realLoss       = 1.4;
realDistance   = 1587;
signature      = csvread('signature.csv');

% Signature is presented as an event list.
    
%% Get Experimental Values

y_real = Data(:,2); % Real part of the acquired signal.
y_imag = Data(:,3); % Imaginary part of the acquired signal.

y_real = hpfilter(y_real,1600);
y_imag = hpfilter(y_imag,1600);

%% ExtensiveSearch

tic();
[value,pos] = extensiveSearch(frequency,y_real,y_imag,ng,...
                              alpha_km,FiberEnd,signature);
toc();

% tic();
% [value,pos] = extensiveSearchUpdateCoeffs(frequency,y_real,y_imag,ng,...
%                                           alpha_km,FiberEnd,signature);
% toc();