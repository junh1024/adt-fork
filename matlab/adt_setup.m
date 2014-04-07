function [ home ] = adt_setup( input_args )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    addpath(getuserdir('Documents','MATLAB','AmbiDecoderToolbox'));
    
end

function dir = userDir(varargin)
    
    switch computer()
        case {'PCWIN', 'PCWIN64'}  % matlab, windows
            home = char(java.lang.System.getProperty('user.home'));
        case {'GLNXA64'}           % matlab, linux
            home = char(java.lang.System.getProperty('user.home'));
        case {'MACI64'}            % matlab, macosx
            home = char(java.lang.System.getProperty('user.home'));
        case {'x86_64-apple-darwin13.0.2'} % octave, MacOSX 10.9.2(?)
            home = getenv('HOME');
        case {'i686_pc_mingw32'}           % octave, Win7
            home = getenv('USERPROFILE');
        case {'i686-pc-linux-gnu'}         % octave, Linux Ubuntu 12.04LTS
            home = getenv('HOME');
    end
            
end


function userDir = getuserdir(varargin)
%GETUSERDIR   return the user home directory.
%   USERDIR = GETUSERDIR returns the user home directory using the registry
%   on windows systems and using Java on non windows systems as a string
%   additional string arguments will be added to the path.
%
%   Example:
%      getuserdir() returns on windows
%           C:\Users\heller\Documents
%      on mac
%           /Users/heller
%      getuserdir('data', 'suav') 
%           /Users/heller/data/suav'

if exist('OCTAVE_VERSION','builtin') > 0
end
    
if ispc
    userDir = winqueryreg('HKEY_CURRENT_USER',...
        ['Software\Microsoft\Windows\CurrentVersion\' ...
         'Explorer\Shell Folders'],'Personal');
else
    userDir = char(java.lang.System.getProperty('user.home'));
end

%display(varargin);
userDir = fullfile(userDir, varargin{:});
end
