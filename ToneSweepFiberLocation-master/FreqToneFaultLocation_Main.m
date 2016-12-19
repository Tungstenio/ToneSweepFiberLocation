clear;
clc;
close all;

s = ' ';
figure('units','normalized','outerposition',[0 0 1 1]);
h1 = subplot(2,2,1);
axis([0 2000 -0.2 0.2]);
ht1 = title('Fiber Signature and Acquired Data');
set(ht1,'FontSize',20);
set(gca,'FontSize',16);
h2 = subplot(2,2,3);
axis([0 2000 -0.2 0.2]);
ht2 = title('Best Approximation and Acquired Data');
set(ht2,'FontSize',20);
set(gca,'FontSize',16);
A = uicontrol('Units','normalized',...
'Position',[0.5,0.1,0.45,0.82],...
'Style','edit',...
'Max',100,...
'Enable','inactive',...
'FontSize',20,...
'String',s);

S{1} = sprintf('----------------------------------------------------------------');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' in Sub-Carrier Multiplexed Optical Fiber Networks');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf('A Low-Frequency Tone Sweep Method for in-Service Fault Location');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf('----------------------------------------------------------------');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);
S{1} = sprintf('Version 1.0 beta');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf('Written by: Gustavo Amaral');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);


%% Reads previously callibrated data.
S{1} = sprintf('Loading Callibrated data...');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
Data         = csvread('CallibratedData.csv');
S{1} = sprintf('Loading Callibrated data completed');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);
frequency    = Data(:,1);

%% Simulation Parameters

S{1} = sprintf('Loading Parameters...');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
Param         = csvread('Parameters.csv');
S{1} = sprintf('Loading Parameters completed');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);

FiberEnd = Param(1); % 5500;   % Fibre Link Distance [m]
ng       = Param(2); % 1.447;  % Group Refraction Index
alpha_km = Param(3); % 0.21;   % Average fibre attenuation coefficient [db/km]
    
% The "real" parameters are a result of the standard
% OTDR probing of each testbench fiber.
realLoss       = Param(4); % 0.6  [dB];
realDistance   = Param(5); % 1575 [m];

%% Reads previously obtained signature.
S{1} = sprintf('Loading Signature data...');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
signature      = csvread('signature.csv');
S{1} = sprintf('Loading Signature data completed');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);

% Signature is presented as an event list.
    
%% Get Experimental Values

%split existing signal into real and imaginary parts

y_real = Data(:,2); % Real part of the acquired signal.
y_imag = Data(:,3); % Imaginary part of the acquired signal.

% smoothing data, to remove high frequency noise

y_real = hpfilter(y_real,1600);
y_imag = hpfilter(y_imag,1600);

%% ExtensiveSearch
S{1} = sprintf('Running extensive search algorithm...');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
tic();
[value,pos,Xfit,Y,FinalX] = extensiveSearch(frequency,y_real,y_imag,ng,...
                              alpha_km,FiberEnd,signature);
t = toc();
S{1} = sprintf('Extensive search algorithm finished');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);

S{1} = sprintf('----------------------------------------------------------------');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(['Elapsed Time is: ' num2str(t) ' seconds']);
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf('----------------------------------------------------------------');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);

%% Output results
S{1} = sprintf('----------------------------------------------------------------');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(['Position   [m]: ',num2str(pos)]);
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(['Amplitude [dB]: ',num2str(value)]);
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf('Results from the Low-Frequency fault detection method:');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf('----------------------------------------------------------------');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);

S{1} = sprintf('----------------------------------------------------------------');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(['Position   [m]: ',num2str(realDistance)]);
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(['Amplitude [dB]: ',num2str(realLoss)]);
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf('Reference values (standard OTDR):');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf('----------------------------------------------------------------');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);

S{1} = sprintf('FIBER ANALYSIS COMPLETED!');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/100);
S{1} = sprintf(' ');
oldmsgs = cellstr(get(A,'String'));
set(A,'String',[S;oldmsgs] );
pause(1/2);

hold on;
subplot(2,2,1);
t = 1:length(Xfit);
plot(t',Xfit,'linewidth',3);
hold on;
plot(t',Y,'--','linewidth',3);
hold off;
axis([0 2000 -0.2 0.2]);
hl1 = legend('Fiber Signature','Acquired Data');
set(hl1,'FontSize',18);
ht1 = title('Fiber Signature and Acquired Data');
set(ht1,'FontSize',20);
set(gca,'FontSize',16);
subplot(2,2,3);
plot(t',FinalX,'linewidth',3);
hold on;
plot(t',Y,'--','linewidth',3);
hold off;
axis([0 2000 -0.2 0.2]);
hl1 = legend('Best Approximation','Acquired Data');
set(hl1,'FontSize',18);
title('Best Approximation and Acquired Data');
set(ht1,'FontSize',20);
set(gca,'FontSize',16);
