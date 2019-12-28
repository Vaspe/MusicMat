%% Basic synthesizer
%
% Basic sythesizer capabilities to reproduce sounds
%
%

clearvars
close all
addpath(genpath('Functions'))

%% Global input definition

fs  = 44100/1;  % [Hz] sampling rate for payback
f0  = 440.0;    % [Hz] fundamental frequency
AmpSine   = 1;    % [-] Wave's base amplitude
AmpSquare = 1;    % [-] Wave's base amplitude
AmpTriangle = 1;    % [-] Wave's base amplitude
AmpSaw   = 1;    % [-] Wave's base amplitude
DurTotal = 2; % [s] total time duration of note 
Tvec = 0:1/fs:DurTotal;  % [s] time vector

% Base waveform is an addition of multiple waves
sine_coeff   = 1; % from 0 to 1 
square_coeff = 0; % from 0 to 1 
triangle_coeff = 0; % from 0 to 1 
sawtooth_coeff = 0.1; % from 0 to 1 

% Envelope settings (linear only for now)
Att_val = 0.1; % [s] attack: time from 0 to max Amplitude (0 means basically no attack phase, going directly to max)
Att_over_val = 1.2; % level of overshoot in the attack phase
Dec_val = 0.6; % [s] decay: time from max Amplitude to nominal amplitude (0 means o decay phase, foing directly to sustain amplitude)
Sus_val = 1.5; % [s] sustain: time the sound is kept to nominal amplitude (100 keeps the set amplitude, 0 means decay finishes directly to silence )
Sus_level = 1;
Rel_val = 1; % [s] release: time from nominal to zero amplitude (0 means instantaneous transition from sustain to silence. If sustain 0 then release is automatically 0)

%% Choose options

%make inputs for combining all the below

%% Waveform definition 

% Suggestions found online: 
%   Lead : Square, Saw
%   Pad : Square, Saw
%   Basses : Triangle, Square, Saw
%   Sub-Bass : Sine, Triangle

% Sine wave
BaseWave.sine.Tdom = AmpSine*sin(2*pi*f0*Tvec);
[BaseWave.sine.Fdom.S,BaseWave.sine.Fdom.f] = pwelch(BaseWave.sine.Tdom ,[],[],[],fs,'onesided');
% sound(BaseWave.sine.Tdom,fs);        
% pause(DurTotal+0.1)

% Square waveform
BaseWave.square.Tdom = AmpSquare*square(2*pi*f0*Tvec);
[BaseWave.square.Fdom.S,BaseWave.square.Fdom.f] = pwelch(BaseWave.square.Tdom ,[],[],[],fs,'onesided');
% sound(BaseWave.square.Tdom,fs);
% pause(DurTotal+0.1)

%Triangle wave from
BaseWave.triangle.Tdom = AmpTriangle*sawtooth(2*pi*f0*Tvec,0.5);
[BaseWave.triangle.Fdom.S,BaseWave.triangle.Fdom.f] = pwelch(BaseWave.triangle.Tdom ,[],[],[],fs,'onesided');
% sound(BaseWave.triangle.Tdom,fs);
% pause(DurTotal+0.1)

% Saw tooth
BaseWave.sawtooth.Tdom = AmpSaw*sawtooth(2*pi*f0*Tvec);
[BaseWave.sawtooth.Fdom.S,BaseWave.sawtooth.Fdom.f] = pwelch(BaseWave.sawtooth.Tdom ,[],[],[],fs,'onesided');
% sound(BaseWave.sawtooth.Tdom,fs);
% pause(DurTotal+0.1)

%Combined all with the coefficients
BaseWave.CombAll.Tdom = sawtooth_coeff*BaseWave.sawtooth.Tdom+square_coeff*BaseWave.square.Tdom+triangle_coeff*BaseWave.triangle.Tdom+sine_coeff*BaseWave.sine.Tdom;
[BaseWave.CombAll.Fdom.S,BaseWave.CombAll.Fdom.f] = pwelch(BaseWave.CombAll.Tdom ,[],[],[],fs,'onesided');
% sound(BaseWave.CombAll.Tdom,fs);
% pause(DurTotal+0.1)

% % plotting in time and frequency domain 
% figure,plot(Tvec,BaseWave.sawtooth.Tdom,Tvec,BaseWave.square.Tdom,Tvec,BaseWave.sine.Tdom,Tvec,BaseWave.triangle.Tdom),...
%     xlim([0.25 0.26]),ylim([-Amp-0.2 Amp+0.2]),legend({'SawTooth' 'Square' 'Sine' 'Triangle'}) ,title('Base waveform time domain'),grid on
% % Frequency domain
% figure,plot(BaseWave.sawtooth.Fdom.f,BaseWave.sawtooth.Fdom.S,BaseWave.square.Fdom.f,BaseWave.square.Fdom.S,BaseWave.sine.Fdom.f,BaseWave.sine.Fdom.S,BaseWave.triangle.Fdom.f,BaseWave.triangle.Fdom.S),...
%     legend({'SawTooth' 'Square' 'Sine' 'Triangle'}) ,title('Base waveform frequency domain'),grid on

% Combined time domain
figure,plot(Tvec,BaseWave.CombAll.Tdom)
xlim([0.5 0.55]),ylim([-AmpSine-0.2 AmpSine+0.2])
legend({'Combined'}) ,title('Combined Base waveform in time domain'),grid on
% Combined frequency domain
figure,plot(BaseWave.CombAll.Fdom.f,BaseWave.CombAll.Fdom.S)
legend({'Combined all'}) ,title('Combined Base waveform frequency domain'),grid on
xlim([0 f0*10])

%% Envelope definition ADSR (attack, decay, sustain, release)

% multiply the whole waveform time with a time dependent shape function based on ADSR
ADSR_env = calculate_ADSR(fs,Tvec,Att_val,Att_over_val,Dec_val,Sus_val,Sus_level,Rel_val,'linear');
BaseWave.CombAll.Tdom = ADSR_env.*BaseWave.CombAll.Tdom;
sound(BaseWave.CombAll.Tdom,fs);
pause(DurTotal+0.1)

% plot time series after applying envelope
figure,plot(Tvec,BaseWave.CombAll.Tdom)
ylim([-AmpSine-0.2 AmpSine+0.2])
legend({'Combined'}) ,title('Combined Base waveform in time domain'),grid on

%% Low frequency occilator (LFO)
aa=1;


%% Harmonics manipulation


%% Filters

% low pass filter

% high pass filter

% Band pass filter

% band stop filter


%% Effects
        
        