%% Basic synthesizer
%
% Basic sythesizer capabilities to reproduce sounds
%
%

clearvars
close all


%% Global input definition

fs  = 44100/1;  % [Hz] sampling rate for payback
f0  = 30;    % [Hz] fundamental frequency
Amp = 0.8;    % [-] Wave's base amplitude
DurTotal = 1; % [s] total time duration of note 
Tvec = 0:1/fs:DurTotal;  % [s] time vector

%% Choose options

%make inputs for combining all the below

%% Waveform definition 

% Suggestions found online: 
%   Lead : Square, Saw
%   Pad : Square, Saw
%   Basses : Triangle, Square, Saw
%   Sub-Bass : Sine, Triangle

% Sine wave
BaseWave.sine.Tdom = Amp*sin(2*pi*f0*Tvec);
[BaseWave.sine.Fdom.S,BaseWave.sine.Fdom.f] = pwelch(BaseWave.sine.Tdom ,[],[],[],fs,'onesided');
sound(BaseWave.sine.Tdom,fs);        
pause(1.1)

% Square waveform
BaseWave.square.Tdom = Amp*square(2*pi*f0*Tvec);
[BaseWave.square.Fdom.S,BaseWave.square.Fdom.f] = pwelch(BaseWave.square.Tdom ,[],[],[],fs,'onesided');
sound(BaseWave.square.Tdom,fs);
pause(1.1)

%Triangle wave from
BaseWave.triangle.Tdom = Amp*sawtooth(2*pi*f0*Tvec,0.5);
[BaseWave.triangle.Fdom.S,BaseWave.triangle.Fdom.f] = pwelch(BaseWave.triangle.Tdom ,[],[],[],fs,'onesided');
sound(BaseWave.triangle.Tdom,fs);
pause(1.1)

% Saw tooth
BaseWave.sawtooth.Tdom = Amp*sawtooth(2*pi*f0*Tvec);
[BaseWave.sawtooth.Fdom.S,BaseWave.sawtooth.Fdom.f] = pwelch(BaseWave.sawtooth.Tdom ,[],[],[],fs,'onesided');
sound(BaseWave.sawtooth.Tdom,fs);
pause(1.1)

%Combined equally all
BaseWave.CombAll.Tdom = BaseWave.sawtooth.Tdom+BaseWave.square.Tdom+BaseWave.triangle.Tdom+BaseWave.sine.Tdom;
[BaseWave.CombAll.Fdom.S,BaseWave.CombAll.Fdom.f] = pwelch(BaseWave.CombAll.Tdom ,[],[],[],fs,'onesided');
sound(BaseWave.CombAll.Tdom,fs);
pause(1.1)

% plotting in time and frequency domain 
figure,plot(Tvec,BaseWave.sawtooth.Tdom,Tvec,BaseWave.square.Tdom,Tvec,BaseWave.sine.Tdom,Tvec,BaseWave.triangle.Tdom),...
    xlim([0.25 0.26]),ylim([-Amp-0.2 Amp+0.2]),legend({'SawTooth' 'Square' 'Sine' 'Triangle'}) ,title('Base waveform time domain'),grid on
% Frequency domain
figure,plot(BaseWave.sawtooth.Fdom.f,BaseWave.sawtooth.Fdom.S,BaseWave.square.Fdom.f,BaseWave.square.Fdom.S,BaseWave.sine.Fdom.f,BaseWave.sine.Fdom.S,BaseWave.triangle.Fdom.f,BaseWave.triangle.Fdom.S),...
    legend({'SawTooth' 'Square' 'Sine' 'Triangle'}) ,title('Base waveform frequency domain'),grid on
% Combined time
figure,plot(Tvec,(BaseWave.sawtooth.Tdom+BaseWave.square.Tdom+BaseWave.sine.Tdom+BaseWave.triangle.Tdom))
%     xlim([0.25 0.26]),ylim([-Amp-0.2 Amp+0.2])
legend({'Combined all'}) ,title('Combined Base waveform in time domain'),grid on
% Combined frequenct
figure,plot(BaseWave.CombAll.Fdom.f,BaseWave.CombAll.Fdom.S),...
    legend({'Combined all'}) ,title('Combined Base waveform frequency domain'),grid on

%% Envelope definition ADSR (attack, decay, sustain,release)



%% Low frequency occilator (LFO)



%% Harmonics manipulation


%% Filters

% low pass filter

% high pass filter

% Band pass filter

% band stop filter


%% Effects
        
        