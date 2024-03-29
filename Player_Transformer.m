%% Simplistic music player for monophonic matlab tracks
%
% General player and recorder in wav. I ta can load a mat song file and play it 
% as well as saving in wav format to a specific folder.   
%

clearvars
close all
clc

%% Define user inputs

Amp = 2 ;     % Amplitude. Kind of correlated with volume but also colour(?)
fs  = 44100 ;   % sampling frequency for reproduction (WAV cd quality = 44100)
saveflag = 0 ;  % save the wav file 
playback = 1 ;  % Playback the audio
use_original_Tonality   = 1;
use_original_basefactor = 1;
use_original_bpm = 1;
WAV2SaveFilename = 'WavFolder/BluesImpro1TEst.wav';
file_load = 'SongsMat/BluesImpro1.mat';

%% load songmat filefile 

load(file_load); % songmat loaded

%% Define tempo, tonality and kind of time signature
if ~isempty(songmat.bpm) && use_original_bpm==1
    bpm = songmat.bpm;
else
    bpm = 320;
end

if ~isempty(songmat.BaseFactor) && use_original_basefactor==1
    BaseFactor = songmat.BaseFactor;
else
    BaseFactor = 2;
end

if ~isempty(songmat.BaseFactor) && use_original_Tonality==1
    freqBase = songmat.Tonality;
else
    freqBase = 666;
end
% based on your time signature and the smallest note you want to have
% e.g. if you are on 3/4 with 90bpm and you want eighth to be your base frequncy then
% Total beats per minute  90(bpm)*2(eigth) =180 hence Btime =60/180
Btime = 60/(bpm*BaseFactor);  % every bar should have 6Btimes in a 3/4 signature with eigth as a base time

%% Your song in terms of notes and duration
DurTotal      = Btime*songmat.DurNote;
NotesPitchTot = freqBase*songmat.NotesPitch;

%% Create the total signal by adding the notes and effects 
    mysongNone = [];
    mysongTrap =[];
    mysongTri = [];
    for i = 1:length(NotesPitchTot)
        curTime = 0:1/fs:DurTotal(i);                      % time duration of the note
        curNote = Amp*sin(2*pi*NotesPitchTot(i)*curTime);  % sinwave of the note steady
        
        % Envelope of the wave of each note will give alonng with the
        % modulation the effect of a more realistic instrument
        curTime_midInd = ceil(numel(curTime)/2);          % get middle point of time
        scalFactTri  = [linspace(0,1,curTime_midInd) linspace(1,0,numel(curTime)-curTime_midInd) ]; % triangular scaling
        scalFactTrap = [linspace(0,1,floor(curTime_midInd/2)) ones(1,curTime_midInd) linspace(1,0,floor((numel(curTime)-curTime_midInd)/2) )]; % trapezoidal scaling
        if numel(scalFactTrap)< numel(curTime)
           scalFactTrap = [scalFactTrap(1:curTime_midInd) 1 scalFactTrap(curTime_midInd+1:end)];    
        end
        scalCurNoteTri  = scalFactTri.*curNote;
        scalCurNoteTrap  = scalFactTrap.*curNote;
        scalCurNote  =  curNote;

        mysongTri  = [mysongTri scalCurNoteTri];    %#ok<*AGROW>
        mysongTrap = [mysongTrap scalCurNoteTrap];    
        mysongNone = [mysongNone scalCurNote];   
        clear curTime curNote scalCurNote

    end
%% Playback    
if playback ==1    
    sound(mysongTrap,fs);
end

%% Save in WAV

if saveflag==1
    audiowrite(WAV2SaveFilename,mysongTrap,fs);
end
