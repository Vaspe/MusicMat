%% Simplistic music sequencer monophonic matlab
clearvars
close all
clc

%% Define

Amp = 02 ;   % Amplitude. Kind of correlated with colume but also colour(?)
fs  = 44100 ;  % sampling frequency for reproduction (WAV cd quality = 44100)
saveflag = 1 ;
playback = 1 ;
save_songmat = 1;
filename ='ImperialMarch'; 
filename_wav = ['WavFolder/' filename '.wav'];
filename_songmat = ['SongsMat/' filename '.mat'];

%% Define tempo, tonality and kind of time signature
bpm = 200;
% based on your time signature and the smallest note you want to have
% e.g. if you are on 3/4 with 90bpm and you want eighth to be your base frequncy then
% Total beats per minute  90(bpm)*2(eigth) =180 hence Btime =60/180
BaseFactor = 2;  % eigths are the bae 
Btime = 60/(bpm*BaseFactor);  % every bar should have 6Btimes in a 3/4 signature with eigth as a base time
freqBase = 261.6; %[Hz] middle C 261.6 middle A 440

%% Define Tonality and diatonic scale

%(https://mysite.du.edu/~jcalvert/waves/music.htm or https://en.wikipedia.org/wiki/Piano_key_frequencies)
% Octave   = [1 9/8 5/4 4/3 3/2 5/3 15/8]; % Major diatonic octave 
%All 12 diatonic intervals:
% C  C#/Db  D  D#/Eb  E  F  F#/G  G#/Ab  A  A#/Bb  B
Allintervals = [1 1.06 1.125 1.189 1.25 1.333 1.414 1.5 1.587 1.682 1.782 1.875];
Rn  = Allintervals(1); %Root note
mi2 = Allintervals(2); %minor second
ma2 = Allintervals(3); %major second
mi3 = Allintervals(4); %minor third
ma3 = Allintervals(5); %major third
ma4 = Allintervals(6); %fourth
mi5 = Allintervals(7); %diminished fifth
ma5 = Allintervals(8); %fifth
mi6 = Allintervals(9); % minor sixth
ma6 = Allintervals(10); % major sixth
mi7 = Allintervals(11); % minor seventh
ma7 = Allintervals(12); % major seventh
Rest = 0; % 0 frequency to be played for the duration of the rest

%% Write your song in terms of notes and duration
DurNote =  [4,4,...   % bar1
            4,2,2,...
            4, 4,...
            4,2,2,   ...
            4,4,...
            4,3,1,...
            4,3,1,...
            8,...
            4,4,...
            4,3,1,...
            4,3,1,...
            4,...
            4,3,1,...
            4,3,1,...
            4, 4,...
            4,3,1,...
            4, 4,...
            4,3,1,...
            4,3,1,...
            4,...
            4,3,1,...
            4,3,1,...
            4, 4,...
            4,3,1,...
            4, 4,...
            4,3,1,...
            4,3,1,...
            4,2,2
      ];
                    
NotesPitch = [ma3/2, ma3/2,...  % bar1
             ma3/2, Rn/2,Rn/2,...
             ma3/2, ma3/2,...  % bar3
             ma3/2, Rn/2,Rn/2,...
             ma3,ma3,...    % bar5
             ma3,Rn,ma5...
             ma3,Rn,ma5...   % bar7
             ma3,...
             ma7,ma7,...  % bar9
             ma7,Rn*2,ma5...
             mi3,Rn,ma5,...  % bar11
             ma3,...
             ma3*2, ma3,ma3,...% bar13
             ma3*2,mi3*2,ma2*2,...
             mi2*2,ma4,...% bar15
             mi7,ma6,mi6,...
             ma5,Rn,...% bar17
             mi3,Rn,mi3,...
             ma5,ma3,ma5,...% bar19
             mi7,...
             ma3*2,ma3,ma3,...% bar21
             ma3*2,mi3*2,ma2*2,...
             mi2*2,ma4,...% bar23
             mi7,ma6,mi6,...
             ma5,Rn,...% bar25
             mi3, Rn, ma5,...
             ma3,Rn,ma5,...% bar27
             ma3,ma3,Rest   ];       
         
             
DurTotal = Btime*DurNote;
NotesPitchTot = freqBase*NotesPitch;

%% Playback
mysong = [];
for i = 1:length(NotesPitchTot)
    values = 0:1/fs:DurTotal(i);
    mysong = [mysong Amp*sin(2*pi*NotesPitchTot(i)*values)];    %#ok<*AGROW>
end

if playback ==1
    sound(mysong,fs);
end

%% Save in WAV

if saveflag==1
    audiowrite(filename_wav,mysong,fs);
end

%% Save in songmat format 

if save_songmat == 1
    songmat.DurNote    = DurNote;    % Mandatory Array with the duration of each note based on the base duration [60/(bpm*BaseFactor) in s]
    songmat.NotesPitch = NotesPitch; % Mandatory Array with all the note pitches in the song [Hz]
    songmat.bpm        = bpm;        % Optional the bpm of the song
    songmat.mysong     = mysong;     % Optional full song in wave
    songmat.BaseFactor = BaseFactor; % Optional Factor to calculate the metronome base time [-]
    songmat.Tonality   = freqBase;   % Optional root note tonality Hz  
    save(filename_songmat,'songmat')
end

